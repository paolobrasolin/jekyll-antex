require 'open3'

module Jekyll
  module TeX
    class TeXBlock < Liquid::Block
      @@config = {
        'path' => 'tex',
        'work_dir' => '.tex-cache',
        'preamble' => ''
      }

      # @@config.merge!(Jekyll.configuration({})['tex'] || {})

      @@path = @@config['path']
      @@work_dir = @@config['work_dir']
      @@output_dir = "#{@@work_dir}/#{@@path}"
      FileUtils.mkdir_p @@work_dir.to_s
      FileUtils.mkdir_p @@output_dir.to_s

      def initialize(tag, markup, tokens)
        super
        @cfg_this = YAML.load(markup) || {}
        @cfg_page = {}
        @cfg_site = {}
      end

      def configure(context)
        @cfg_page = context.registers[:page] || {}
        @cfg_site = context.registers[:site].config || {}
        # context.environments.first["page"]
      end

      def tex_sourcecode(preamble, snippet)
        <<'CLASS' + preamble + <<'TEXT' + <<SNIPPET + <<'BODY'
\documentclass{article}
\pagestyle{empty}
CLASS
\newsavebox\snippet
TEXT
\\begin{lrbox}{\\snippet}#{snippet}\\end{lrbox}
SNIPPET
\newwrite\file
\immediate\openout\file=\jobname.yml
\immediate\write\file{em: \the\dimexpr1em}
\immediate\write\file{ex: \the\dimexpr1ex}
\immediate\write\file{ht: \the\ht\snippet}
\immediate\write\file{dp: \the\dp\snippet}
\immediate\write\file{wd: \the\wd\snippet}
\closeout\file
\begin{document}\usebox{\snippet}\end{document}
BODY
      end

      def file(key)
        {
          tex: "#{@@work_dir}/#{@hash}.tex",
          dvi: "#{@@work_dir}/#{@hash}.dvi",
          yml: "#{@@work_dir}/#{@hash}.yml",
          tfm: "#{@@work_dir}/#{@hash}.tfm.svg",
          fit: "#{@@work_dir}/#{@hash}.fit.svg",
          svg: "#{@@output_dir}/#{@hash}.svg"
        }[key]
      end

      def call(*args)
        _stdout, stderr, status = Open3.capture3(*args)
        raise stderr unless status.success?
      end

      def prepare_files
        unless File.exist?(file(:tex))
          File.open(file(:tex), 'w') { |file| file.write(@code) }
        end

        call(
          'latexmk', "-output-directory=#{@@work_dir}", file(:tex)
        ) unless File.exist?(file(:dvi)) && File.exist?(file(:yml))

        call(
          'dvisvgm', '--no-fonts',
          file(:dvi), "--output=#{file(:tfm)}"
        ) unless File.exist? file(:tfm)

        call(
          'dvisvgm', '--no-fonts', '--exact',
          file(:dvi), "--output=#{file(:fit)}"
        ) unless File.exist? file(:fit)
      end

      def load_metrics_and_boxes
        @tex = TeXBox.new(file(:yml))
        @tfm = SVGBox.new(file(:tfm))
        @fit = SVGBox.new(file(:fit))
      end

      def rescale_boxes
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
        site.static_files << Jekyll::StaticFile.new(
          site, @@work_dir, @@path, "#{@hash}.svg"
        )
      end

      def return_tag
        "<img style='margin:#{@mt}ex #{@mr}ex #{@mb}ex #{@ml}ex;"\
        "height:#{@fit.dy}ex' src='#{@@path}/#{@hash}.svg'>"
      end

      def assemble_preamble(context)
        page_preamble = context.environments.first["page"]["preamble"] || ""
        @preamble = @@config['preamble']
      end

      def render(context)
        @snippet = super
        assemble_preamble(context)
        configure(context)
        @code = tex_sourcecode(@preamble, @snippet)
        @hash = Digest::MD5.hexdigest(@code)

        prepare_files
        load_metrics_and_boxes
        rescale_boxes
        compute_margins
        stash_image(context.registers[:site])
        return_tag
      end
    end
  end
end

Liquid::Template.register_tag('tex', Jekyll::TeX::TeXBlock)
