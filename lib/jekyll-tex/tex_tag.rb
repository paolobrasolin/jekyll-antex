require 'open3'

module Jekyll
  module TeX
    class TeXBlock < Liquid::Block
      @@config = {
        'path' => 'tex',
        'work_dir' => '.tex-cache',
        'preamble' => ''
      }

      @@config.merge!(Jekyll.configuration({})['tex'] || {})

      @@path = @@config['path']
      @@work_dir = @@config['work_dir']
      @@output_dir = "#{@@work_dir}/#{@@path}"
      FileUtils.mkdir_p @@work_dir.to_s
      FileUtils.mkdir_p @@output_dir.to_s

      def initialize(tag, markup, tokens)
        super
        # @markup = markup
        # @inline = markup.include? 'inline'
        # @subtle = markup.include? 'subtle'
        @tokens = tokens
      end

      def render(context)
        snippet = super
        site = context.registers[:site]

        # page_preamble = context.environments.first["page"]["preamble"] || ""
        preamble = @@config['preamble']

        code = <<'CLASS' + preamble + <<'TEXT' + <<SNIPPET + <<'BODY'
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

        @hash = Digest::MD5.hexdigest(code)

        File.open("#{@@work_dir}/#{@hash}.tex", 'w') do |file|
          file.write(code)
        end

        unless File.exist?("#{@@output_dir}/#{@hash}.svg")
          _stdout, _stderr, _status = Open3.capture3(
            'latexmk',
            "-output-directory=#{@@work_dir}",
            "#{@@work_dir}/#{@hash}.tex"
          )
          _stdout, _stderr, _status = Open3.capture3(
            'dvisvgm',
            '--no-fonts',
            "#{@@work_dir}/#{@hash}.dvi",
            "--output=#{@@work_dir}/#{@hash}.tfm.svg"
          )
          _stdout, _stderr, _status = Open3.capture3(
            'dvisvgm',
            '--exact',
            '--no-fonts',
            "#{@@work_dir}/#{@hash}.dvi",
            "--output=#{@@work_dir}/#{@hash}.fit.svg"
          )
        end

        tex = TeXBox.new("#{@@work_dir}/#{@hash}.yml")
        tfm = SVGBox.new("#{@@work_dir}/#{@hash}.tfm.svg")
        fit = SVGBox.new("#{@@work_dir}/#{@hash}.fit.svg")

        r = (tex.ht + tex.dp) / tfm.dy
        tfm.scale(r)
        fit.scale(r)

        ml = - tfm.ox + fit.ox
        mt = - tfm.oy + fit.oy
        mr =   tfm.dx - fit.dx - ml
        mb =   tfm.dy - fit.dy - mt - tex.dp

        FileUtils.cp("#{@@work_dir}/#{@hash}.fit.svg",
                     "#{@@output_dir}/#{@hash}.svg")

        site.static_files << Jekyll::StaticFile.new(
          site, @@work_dir, @@path, "#{@hash}.svg"
        )

        "<img style='margin:#{mt}ex #{mr}ex #{mb}ex #{ml}ex;"\
        "height:#{fit.dy}ex' src='#{@@path}/#{@hash}.svg'>"
      end
    end
  end
end

Liquid::Template.register_tag('tex', Jekyll::TeX::TeXBlock)
