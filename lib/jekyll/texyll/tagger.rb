module Jekyll
  module TeXyll
    class Tagger
      attr_reader :content

      def initialize(content: '', delimiters: [])
        @content = content
        @delimiters = delimiters
        @stash = {}
      end

      def parse
        stash_tags
        tagify_and_stash_delimiters
        unstash_tags
      end

      def stash_tag(tag)
        hash = Digest::MD5.hexdigest(tag)
        @stash.store(hash, tag)
        hash
      end

      def stash_tags
        @content.gsub!(/{%\s*tex.*?endtex\s*%}/m) do |match|
          stash_tag(match)
        end
      end

      def tagify_and_stash_delimiters
        @delimiters.each do |delimiter|
          @content.gsub!(/
            #{Regexp.quote(delimiter['open'])}  # escaped opening delimiter
            (.*?)                               # minimal amount of stuff
            #{Regexp.quote(delimiter['close'])} # escaped closing delimiter
          /mx) do
            code = Regexp.last_match[1]
            markup = YAML.dump(delimiter['options'])
            tag = "{% tex #{markup} %}#{code}{% endtex %}"
            stash_tag(tag)
          end
        end
      end

      def unstash_tags
        @stash.each do |hash, tag|
          @content.gsub!(hash, tag)
        end
      end
    end
  end
end
