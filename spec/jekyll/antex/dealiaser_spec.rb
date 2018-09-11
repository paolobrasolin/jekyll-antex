# frozen_string_literal: true

require 'jekyll/antex/alias'

# TODO: reafactor into spec for Generator#render_tag
xdescribe 'Jekyll::Antex::Dealiaser' do
  describe 'initialized object' do
    subject { described_class.new([]) }

    it { is_expected.to respond_to(:matchers) }
  end

  describe '#add_aliases' do
    subject { described_class.new(aliases) }

    let(:aliases) do
      [
        { regexp: /(?<code>)/, priority: 10 },
        { regexp: /(?<code>)/, priority: 1000 },
        { regexp: /(?<code>)/, priority: 100 },
        { regexp: /(?<code>)/, priority: 10_000 }
      ].map(&Jekyll::Antex::Alias.method(:new))
    end

    it 'adds all passed aliases' do
      expect(subject.matchers).to match_array aliases
    end

    it 'sorts passed aliases by priority' do
      expect(subject.matchers.map(&:priority)).to eq [10_000, 1000, 100, 10]
    end
  end

  describe '#parse' do
    subject { described_class.new(aliases) }

    let(:aliases) do
      [
        { regexp: /FOO(?<code>.*?)OOF/, priority: 10 },
        { regexp: /BAR(?<code>.*?)RAB/, priority: 100 },
        { regexp: /BAZ(?<markup>.*?)#(?<code>.*?)ZAB/, priority: 0,
          options: { 'a' => 1, 'b' => 2 } }
      ].map(&Jekyll::Antex::Alias.method(:new))
    end

    it 'replaces the simplest alias' do
      text = subject.lift(<<~INPUT)
        FOO code here OOF
      INPUT

      expect(subject.tap(&:bake).drop(text)).to eq <<~OUTPUT
        {% antex --- {}
         %} code here {% endantex %}
      OUTPUT
    end

    # NOTE: keeps paolobrasolin/jekyll-antex#11 in check
    it 'keeps backslashes intact' do
      text = subject.lift(<<~'INPUT')
        FOO a \ b \\ c \\\ d \\\\ d OOF
      INPUT

      expect(subject.tap(&:bake).drop(text)).to eq <<~'OUTPUT'
        {% antex --- {}
         %} a \ b \\ c \\\ d \\\\ d {% endantex %}
      OUTPUT
    end

    it 'abides to priorities' do
      text = subject.lift(<<~INPUT)
        BAR inside bar the foo FOO code here OOF cannot be seen RAB
      INPUT

      expect(subject.tap(&:bake).drop(text)).to eq <<~OUTPUT
        {% antex --- {}
         %} inside bar the foo FOO code here OOF cannot be seen {% endantex %}
      OUTPUT
    end

    it 'interpolates alias options' do
      text = subject.lift(<<~INPUT)
        BAZ# code here ZAB
      INPUT

      expect(subject.tap(&:bake).drop(text)).to eq <<~OUTPUT
        {% antex ---
        a: 1
        b: 2
         %} code here {% endantex %}
      OUTPUT
    end

    it 'interpolates markup options' do
      text = subject.lift(<<~INPUT)
        BAZ { b: 0, c: -1 } # code here ZAB
      INPUT

      expect(subject.tap(&:bake).drop(text)).to eq <<~OUTPUT
        {% antex ---
        a: 1
        b: 0
        c: -1
         %} code here {% endantex %}
      OUTPUT
    end
  end
end
