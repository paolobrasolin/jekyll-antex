# frozen_string_literal: true

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
          dealiaser = Jekyll::TeXyll::Aliasing::Parser.new
          dealiaser.load_named_aliases_hash(options['aliases'])
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
