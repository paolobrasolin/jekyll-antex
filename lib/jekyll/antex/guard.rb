# frozen_string_literal: true

require 'jekyll/antex/utils'

module Jekyll
  module Antex
    class Guard
      attr_reader :priority, :regexp

      def initialize(priority:, regexp:,
                     multiline: false, extended: true)
        @priority = priority.to_i
        @regexp = Utils.build_regexp source: regexp,
                                     extended: extended,
                                     multiline: multiline
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
