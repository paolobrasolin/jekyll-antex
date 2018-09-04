# frozen_string_literal: true

require 'securerandom'

require 'jekyll/antex/options'

module Jekyll
  module Antex
    class Dealiaser
      attr_reader :aliases

      def initialize(tag: 'antex')
        @aliases = []
        @stash = {}
        @tag = tag
      end

      def add_aliases(aliases)
        @aliases.concat(aliases).sort_by!(&:priority).reverse!
      end

      def parse(content)
        @content = content.dup
        @stash = {}
        stash_aliases
        render_stashed_aliases_as_tags
        unstash_tags
        @content
      end

      private

      def stash_aliases
        @aliases.each do |aliaz|
          @content.gsub!(aliaz.regexp) do
            uuid = SecureRandom.uuid
            @stash.store uuid, match: Regexp.last_match, options: aliaz.options
            uuid
          end
        end
      end

      def render_stashed_aliases_as_tags
        @stash.each do |key, value|
          @stash[key] = render_matched_alias_as_tag(**value)
        end
      end

      def unstash_tags
        @stash.each do |uuid, rendered_tag|
          @content.gsub!(uuid) { rendered_tag }
        end
      end

      def render_matched_alias_as_tag(match:, options:)
        markup = YAML.safe_load match[:markup] if match.names.include?('markup')
        markup = YAML.dump Options.build(options || {}, markup || {})
        code = match['code']
        "{% #{@tag} #{markup} %}#{code}{% end#{@tag} %}"
      end
    end
  end
end
