# frozen_string_literal: true

module Jekyll::Antex
  class Block < Liquid::Block
    def initialize(tag, markup, tokens)
      super
      @markup = markup
    end

    def render(context)
      options = load_options(registers: context.registers)
      job = Antex::Compiler::Job.new(snippet: super, options: options)
      job.run
      add_static_files(context.registers[:site], job)
      job.html_tag
    end

    private

    def add_static_files(site, job)
      FileUtils.cp(job.file(:fit), job.file(:svg))
      # TODO: minify/compress svg?
      site.static_files << Jekyll::StaticFile.new(
        site, job.dir(:work), job.options['dest_dir'], "#{job.hash}.svg"
      )
    end

    def load_options(markup: @markup, registers:)
      Jekyll::Antex::Options.build Jekyll::Antex::Options::DEFAULTS,
                                   registers[:site].config['antex'] || {},
                                   registers[:page]['antex'] || {},
                                   YAML.safe_load(markup) || {}
    end
  end
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)
