# frozen_string_literal: true

require 'jekyll/antex/guard'

describe Jekyll::Antex::Guard do
  let(:guards) do
    {
      minimal_valid: {
        priority: 10,
        regexp: '(?<code>)'
      },
      not_extended: {
        priority: 10,
        regexp: '(?<code>)',
        extended: false
      },
      multiline: {
        priority: 10,
        regexp: '(?<code>)',
        multiline: true
      }
    }
  end

  describe '.new' do
    it 'defaults to a single-line extended regexp' do
      expect(described_class.new(guards[:minimal_valid]).regexp.options)
        .to eq(Regexp::EXTENDED)
    end

    it 'recognizes :extend option' do
      expect(described_class.new(guards[:not_extended]).regexp.options)
        .to eq(0)
    end

    it 'recognizes :multiline option' do
      expect(described_class.new(guards[:multiline]).regexp.options)
        .to eq(Regexp::EXTENDED | Regexp::MULTILINE)
    end
  end

  describe 'initialized object' do
    subject { described_class.new(guards[:minimal_valid]) }
    it { is_expected.to respond_to(:priority, :regexp, :options) }
  end
end
