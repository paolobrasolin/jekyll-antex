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
    end
  end
end
