# frozen_string_literal: true

module Jekyll
  module TeXyll
    module Aliasing
      class Alias
        attr_reader :priority, :regexp, :options

        def initialize(priority:, regexp:, options: {})
          @priority = Integer(priority)
          @regexp = Regexp.new(regexp)
          @options = Hash(options)
        end

        def <=>(other)
          -priority <=> -other.priority
        end
      end
    end
  end
end
