# frozen_string_literal: true

require 'securerandom'

require 'jekyll/antex/stasher'
require 'jekyll/antex/options'

module Jekyll
  module Antex
    class Dealiaser < Stasher
      def bake
        super do |match, matcher|
          markup = YAML.safe_load match[:markup] if match.names.include?('markup')
          markup = YAML.dump Options.build(matcher.options || {}, markup || {})
          code = match['code']
          "{% antex #{markup} %}#{code}{% endantex %}"
        end
      end
    end
  end
end
