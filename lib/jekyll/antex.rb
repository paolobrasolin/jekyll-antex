# frozen_string_literal: true

require 'antex'

require 'jekyll/antex/version'
require 'jekyll/antex/dealiaser'
require 'jekyll/antex/block'

module Jekyll
  module Antex
    def self.run_jobs
      jekyll_antex_jobs = Jekyll::Antex.jobs
      jobs_count = jekyll_antex_jobs.count
      jekyll_logger_writer = Jekyll.logger.writer
      jekyll_logger_writer << 'Compiling TeX: '.rjust(20)
      jekyll_antex_jobs.values.each_with_index do |job, index|
        run_job(job, index, jobs_count, jekyll_logger_writer)
      end
      jekyll_logger_writer << "#{jobs_count} jobs completed.\n"
    end

    def self.run_job(job, index, jobs_count, jekyll_logger_writer)
      progress = "job #{index.next.to_s.rjust(jobs_count.to_s.length)} of #{jobs_count} "
      jekyll_logger_writer << progress
      job.run!
      jekyll_logger_writer << ("\b" * progress.length)
    end

    def self.inject_style_attributes(output)
      output.gsub(/data-antex="(?<hash>.*?)"/) do
        job = Jekyll::Antex.jobs[Regexp.last_match[:hash]]
        Jekyll::Antex::Block.render_style_attribute(job.set_box)
      end
    end
  end
end

# NOTE: I'm conflicted, but regexp flags in yaml must be easy to use.
SafeYAML::OPTIONS[:whitelisted_tags].push('!ruby/regexp')

Jekyll::Hooks.register :site, :pre_render do
  Jekyll::Antex.jobs = {}
end

# NOTE: we're not registering :posts since they are included in :documents.
Jekyll::Hooks.register [:documents, :pages], :pre_render do |resource|
  resource.content = Jekyll::Antex::Dealiaser.run(resource)
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)

Jekyll::Hooks.register :site, :post_render do |site|
  Jekyll::Antex.run_jobs
  [*site.pages, *site.documents].each do |resource|
    # NOTE: skip unrendered resources e.g. when using --incremental
    next if resource.output.nil?
    resource.output = Jekyll::Antex.inject_style_attributes(resource.output)
  end
end
