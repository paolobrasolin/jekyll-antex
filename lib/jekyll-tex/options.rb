module Jekyll
  module TeX
    class Options
      attr_reader :merged

      DEFAULT = YAML.load_file(
        File.join(File.dirname(__FILE__), 'defaults.yaml')
      )

      def initialize(*levels)
        @merged = DEFAULT
        levels.each do |level|
          @merged.merge!(level)
        end
      end
    end
  end
end
