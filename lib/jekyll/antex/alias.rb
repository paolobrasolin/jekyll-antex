# frozen_string_literal: true

require 'jekyll/antex/error'

module Jekyll
  module Antex
    class Alias
      class InvalidRegexp < Error; end

      attr_reader :priority, :regexp, :multiline, :options

      def initialize(priority:, options: {},
                     regexp:, multiline: false, extended: true)
        @priority = priority.to_i
        @regexp = build_regexp source: regexp,
                               extended: extended,
                               multiline: multiline
        validate_regexp!
        @options = options.to_h
      end

      private

      def build_regexp(source:, extended:, multiline:)
        options = 0
        options |= Regexp::EXTENDED if extended
        options |= Regexp::MULTILINE if multiline
        Regexp.new source, options
      end

      def validate_regexp!
        return if @regexp.names.include? 'code'
        raise InvalidRegexp, <<~MESSAGE
          The regexp #{@regexp.inspect} is missing the required named matching group "code".
        MESSAGE
      end
    end
  end
end
