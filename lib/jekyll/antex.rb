# frozen_string_literal: true

# This first block must go into its own library
require 'jekyll/antex/compiler/job'
require 'jekyll/antex/compiler/pipeline'
require 'jekyll/antex/metrics/gauge'
require 'jekyll/antex/metrics/set'
require 'jekyll/antex/metrics/tex_box'
require 'jekyll/antex/metrics/svg_box'

require 'jekyll/antex/version'
require 'jekyll/antex/error'
require 'jekyll/antex/options'
require 'jekyll/antex/alias'
require 'jekyll/antex/dealiaser'
require 'jekyll/antex/generator'
require 'jekyll/antex/block'

module Jekyll
  module Antex
  end
end
