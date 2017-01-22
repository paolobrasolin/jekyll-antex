module Jekyll
  module TeXyll
    class Sobriquet
      attr_reader :priority, :regexp, :options

      def initialize(priority:, regexp:, options: {})
        @priority = priority
        @regexp = regexp
        @options = options
      end

      def <=>(other)
        -self.priority <=> -other.priority
      end
    end
  end
end
