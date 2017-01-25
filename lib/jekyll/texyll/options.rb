# frozen_string_literal: true

module Jekyll
  module TeXyll
    class Options
      DEFAULT = YAML.load_file(
        File.join(File.dirname(__FILE__), 'defaults.yaml')
      ).freeze

      def initialize(*levels)
        @options = DEFAULT.dup
        merge(*levels)
      end

      def merge(*levels)
        levels.each do |level|
          @options = Jekyll::Utils.deep_merge_hashes(@options, level)
        end
      end

      def merged
        @options
      end
    end
  end
end
