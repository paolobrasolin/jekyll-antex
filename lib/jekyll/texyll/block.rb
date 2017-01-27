# frozen_string_literal: true

module Jekyll
  module TeXyll
    class Block < Liquid::Block
      def initialize(tag, markup, tokens)
        super
        @markup = markup
      end

      def render(context)
        options = load_options(registers: context.registers)
        job = Jekyll::TeXyll::Compiler::Job.new(snippet: super, options: options)
        job.run
        job.add_to_static_files_of(context.registers[:site])
        job.html_tag
      end

      private

      def load_options(markup: @markup, registers:)
        this = YAML.load(markup) || {}
        page = registers[:page]['texyll'] || {}
        site = registers[:site].config['texyll'] || {}
        Jekyll::TeXyll::Options.new(site, page, this).merged
      end
    end
  end
end

Liquid::Template.register_tag('texyll', Jekyll::TeXyll::Block)
