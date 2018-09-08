# frozen_string_literal: true

require 'jekyll/antex/error'

module Jekyll
  module Antex
    class InvalidRegexp < Error; end

    Alias = Struct.new(:priority, :regexp, :options, keyword_init: true) do

      def initialize(*args)
        super
        validate_regexp!
      end

      private

      def validate_regexp!
        return if regexp.names.include? 'code'
        raise InvalidRegexp, <<~MESSAGE
          The regexp #{regexp.inspect} is missing the required named matching group "code".
        MESSAGE
      end
    end
  end
end
