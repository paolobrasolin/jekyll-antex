# frozen_string_literal: true

require 'antex'

require 'jekyll/antex/version'
require 'jekyll/antex/dealiaser'
require 'jekyll/antex/block'

# NOTE: I'm pretty conflicted about this.
SafeYAML::OPTIONS[:whitelisted_tags].push('!ruby/regexp')

# NOTE: we're not registering :posts since they are :documents too.
Jekyll::Hooks.register [:documents, :pages], :pre_render do |resource|
  resource.content = Jekyll::Antex::Dealiaser.run(resource)
end

Liquid::Template.register_tag('antex', Jekyll::Antex::Block)
