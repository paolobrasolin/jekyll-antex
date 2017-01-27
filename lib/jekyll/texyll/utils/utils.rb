# frozen_string_literal: true

module Jekyll
  module TeXyll
    module Utils
      def self.deep_merge_list_of_hashes(*hashes)
        result = {}
        hashes.each do |hash|
          result = Jekyll::Utils.deep_merge_hashes(result, hash)
        end
        result
      end
    end
  end
end
