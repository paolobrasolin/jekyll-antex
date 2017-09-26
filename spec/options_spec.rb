# frozen_string_literal: true

require 'jekyll/utils'

describe Jekyll::Antex::Options do
  describe '.build' do
    it 'deep merges hashes in order' do
      expect(
        described_class.build(
          { a: 1, b: { x: 1, y: 2 }, c: [1, 2, 3] },
          { b: { y: 0 } },
          { c: [0] }
        )
      ).to eq(a: 1, b: { x: 1, y: 0 }, c: [0])
    end
  end
end
