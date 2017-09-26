# frozen_string_literal: true

module Jekyll::Antex
  class Generator < Jekyll::Generator
    def generate(site)
      site.pages.each do |page|
        options = Jekyll::Antex::Utils.deep_merge_list_of_hashes(
          Jekyll::Antex::Options::DEFAULTS,
          site.config['antex'] || {},
          page.data['antex'] || {}
        )
        # TODO: abort operation if delimiters are off
        dealiaser = Jekyll::Antex::Dealiaser.new
        aliases = options['aliases']
                    .values
                    .map { |args| Alias.new Jekyll::Utils.symbolize_hash_keys(args) }
        dealiaser.add_aliases aliases

        puts dealiaser.parse(page.content)

        page.content = dealiaser.parse(page.content)
      end

      # TODO: handle non-pages

      # site.documents.each do |document|
      # end

      # site.posts.docs.each do |post|
      #   options = Jekyll::Antex::Utils.deep_merge_list_of_hashes(
      #     Jekyll::Antex::Options::DEFAULTS,
      #     site.config['antex'] || {},
      #     post.data['antex'] || {}
      #   )
      #   # TODO: abort operation if delimiters are off
      #   dealiaser = Jekyll::Antex::Aliasing::Dealiaser.new
      #   dealiaser.load_aliases_configuration(options['aliases'])
      #   post.content = dealiaser.parse(post.content)
      # end
    end
  end
end
