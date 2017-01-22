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
          dealiaser = Jekyll::TeXyll::Dealiaser.new
          dealiaser.load_hash(options['sobriquets'])
          page.content = dealiaser.parse(page.content)
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
