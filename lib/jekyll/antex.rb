# frozen_string_literal: true

require 'antex'

require 'jekyll/antex/version'
require 'jekyll/antex/dealiaser'
require 'jekyll/antex/block'

# NOTE: I'm pretty conflicted about this.
SafeYAML::OPTIONS[:whitelisted_tags].push('!ruby/regexp')

Jekyll::Hooks.register :site, :pre_render do |site, final_payload|
  Jekyll::Antex.jobs = []
end

# NOTE: we're not registering :posts since they are :documents too.
Jekyll::Hooks.register [:documents, :pages], :pre_render do |resource|
  resource.content = Jekyll::Antex::Dealiaser.run(resource)
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)

Jekyll::Hooks.register :site, :post_render do |site, final_payload|
  # TODO: filter jobs not needing compilation
  jobs_count = Jekyll::Antex.jobs.count

  Jekyll.logger.writer << "Compiling TeX: ".rjust(20)
  Jekyll::Antex.jobs.each_with_index do |job, i, k|
    status = i.next.to_s.rjust(jobs_count.to_s.length) + " of #{jobs_count}"
    Jekyll.logger.writer << status
    job.run!
    site.pages.each do |page|
      page.output.gsub!(job.hash) { Jekyll::Antex::Block.render_html(job) }
    end
    Jekyll.logger.writer << "\b" * status.length
  end
  Jekyll.logger.writer << "#{jobs_count} jobs completed.\n"
end
