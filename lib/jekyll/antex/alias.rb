# frozen_string_literal: true

require 'jekyll/antex/error'
require 'jekyll/antex/utils'

module Jekyll
  module Antex
    class Alias
      class InvalidRegexp < Error; end

      attr_reader :priority, :regexp, :options

      def initialize(priority:, regexp:, options: {},
                     multiline: false, extended: true)
        @priority = priority.to_i
        @regexp = Utils.build_regexp source: regexp,
                                     extended: extended,
                                     multiline: multiline
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
