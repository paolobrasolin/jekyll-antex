# frozen_string_literal: true

require 'yaml'

module Jekyll
  module TeXyll
    module Metrics
      class TeXBox < Jekyll::TeXyll::Metrics::Set
        private

        def load(filename)
          @metrics = Hash[
            YAML.load_file(filename).map do |(key, value)|
              [key.to_sym, value.chomp('pt').to_f]
            end
          ]
          @metrics[:pt] ||= 1.0
          @metrics
        end
      end
    end
  end
end
