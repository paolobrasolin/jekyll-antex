# frozen_string_literal: true

module Jekyll
  module Antex
    class Block < Liquid::Block
      def initialize(tag, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        options = build_options context: context, markup: @markup
        job = ::Antex::Job.new snippet: super, options: options
        job.run
        add_static_file context.registers[:site], job
        job.html_tag
      end

      private

      def add_static_file(site, job)
        site.static_files << Jekyll::StaticFile.new(
          site, nil, job.options['work_dir'], "#{job.hash}.svg"
        )
      end

      def build_options(context:, markup:)
        Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                     context.registers[:site].config['antex'] || {},
                                     context.registers[:page]['antex'] || {},
                                     YAML.safe_load(markup) || {}
      end
    end
  end
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)
