module Jekyll
  module TeX
    class Generator < Jekyll::Generator
      def generate(site)
        # site.documents.each { |p| parse(p) }

        site.pages.each do |page|
          options = Jekyll::TeX::Options.new(
            site.config['texyll'] || {},
            page.data['texyll'] || {}
          ).merged
          document = Jekyll::TeX::Tagger.new(
            content: page.content,
            delimiters: options['delimiters']
          )
          document.parse
          page.content = document.content
        end

        # site.posts.docs.each do |post|
          # post.content = replace(post.content)
        # end
      end
    end
  end
end
