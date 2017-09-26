# frozen_string_literal: true

module Jekyll
  module TeXyll
    module Utils
      def self.deep_merge_list_of_hashes(*hashes)
        hashes.reduce({}) { |result, hash| Jekyll::Utils.deep_merge_hashes result, hash }
      end
    end
  end
end
