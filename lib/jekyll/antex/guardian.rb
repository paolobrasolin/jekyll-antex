# frozen_string_literal: true

require 'securerandom'

require 'jekyll/antex/stasher'

module Jekyll
  module Antex
    class Guardian < Stasher
      def bake
        super do |match, _|
          match.to_s
        end
      end
    end
  end
end
