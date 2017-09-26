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
        Jekyll::TeXyll::Utils.deep_merge_list_of_hashes(
          Jekyll::TeXyll::Options::DEFAULTS,
          registers[:site].config['texyll'] || {},
          registers[:page]['texyll'] || {},
          YAML.safe_load(markup) || {}
        )
      end
    end
  end
end

Liquid::Template.register_tag('texyll', Jekyll::TeXyll::Block)
