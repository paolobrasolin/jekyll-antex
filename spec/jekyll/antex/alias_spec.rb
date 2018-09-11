# frozen_string_literal: true

require 'jekyll/antex/alias'

describe Jekyll::Antex::Alias do
  let(:aliases) do
    {
      invalid: {
        priority: 10,
        regexp: /foo/
      },
      valid: {
        priority: 10,
        regexp: /(?<code>)/x
      }
    }
  end

  describe '.new' do
    it 'raises error regexp lacks a matching group named "code"' do
      expect { described_class.new(aliases[:invalid]) }
        .to raise_exception Jekyll::Antex::InvalidRegexp
    end
  end

  it 'can be used as a matcher for Stasher' do
    expect(described_class.new(aliases[:valid]))
      .to respond_to(:priority, :regexp)
  end
end
