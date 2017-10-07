# frozen_string_literal: true

module Jekyll
  module Antex
    module Utils
      def self.build_regexp(source:, extended:, multiline:)
        options = 0
        options |= Regexp::EXTENDED if extended
        options |= Regexp::MULTILINE if multiline
        Regexp.new source, options
      end
    end
  end
end
