# require 'execjs'
# require 'digest'
# require 'yaml'
# require 'nokogiri'
# require 'fileutils'
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
        @markup = markup
        @inline = markup.include? 'inline'
        @subtle = markup.include? 'subtle'
        @tokens = tokens
      end

      def render(context)
        # puts context.class
        site = context.registers[:site]
        math = super

        # page_preamble = context.environments.first["page"]["preamble"] || ""
        preamble = @@config['preamble']

        code = <<'CLASS' + preamble + <<'TEXT' + <<SNIPPET + <<'BODY'
\documentclass{article}
\pagestyle{empty}
CLASS
\newsavebox\snippet
\newlength\height
\newlength\depth
\newlength\width
TEXT
\\begin{lrbox}{\\snippet}#{math}\\end{lrbox}
SNIPPET
\settoheight\height{\usebox\snippet}
\settodepth \depth {\usebox\snippet}
\settowidth \width {\usebox\snippet}
\makeatletter
\newwrite\file
\immediate\openout\file=\jobname.yml
\immediate\write\file{ex: \strip@pt\dimexpr 1ex}
\immediate\write\file{dp: \strip@pt\depth}
\immediate\write\file{ht: \strip@pt\height}
\immediate\write\file{wd: \strip@pt\width}
\addtolength{\height} {\depth}
\immediate\write\file{th: \strip@pt\height}
\closeout\file
\makeatother
\begin{document}\usebox{\snippet}\end{document}
BODY

        @hash = Digest::MD5.hexdigest(code + @markup)

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

        tex = TeXBox.new
        tfm = SVGBox.new
        fit = SVGBox.new

        tex.load_from_yml("#{@@work_dir}/#{@hash}.yml")
        tfm.load_from_svg("#{@@work_dir}/#{@hash}.tfm.svg")
        fit.load_from_svg("#{@@work_dir}/#{@hash}.fit.svg")

        r = tex.th / tfm.dy
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
