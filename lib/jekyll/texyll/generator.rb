# frozen_string_literal: true

module Jekyll
  module TeXyll
    class Generator < Jekyll::Generator
      def generate(site)
        site.pages.each do |page|
          options = Jekyll::TeXyll::Utils.deep_merge_list_of_hashes(
            Jekyll::TeXyll::Options::DEFAULTS,
            site.config['texyll'] || {},
            page.data['texyll'] || {}
          )
          # TODO: abort operation if delimiters are off
          dealiaser = Jekyll::TeXyll::Aliasing::Dealiaser.new
          aliases = options['aliases'].values
                                      .map { |args| Alias.new Jekyll::Utils.symbolize_hash_keys(args) }
          dealiaser.add_aliases aliases
          page.content = dealiaser.parse(page.content)
        end

        # TODO: handle non-pages

        # site.documents.each do |document|
        # end

        site.posts.docs.each do |post|
          options = Jekyll::TeXyll::Utils.deep_merge_list_of_hashes(
            Jekyll::TeXyll::Options::DEFAULTS,
            site.config['texyll'] || {},
            post.data['texyll'] || {}
          )
          # TODO: abort operation if delimiters are off
          dealiaser = Jekyll::TeXyll::Aliasing::Dealiaser.new
          dealiaser.load_aliases_configuration(options['aliases'])
          post.content = dealiaser.parse(post.content)
        end
      end
    end
  end
end
