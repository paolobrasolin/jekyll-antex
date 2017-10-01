# frozen_string_literal: true

require 'jekyll/antex/alias'

describe Jekyll::Antex::Alias do
  let(:aliases) do
    {
      missing_code: {
        priority: 10,
        regexp: /foo/
      },
      minimal_valid: {
        priority: 10,
        regexp: /(?<code>)/
      }
    }
  end

  describe '.new' do
    it 'raises error if "code" matching group is missing in regexp' do
      expect { described_class.new(aliases[:missing_code]) }
        .to raise_exception described_class::InvalidRegexp
    end
  end

  describe 'initialized object' do
    subject { described_class.new(aliases[:minimal_valid]) }
    it { is_expected.to respond_to(:priority, :regexp, :options) }
  end
end
