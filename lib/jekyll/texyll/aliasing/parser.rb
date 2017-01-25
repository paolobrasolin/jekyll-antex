# frozen_string_literal: true

require 'jekyll/utils'

module Jekyll
  module TeXyll
    module Aliasing
      class Parser
        def initialize(tag: 'texyll')
          @tag_aliases = []
          @stash = {}
          @tag = tag
        end

        def parse(content)
          @content = content
          stash_all
          unstash_all
          @content
        end

        def load_named_aliases_hash(hash)
          Hash(hash).each_value do |value|
            @tag_aliases << Alias.new(Jekyll::Utils.symbolize_hash_keys(value))
          end
          @tag_aliases.sort!
        end

        private

        def stash_all
          @tag_aliases.each do |tag_alias|
            @content.gsub!(tag_alias.regexp) do
              liquid_tag = render_matched_alias_as_tag(
                match: Regexp.last_match,
                options: tag_alias.options
              )
              stash(liquid_tag)
            end
          end
        end

        def render_matched_alias_as_tag(match:, options:)
          code = match[:code]
          markup = YAML.load(match(:markup)) if match.names.include?(:markup)
          puts YAML.dump(markup)
          markup = YAML.dump(
            Jekyll::Utils.deep_merge_hashes(options || {}, markup || {})
          )
          "{% #{@tag} #{markup} %}#{code}{% end#{@tag} %}"
        end

        def stash(tag)
          hash = Digest::MD5.hexdigest(tag)
          @stash.store(hash, tag)
          hash
        end

        def unstash_all
          @stash.each do |hash, tag|
            @content.gsub!(hash, tag)
          end
        end
      end
    end
  end
end
