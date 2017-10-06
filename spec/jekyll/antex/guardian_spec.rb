# frozen_string_literal: true

require 'jekyll/antex/guard'
require 'jekyll/antex/guardian'

describe Jekyll::Antex::Guardian do
  describe 'initialized object' do
    subject { described_class.new }

    it { is_expected.to respond_to(:guards) }
  end

  describe '#add_guards' do
    subject { described_class.new }

    let(:guards) do
      [
        { regexp: 'foo', priority: 10 },
        { regexp: 'foo', priority: 1000 },
        { regexp: 'foo', priority: 100 },
        { regexp: 'foo', priority: 10_000 }
      ].map(&Jekyll::Antex::Guard.method(:new))
    end

    before { subject.add_guards guards }

    it 'adds all passed guards' do
      expect(subject.guards).to match_array guards
    end

    it 'sorts passed guards by priority' do
      expect(subject.guards.map(&:priority)).to eq [10_000, 1000, 100, 10]
    end
  end

  describe '#parse' do
    subject { described_class.new }

    let(:guards) do
      [
        { regexp: 'FOO.*?OOF', priority: 10 },
        { regexp: 'BAR.*?RAB', priority: 100 },
        { regexp: 'BAZ.*?ZAB', priority: 0, extended: false }
      ].map(&Jekyll::Antex::Guard.method(:new))
    end

    before { subject.add_guards guards }

    it 'applies the simplest guard' do
      expect(subject.apply(<<~INPUT)).to match Regexp.new(<<~'OUTPUT'.chomp)
        before FOO code here OOF after
      INPUT
        before [\w\-]{36} after
      OUTPUT
    end

    it 'removes the applied guards' do
      expect(subject.remove(subject.apply(<<~INPUT))).to eq <<~OUTPUT
        before FOO code here OOF after
      INPUT
        before FOO code here OOF after
      OUTPUT
    end

    it 'abides to priorities' do
      expect(subject.apply(<<~INPUT)).to match Regexp.new(<<~'OUTPUT'.chomp)
        BAR xxx FOO yyy RAB zzz OOF
      INPUT
        ^[\w\-]{36} zzz OOF$
      OUTPUT
    end
  end
end
