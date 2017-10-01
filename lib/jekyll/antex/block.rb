# frozen_string_literal: true

require 'jekyll'
require 'liquid'
require 'antex'
require 'yaml'

require 'jekyll/antex/options'

module Jekyll
  module Antex
    class Block < Liquid::Block
      def initialize(tag, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        options = build_options context: context, markup: @markup
        job = ::Antex::Job.new snippet: super, options: options
        job.run!
        add_static_file context.registers[:site], job
        render_html job
      end

      private

      def render_html(job)
        img_tag = render_img_tag src: File.join('antex', File.basename(job.files['svg'])),
                                 set_box: job.set_box
        classes = job.options['classes'].join(' ')
        "<span class='#{classes}'>#{img_tag}</span>"
      end

      def render_img_tag(src:, set_box:, precision: 3)
        <<~IMG_TAG.gsub(/(\s\s+)/m, ' ').strip!
          <img style='margin: #{set_box.mt.round(precision)}ex
                              #{set_box.mr.round(precision)}ex
                              #{set_box.mb.round(precision)}ex
                              #{set_box.ml.round(precision)}ex;
                      height: #{set_box.th.round(precision)}ex;
                      width:  #{set_box.wd.round(precision)}ex;'
              src='#{src}' />
        IMG_TAG
      end

      def add_static_file(site, job)
        site.static_files << Jekyll::StaticFile.new(
          site,
          job.dirs['work'],
          job.dirs['dest'].gsub(/^#{Regexp.escape job.dirs['work']}(?=\/|$)/, ''),
          File.basename(job.files['svg'])
        )
      end

      def build_options(context:, markup:)
        Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                     context.registers[:site].config['antex'] || {},
                                     context.registers[:page]['antex'] || {},
                                     YAML.safe_load(markup) || {}
      end
    end
  end
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)
