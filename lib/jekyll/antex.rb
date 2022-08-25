# frozen_string_literal: true

require 'antex'
require 'nokogiri'

require 'jekyll/antex/version'
require 'jekyll/antex/dealiaser'
require 'jekyll/antex/block'

module Jekyll
  module Antex
    def self.gather_resources(site)
      pages = site.pages
      documents = site.collections.values.flat_map(&:docs)
      [*pages, *documents].filter(&method(:allowed_resource?))
    end

    def self.allowed_resource?(resource)
      # TODO: perhaps this should be configurable
      File.fnmatch('*.{html,md}', resource.relative_path, File::FNM_EXTGLOB)
    end

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
  end
end

# NOTE: I'm conflicted, but regexp flags in yaml must be easy to use.
SafeYAML::OPTIONS[:whitelisted_tags].push('!ruby/regexp')

Jekyll::Hooks.register :site, :pre_render do |site|
  Jekyll::Antex.jobs = {}
  Jekyll::Antex.gather_resources(site).each do |resource|
  resource.content = Jekyll::Antex::Dealiaser.run(resource)
  end
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)

Jekyll::Hooks.register :site, :post_render do |site|
  Jekyll::Antex.run_jobs
  Jekyll::Antex.gather_resources(site).each do |resource|
    # NOTE: skip unrendered resources e.g. when using --incremental
    next if resource.output.nil?
    resource.output = Jekyll::Antex::Block.replace_placeholders(resource.output)
  end
end
