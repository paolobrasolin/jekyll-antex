module Jekyll
  module TeX
    class TeXGenerator < Jekyll::Generator
      def generate(site)
        @delimiters = site.config['texyll']['delimiters']
        # return if site.config.has_key?("katexize") and !site.config["katexize"]
        # site.documents.each { |p| parse(p) }

        # puts site.pages

        site.pages.each do |page|
          page.content = replace(page.content)
        end

        # site.posts.docs.each do |post|
          # post.content = replace(post.content)
        # end
      end

      def replace(content)
        stash = {}
        content.gsub!(/{%\s*tex.*?endtex\s*%}/m) do |match|
          hash = Digest::MD5.hexdigest(match)
          stash.store(hash, match)
          hash
        end
        @delimiters.each do |delimiter|
          content.gsub!(/
            #{Regexp.quote(delimiter['open'])}
            .*?
            #{Regexp.quote(delimiter['close'])}
          /mx) do |match|
            # TODO: ensure options are correctly enclosed YAML-wise
            "{% tex #{delimiter['options']} %}#{match}{% endtex %}"
          end
        end
        stash.each do |hash, match|
          content.gsub!(hash, match)
        end
        content
      end
    end
  end
end
