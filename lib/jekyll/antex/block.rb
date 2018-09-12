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

      private

      def self.render_html(job)
        img_tag = render_img_tag job
        classes = job.options['classes'].join(' ')
        "<span class='#{classes}'>#{img_tag}</span>"
      end

      def self.render_img_tag(job)
        "<img data-antex='#{job.hash}' src='#{img_url(job)}' />"
      end

      def self.render_style_attribute(job_set_box, precision: 3)
        <<~IMG_TAG.gsub(/(\s\s+)/m, ' ').strip!
          style='margin: #{job_set_box.mt.round(precision)}ex
                         #{job_set_box.mr.round(precision)}ex
                         #{job_set_box.mb.round(precision)}ex
                         #{job_set_box.ml.round(precision)}ex;
                 height: #{job_set_box.th.round(precision)}ex;
                 width:  #{job_set_box.wd.round(precision)}ex;'
        IMG_TAG
      end

      def add_static_file(site, job)
        site.static_files << Jekyll::StaticFile.new(
          site, *self.class.static_file_paths(job)
        )
      end

      def self.img_url(job)
        _, dest_dir, filename = static_file_paths job
        url_path_prefix = job.options['url_path_prefix'] || '/'
        File.join url_path_prefix, dest_dir, filename
      end

      def self.static_file_paths(job)
        work_dir_prefix = %r{^#{Regexp.escape job.dirs['work']}(?=\/|$)}
        # base, dir, name
        [
          job.dirs['work'],
          job.dirs['dest'].sub(work_dir_prefix, '').sub(%r{^\/}, ''),
          File.basename(job.files['svg'])
        ]
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
