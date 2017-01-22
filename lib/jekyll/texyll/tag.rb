module Jekyll
  module TeXyll
    class Tag < Liquid::Block
      def initialize(tag, markup, tokens)
        super
        @markup = markup
      end

      def render(context)
        options = load_options(registers: context.registers)
        compiler = Jekyll::TeXyll::Compiler.new(snippet: super, options: options)
        compiler.compile
        compiler.add_to_static_files(context.registers[:site])
        compiler.render_html_tag
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

Liquid::Template.register_tag('texyll', Jekyll::TeXyll::Tag)
