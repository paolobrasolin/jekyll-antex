require 'jekyll/utils'

module Jekyll
  module TeXyll
    class Dealiaser
      def initialize(tag: 'texyll')
        @sobriquets = []
        @stash = {}
        @tag = tag
      end

      def parse(content)
        @content = content
        stash_all
        unstash_all
        @content
      end

      def load_hash(hash)
        (hash || {}).each_value do |value|
          @sobriquets << Sobriquet.new(Jekyll::Utils.symbolize_hash_keys(value))
        end
        @sobriquets.sort!
      end

      private

      def stash_all
        @sobriquets.each do |sobriquet|
          @content.gsub!(sobriquet.regexp) do
            liquid_tag = render_match_as_tag(
              match: Regexp.last_match,
              options: sobriquet.options
            )
            stash(liquid_tag)
          end
        end
      end

      def render_match_as_tag(match:, options:)
        code = match[:code]
        markup = YAML.load(match(:markup)) if match.names.include?(:markup)
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
