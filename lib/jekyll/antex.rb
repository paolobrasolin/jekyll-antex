# frozen_string_literal: true

require 'antex'

require 'jekyll/antex/version'
require 'jekyll/antex/dealiaser'
require 'jekyll/antex/block'

module Jekyll
  module Antex
    def self.run_jobs
      jobs_count = Jekyll::Antex.jobs.count
      Jekyll.logger.writer << "Compiling TeX: ".rjust(20)
      Jekyll::Antex.jobs.values.each_with_index do |job, i|
        progress = "job " + i.next.to_s.rjust(jobs_count.to_s.length) + " of #{jobs_count} "
        Jekyll.logger.writer << progress
        job.run!
        Jekyll.logger.writer << "\b" * progress.length
      end
      Jekyll.logger.writer << "#{jobs_count} jobs completed.\n"
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
    resource.output = Jekyll::Antex.inject_style_attributes(resource.output)
  end
end
