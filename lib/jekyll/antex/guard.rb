# frozen_string_literal: true

module Jekyll
  module Antex
    class Guard
      attr_reader :priority, :regexp, :multiline, :options

      def initialize(priority:, options: {},
                     regexp:, multiline: false, extended: true)
        @priority = priority.to_i
        @regexp = build_regexp source: regexp,
                               extended: extended,
                               multiline: multiline
        @options = options.to_h
      end

      private

      def build_regexp(source:, extended:, multiline:)
        options = 0
        options |= Regexp::EXTENDED if extended
        options |= Regexp::MULTILINE if multiline
        Regexp.new source, options
      end
    end
  end
end
