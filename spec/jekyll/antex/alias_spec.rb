# frozen_string_literal: true

require 'jekyll/antex/alias'

describe Jekyll::Antex::Alias do
  let(:aliases) do
    {
      missing_code: {
        priority: 10,
        regexp: 'foo'
      },
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
    it 'raises error if "code" matching group is missing in regexp' do
      expect { described_class.new(aliases[:missing_code]) }
        .to raise_exception described_class::InvalidRegexp
    end

    it 'defaults to a single-line extended regexp' do
      expect(described_class.new(aliases[:minimal_valid]).regexp.options)
        .to eq(Regexp::EXTENDED)
    end

    it 'recognizes :extend option' do
      expect(described_class.new(aliases[:not_extended]).regexp.options)
        .to eq(0)
    end

    it 'recognizes :multiline option' do
      expect(described_class.new(aliases[:multiline]).regexp.options)
        .to eq(Regexp::EXTENDED | Regexp::MULTILINE)
    end
  end

  describe 'initialized object' do
    subject { described_class.new(aliases[:minimal_valid]) }
    it { is_expected.to respond_to(:priority, :regexp) }
  end
end
