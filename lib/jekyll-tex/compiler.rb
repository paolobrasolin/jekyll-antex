require 'open3'

module Jekyll
  module TeX
    class Compiler
      def initialize(snippet: '', options: {})
        @options = options
        @snippet = snippet
      end

      def compile
        make_dirs
        prepare_code
        call_compilation_routine
        load_metrics
        scale_bounds
        compute_margins
      end

      def make_dirs
        FileUtils.mkdir_p @options['work_dir']
        FileUtils.mkdir_p "#{@options['work_dir']}/#{@options['dest_dir']}"
      end

      def prepare_code
        template = Liquid::Template.parse(@options['template'])
        @code = template.render(
          'preamble' => @options['preamble'],
          'snippet' => @snippet
        )
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
          svg: "#{@options['work_dir']}/#{@options['dest_dir']}/#{@hash}.svg"
        }[key]
      end

      def call_to_produce(command, filelist)
        return if filelist.map(&->(file) { File.exist?(file) }).reduce(:&)
        _stdout, stderr, status = Open3.capture3(*command)
        raise stderr unless status.success?
      end

      def call_compilation_routine
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

      def add_to_static_files(site)
        FileUtils.cp(file(:fit), file(:svg))
        # TODO: minify/compress svg?
        site.static_files << Jekyll::StaticFile.new(
          site, @options['work_dir'], @options['dest_dir'], "#{@hash}.svg"
        )
      end

      def render_html_tag
        "<img style='margin:#{@mt}ex #{@mr}ex #{@mb}ex #{@ml}ex;"\
        "height:#{@fit.dy}ex' src='#{@options['dest_dir']}/#{@hash}.svg'>"
      end
    end
  end
end
