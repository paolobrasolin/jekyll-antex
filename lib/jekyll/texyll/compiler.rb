# frozen_string_literal: true

module Jekyll
  module TeXyll
    class Compiler
      def initialize(snippet: '', options: {})
        @options = options
        @snippet = snippet
      end

      def compile
        make_dirs
        prepare_code
        Pipeline.new(
          pipeline: @options['pipeline'],
          engines: @options['engines'],
          context: binding
        ).run
        @gauge = Metrics::Gauge.new(
          Hash[[:yml, :tfm, :fit].map { |sym| [sym, file(sym)] }]
        )
      end

      def make_dirs
        FileUtils.mkdir_p dir(:work)
        FileUtils.mkdir_p "#{dir(:work)}/#{@options['dest_dir']}"
      end

      def prepare_code
        template = Liquid::Template.parse(@options['template'])
        @code = template.render(
          'preamble' => @options['preamble'],
          'append' => @options['append'],
          'prepend' => @options['prepend'],
          'snippet' => @snippet
        )
        @hash = Digest::MD5.hexdigest(@code)

        File.open(file(:tex), 'w') do |file|
          file.write(@code)
        end unless File.exist?(file(:tex))
      end

      def dir(key)
        { work: @options['work_dir'] }[key]
      end

      def file(key)
        dir(:work) + {
          tex: "/#{@hash}.tex",
          dvi: "/#{@hash}.dvi",
          yml: "/#{@hash}.yml",
          tfm: "/#{@hash}.tfm.svg",
          fit: "/#{@hash}.fit.svg",
          svg: "/#{@options['dest_dir']}/#{@hash}.svg"
        }[key]
      end

      def add_to_static_files(site)
        FileUtils.cp(file(:fit), file(:svg))
        # TODO: minify/compress svg?
        site.static_files << Jekyll::StaticFile.new(
          site, dir(:work), @options['dest_dir'], "#{@hash}.svg"
        )
      end

      def render_html_tag
        img_tag = @gauge.render_img_tag("#{@options['dest_dir']}/#{@hash}.svg")
        classes = @options['classes'].join(' ')
        "<span class='#{classes}'>#{img_tag}</span>"
      end
    end
  end
end
