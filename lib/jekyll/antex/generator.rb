# frozen_string_literal: true

require 'jekyll'
require 'jekyll/utils'

require 'jekyll/antex/alias'
require 'jekyll/antex/dealiaser'

require 'jekyll/antex/guard'
require 'jekyll/antex/guardian'

module Jekyll
  module Antex
    class Generator < Jekyll::Generator
      def generate(site)
        site.pages.each do |page|
          dealias_resource_content! site: site, resource: page
        end

        # NOTE: jekyll deprecated direct access to site.posts.each
        site.posts.docs.each do |post|
          dealias_resource_content! site: site, resource: post
        end
      end

      private

      def dealias_resource_content!(site:, resource:)
        options = build_options site: site, resource: resource
        guardian = build_guardian options['guards']
        dealiaser = build_dealiaser options['aliases']
        resource.content = guardian.apply resource.content
        resource.content = dealiaser.parse resource.content
        resource.content = guardian.remove resource.content
      end

      def build_options(site:, resource:)
        Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                     site.config['antex'] || {},
                                     resource.data['antex'] || {}
      end

      def build_guardian(guards_options_hash)
        guardian = Jekyll::Antex::Guardian.new
        guardian.add_guards build_guards(guards_options_hash)
        guardian
      end

      def build_dealiaser(aliases_options_hash)
        dealiaser = Jekyll::Antex::Dealiaser.new
        dealiaser.add_aliases build_aliases(aliases_options_hash)
        dealiaser
      end

      def build_guards(options_hash)
        options_hash.values.map do |args|
          Guard.new Jekyll::Utils.symbolize_hash_keys(args)
        end
      end

      def build_aliases(options_hash)
        options_hash.values.map do |args|
          Alias.new Jekyll::Utils.symbolize_hash_keys(args)
        end
      end
    end
  end
end
