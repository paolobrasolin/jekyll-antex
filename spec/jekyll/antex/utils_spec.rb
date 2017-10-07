# frozen_string_literal: true

require 'jekyll/antex/utils'

describe Jekyll::Antex::Utils do
  let(:option_sets) do
    {
      simplest: {
        source: 'foo',
        extended: false,
        multiline: false
      },
      complex: {
        source: 'foo',
        extended: true,
        multiline: true
      }
    }
  end

  describe '.build_regexp' do
    it 'handles simplest regexp' do
      expect(described_class.build_regexp(option_sets[:simplest]))
        .to eq(/foo/)
    end

    it 'handles most complex regexp' do
      expect(described_class.build_regexp(option_sets[:complex]))
        .to eq(/foo/xm)
    end
  end
end
