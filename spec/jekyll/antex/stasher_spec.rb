# frozen_string_literal: true

require 'jekyll/antex/guard'
require 'jekyll/antex/stasher'

describe Jekyll::Antex::Stasher do
  describe 'initialized object' do
    subject { described_class.new([]) }

    it { is_expected.to respond_to(:matchers) }
  end

  describe '#add_guards' do
    subject { described_class.new(guards) }

    let(:guards) do
      [
        { regexp: /foo/, priority: 10 },
        { regexp: /foo/, priority: 1000 },
        { regexp: /foo/, priority: 100 },
        { regexp: /foo/, priority: 10_000 }
      ].map(&Jekyll::Antex::Guard.method(:new))
    end

    it 'adds all passed guards' do
      expect(subject.matchers).to match_array guards
    end

    it 'sorts passed guards by priority' do
      expect(subject.matchers.map(&:priority)).to eq [10_000, 1000, 100, 10]
    end
  end

  describe '#parse' do
    subject { described_class.new(guards) }

    let(:guards) do
      [
        { regexp: /FOO.*?OOF/, priority: 10 },
        { regexp: /BAR.*?RAB/, priority: 100 },
        { regexp: /BAZ.*?ZAB/, priority: 0 }
      ].map(&Jekyll::Antex::Guard.method(:new))
    end

    it 'applies the simplest guard' do
      expect(subject.lift(<<~INPUT)).to match Regexp.new(<<~'OUTPUT'.chomp)
        before FOO code here OOF after
      INPUT
        before [\w\-]{36} after
      OUTPUT
    end

    it 'removes the applied guards' do
      text = subject.lift(<<~'INPUT')
        before FOO code here OOF after
      INPUT

      expect(subject.drop(text)).to eq <<~'OUTPUT'
        before FOO code here OOF after
      OUTPUT
    end

    # NOTE: keeps paolobrasolin/jekyll-antex#11 in check
    it 'keeps backslashes intact' do
      text = subject.lift(<<~'INPUT')
        before FOO a \ b \\ c \\\ d \\\\ d OOF after
      INPUT

      expect(subject.drop(text)).to eq <<~'OUTPUT'
        before FOO a \ b \\ c \\\ d \\\\ d OOF after
      OUTPUT
    end

    it 'abides to priorities' do
      expect(subject.lift(<<~INPUT)).to match Regexp.new(<<~'OUTPUT'.chomp)
        BAR xxx FOO yyy RAB zzz OOF
      INPUT
        ^[\w\-]{36} zzz OOF$
      OUTPUT
    end
  end
end
