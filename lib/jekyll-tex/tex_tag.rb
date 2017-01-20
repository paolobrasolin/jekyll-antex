require 'open3'

module Jekyll
  module TeX
    class TeXBlock < Liquid::Block
      def initialize(tag, markup, tokens)
        super
        @options = YAML.load(markup) || {}
      end

      def render(context)
        configure(context.registers)
        @snippet = super
        prepare_code
        compile
        load_metrics
        scale_bounds
        compute_margins
        stash_image(context.registers[:site])
        render_tag
      end

      private

      def configure(registers)
        this = @options # got these from initialize
        page = registers[:page]['texyll'] || {}
        site = registers[:site].config['texyll'] || {}
        dflt = {
          'path' => 'tex',
          'work_dir' => '.tex-cache',
          'preamble' => '',
          'template' => <<'TEMPLATE'
\documentclass{article}
\pagestyle{empty}
{{preamble}}
\newsavebox\snippet
\begin{lrbox}{\snippet}{{snippet}}\end{lrbox}
\newwrite\file
\immediate\openout\file=\jobname.yml
\immediate\write\file{em: \the\dimexpr1em}
\immediate\write\file{ex: \the\dimexpr1ex}
\immediate\write\file{ht: \the\ht\snippet}
\immediate\write\file{dp: \the\dp\snippet}
\immediate\write\file{wd: \the\wd\snippet}
\closeout\file
\begin{document}\usebox{\snippet}\end{document}
TEMPLATE
        }

        @options = dflt.merge(site).merge(page).merge(this)

        FileUtils.mkdir_p @options['work_dir'].to_s
        FileUtils.mkdir_p "#{@options['work_dir']}/#{@options['path']}".to_s
      end

      def prepare_code
        @preamble = @options['preamble']
        template = Liquid::Template.parse(@options['template'])
        @code = template.render('preamble' => @preamble, 'snippet' => @snippet)
        @hash = Digest::MD5.hexdigest(@code)

        File.open(file(:tex), 'w') do |file|
          file.write(@code)
        end unless File.exist?(file(:tex))
      end

      def file(key)
        {
          tex: "#{@options['work_dir']}/#{@hash}.tex",
          dvi: "#{@options['work_dir']}/#{@hash}.dvi",
          yml: "#{@options['work_dir']}/#{@hash}.yml",
          tfm: "#{@options['work_dir']}/#{@hash}.tfm.svg",
          fit: "#{@options['work_dir']}/#{@hash}.fit.svg",
          svg: "#{@options['work_dir']}/#{@options['path']}/#{@hash}.svg"
        }[key]
      end

      def call_to_produce(command, filelist)
        return if filelist.map(&->(file) { File.exist?(file) }).reduce(:&)
        _stdout, stderr, status = Open3.capture3(*command)
        raise stderr unless status.success?
      end

      def compile
        latexmk = ['latexmk', "-output-directory=#{@options['work_dir']}",
                   file(:tex)]
        dvisvgm_tfm = ['dvisvgm', '--no-fonts',
                       file(:dvi), "--output=#{file(:tfm)}"]
        dvisvgm_fit = ['dvisvgm', '--no-fonts', '--exact',
                       file(:dvi), "--output=#{file(:fit)}"]

        call_to_produce(latexmk, [file(:dvi), file(:yml)])
        call_to_produce(dvisvgm_tfm, [file(:tfm)])
        call_to_produce(dvisvgm_fit, [file(:fit)])
      end

      def load_metrics
        @tex = TeXBox.new(file(:yml))
        @tfm = SVGBox.new(file(:tfm))
        @fit = SVGBox.new(file(:fit))
      end

      def scale_bounds
        r = (@tex.ht + @tex.dp) / @tfm.dy
        @tfm.scale(r)
        @fit.scale(r)
      end

      def compute_margins
        @ml = - @tfm.ox + @fit.ox
        @mt = - @tfm.oy + @fit.oy
        @mr =   @tfm.dx - @fit.dx - @ml
        @mb =   @tfm.dy - @fit.dy - @mt - @tex.dp
      end

      def stash_image(site)
        FileUtils.cp(file(:fit), file(:svg))
        # TODO: minify/compress svg?
        site.static_files << Jekyll::StaticFile.new(
          site, @options['work_dir'], @options['path'], "#{@hash}.svg"
        )
      end

      def render_tag
        "<img style='margin:#{@mt}ex #{@mr}ex #{@mb}ex #{@ml}ex;"\
        "height:#{@fit.dy}ex' src='#{@options['path']}/#{@hash}.svg'>"
      end
    end
  end
end

Liquid::Template.register_tag('tex', Jekyll::TeX::TeXBlock)
