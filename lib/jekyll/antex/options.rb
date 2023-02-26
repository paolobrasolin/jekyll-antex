# frozen_string_literal: true

require 'yaml'
require 'jekyll'
require 'rubygems/version'

module Jekyll
  module Antex
    module Options
      if Gem::Version.new(Psych::VERSION) < Gem::Version.new("4.0.0")
        DEFAULTS =
          YAML.load_file(File.join(File.dirname(__FILE__), 'defaults.yml')).freeze
      else
        DEFAULTS =
          YAML.load_file(File.join(File.dirname(__FILE__), 'defaults.yml'), permitted_classes: [Regexp]).freeze
      end

      def self.build(*hashes)
        hashes.reduce({}) do |result, hash|
          Jekyll::Utils.deep_merge_hashes result, hash
        end
      end
    end
  end
end
