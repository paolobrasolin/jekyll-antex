module Jekyll
  module TeX
    class Block < Liquid::Block
      def initialize(tag, markup, tokens)
        super
        @markup = markup
      end

      def render(context)
        options = load_options(registers: context.registers)
        compiler = Jekyll::TeX::Compiler.new(snippet: super, options: options)
        compiler.compile
        compiler.add_to_static_files(context.registers[:site])
        compiler.render_html_tag
      end

      private

      def load_options(markup: @markup, registers:)
        this = YAML.load(markup) || {}
        page = registers[:page]['texyll'] || {}
        site = registers[:site].config['texyll'] || {}
        # puts registers[:page]
        Jekyll::TeX::Options.new(site, page, this).merged
      end
    end
  end
end

Liquid::Template.register_tag('tex', Jekyll::TeX::Block)
