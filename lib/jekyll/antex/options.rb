# frozen_string_literal: true

module Jekyll
  module Antex
    module Options
      DEFAULTS =
        YAML.load_file(File.join(File.dirname(__FILE__), 'defaults.yml')).freeze

      def self.build(*hashes)
        hashes.reduce({}) do |result, hash|
          Jekyll::Utils.deep_merge_hashes result, hash
        end
      end
    end
  end
end
