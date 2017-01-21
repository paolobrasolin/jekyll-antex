module Jekyll
  module TeXyll
    class Options
      attr_reader :merged

      DEFAULT = YAML.load_file(
        File.join(File.dirname(__FILE__), 'defaults.yaml')
      ).freeze

      def initialize(*levels)
        @merged = DEFAULT.dup
        levels.each do |level|
          @merged.merge!(level)
        end
      end
    end
  end
end
