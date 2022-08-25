# frozen_string_literal: true

require 'jekyll'
require 'liquid'
require 'antex'
require 'yaml'

require 'jekyll/antex/options'

module Jekyll
  module Antex
    class << self
      attr_accessor :jobs
    end

    class Block < Liquid::Block
      HASH_ATTR_NAME = 'data-antex-job-hash'

      def initialize(tag, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        options = build_options registers: context.registers, markup: @markup
        job = ::Antex::Job.new snippet: super, options: options
        Jekyll::Antex.jobs.store(job.hash, job)
        add_static_file context.registers[:site], job
        self.class.render_html(job)
      end

      def self.render_html(job)
        placeholder_tag = render_placeholder_tag job
        classes = job.options['classes'].join(' ')
        "<span class='#{classes}'>#{placeholder_tag}</span>"
      end

      def self.replace_placeholders(content)
        doc = Nokogiri::HTML.parse(content)
        placeholders = doc.xpath("//object[@#{HASH_ATTR_NAME}]")
        placeholders.each(&method(:replace_placeholder))
        doc.to_s
      end

      def self.replace_placeholder(placeholder)
        job = Jekyll::Antex.jobs[placeholder[HASH_ATTR_NAME]]
        if job.options['inlining']
          replace_placeholder_with_svg(placeholder)
        else
          replace_placeholder_with_img(placeholder)
        end
      end

      def self.replace_placeholder_with_img(placeholder)
        job = Jekyll::Antex.jobs[placeholder[HASH_ATTR_NAME]]
        style = render_style_attribute_value(job.set_box)
        img = Nokogiri::XML::Node.new('img', placeholder.document)
        src = Jekyll::Antex::Block.img_url(job)
        img.set_attribute('src', src)
        img.set_attribute('style', style)
        placeholder.add_next_sibling(img)
        placeholder.remove()
      end

      def self.replace_placeholder_with_svg(placeholder)
        job = Jekyll::Antex.jobs[placeholder[HASH_ATTR_NAME]]
        style = render_style_attribute_value(job.set_box)
        path = File.read(job.files['svg'])
        svg = Nokogiri::XML(path).at_css('svg')
        svg.remove_attribute('width')
        svg.remove_attribute('height')
        svg.set_attribute('style', style)
        placeholder.add_next_sibling(svg)
        placeholder.remove()
      end

      def self.render_placeholder_tag(job)
        "<object #{HASH_ATTR_NAME}='#{job.hash}'></object>"
      end

      def self.render_style_attribute_value(job_set_box, precision: 3)
        <<~IMG_TAG.gsub(/(\s\s+)/m, ' ').strip!
          margin: #{job_set_box.mt.round(precision)}ex
                  #{job_set_box.mr.round(precision)}ex
                  #{job_set_box.mb.round(precision)}ex
                  #{job_set_box.ml.round(precision)}ex;
          height: #{job_set_box.th.round(precision)}ex;
          width:  #{job_set_box.wd.round(precision)}ex;
        IMG_TAG
      end

      def self.img_url(job)
        _, dest_dir, filename = static_file_paths job
        url_path_prefix = job.options['url_path_prefix'] || '/'
        File.join url_path_prefix, dest_dir, filename
      end

      def self.static_file_paths(job)
        work_dir_prefix = %r{^#{Regexp.escape job.dirs['work']}(?=/|$)}
        # base, dir, name
        [
          job.dirs['work'],
          job.dirs['dest'].sub(work_dir_prefix, '').sub(%r{^/}, ''),
          File.basename(job.files['svg'])
        ]
      end

      private

      def add_static_file(site, job)
        return if job.options['inlining']
        site.static_files << Jekyll::StaticFile.new(
          site, *self.class.static_file_paths(job)
        )
      end

      def build_options(registers:, markup:)
        Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                     registers[:site].config['antex'] || {},
                                     registers[:page]['antex'] || {},
                                     YAML.safe_load(markup) || {}
      end
    end
  end
end
