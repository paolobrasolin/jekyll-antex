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
        replace_delimiters
        unstash_tags
      end

      def replace_delimiters
        @delimiters.each do |delimiter|
          @content.gsub!(/
            #{Regexp.quote(delimiter['open'])}  # escaped opening delimiter
            .*?                                 # minimal amount of stuff
            #{Regexp.quote(delimiter['close'])} # escaped closing delimiter
          /mx) do |match|
            # TODO: ensure options are correctly enclosed YAML-wise
            "{% tex #{delimiter['options']} %}#{match}{% endtex %}"
          end
        end
      end

      def stash_tags
        @content.gsub!(/{%\s*tex.*?endtex\s*%}/m) do |match|
          hash = Digest::MD5.hexdigest(match)
          @stash.store(hash, match)
          hash
        end
      end

      def unstash_tags
        @stash.each do |hash, match|
          @content.gsub!(hash, match)
        end
      end
    end
  end
end
