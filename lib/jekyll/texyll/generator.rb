module Jekyll
  module TeXyll
    class Generator < Jekyll::Generator
      def generate(site)
        site.pages.each do |page|
          options = Jekyll::TeXyll::Options.new(
            site.config['texyll'] || {},
            page.data['texyll'] || {}
          ).merged
          # TODO: abort operation if delimiters are off
          tagger = Jekyll::TeXyll::Tagger.new(
            content: page.content,
            delimiters: options['delimiters']
          )
          page.content = tagger.output
        end

        # TODO: handle non-pages

        # site.documents.each do |document|
        # end

        # site.posts.docs.each do |post|
        # end
      end
    end
  end
end
