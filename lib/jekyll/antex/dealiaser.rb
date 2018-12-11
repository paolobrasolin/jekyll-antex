# frozen_string_literal: true

require 'jekyll/antex/alias'
require 'jekyll/antex/guard'
require 'jekyll/antex/stasher'
require 'jekyll/antex/options'

module Jekyll
  module Antex
    module Dealiaser
      def self.run(resource)
        options = build_options(resource)
        guarder = build_guarder(options)
        aliaser = build_aliaser(options)
        content = aliaser.lift(guarder.lift(resource.content))
        aliaser.bake(&method(:dealias_tag))
        guarder.drop(aliaser.drop(content))
      end

      def self.build_options(resource)
        Jekyll::Antex::Options.build(
          Jekyll::Antex::Options::DEFAULTS,
          resource.site.config['antex'] || {},
          resource.data['antex'] || {}
        )
      end

      def self.build_guarder(options)
        Jekyll::Antex::Stasher.new(
          options['guards'].values.reject { |value| false == value }.map(&Guard.method(:new))
        )
      end

      def self.build_aliaser(options)
        Jekyll::Antex::Stasher.new(
          options['aliases'].values.reject { |value| false == value }.map(&Alias.method(:new))
        )
      end

      def self.dealias_tag(match, matcher)
        markup = YAML.safe_load match[:markup] if match.names.include?('markup')
        markup = YAML.dump Options.build(matcher.options || {}, markup || {})
        code = match['code']
        "{% antex #{markup} %}#{code}{% endantex %}"
      end
    end
  end
end
