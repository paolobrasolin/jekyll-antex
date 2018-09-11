# frozen_string_literal: true

require 'jekyll'
require 'jekyll/utils'

require 'jekyll/antex/alias'
require 'jekyll/antex/guard'
require 'jekyll/antex/stasher'
require 'jekyll/antex/options'

# NOTE: I'm pretty conflicted about this.
SafeYAML::OPTIONS[:whitelisted_tags].push('!ruby/regexp')

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
        guardian = Jekyll::Antex::Stasher.new(build_guards(options['guards']))
        dealiaser = Jekyll::Antex::Stasher.new(build_aliases(options['aliases']))
        resource.content = guardian.lift(resource.content)
        resource.content = dealiaser.lift(resource.content)
        dealiaser.bake(&method(:render_tag))
        resource.content = dealiaser.drop(resource.content)
        resource.content = guardian.drop(resource.content)
      end

      def build_options(site:, resource:)
        Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                     site.config['antex'] || {},
                                     resource.data['antex'] || {}
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

      def render_tag(match, matcher)
        markup = YAML.safe_load match[:markup] if match.names.include?('markup')
        markup = YAML.dump Options.build(matcher.options || {}, markup || {})
        code = match['code']
        "{% antex #{markup} %}#{code}{% endantex %}"
      end
    end
  end
end
