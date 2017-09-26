# frozen_string_literal: true

module Jekyll::Antex
  class Generator < Jekyll::Generator
    def generate(site)
      # TODO: abort operation if delimiters are off

      site.pages.each do |page|
        options = build_options(site: site, resource: page)
        dealiaser = Jekyll::Antex::Dealiaser.new
        dealiaser.add_aliases build_aliases(options['aliases'])

        page.content = dealiaser.parse page.content
      end

      # site.documents.each do |document|
      # end

      # site.posts.docs.each do |post|
      # end
    end

    private

    def build_options(site:, resource:)
      Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                   site.config['antex'] || {},
                                   resource.data['antex'] || {}
    end

    def build_aliases(options_hash)
      options_hash.values.map do |args|
        Alias.new Jekyll::Utils.symbolize_hash_keys(args)
      end
    end
  end
end
