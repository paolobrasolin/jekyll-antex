# frozen_string_literal: true

module Jekyll
  module TeXyll
    class Alias
      class InvalidRegexp < Error; end

      attr_reader :priority, :regexp, :options

      def initialize(priority:, regexp:, options: {})
        @priority = priority.to_i
        @regexp = Regexp.new regexp
        validate_regexp!
        @options = options.to_h
      end

      private

      def validate_regexp!
        return if @regexp.names.include? 'code'
        raise InvalidRegexp, <<~MESSAGE
          The regexp #{@regexp.inspect} is missing the required named matching group "code".
        MESSAGE
      end
    end
  end
end
