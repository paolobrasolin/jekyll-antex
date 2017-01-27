# frozen_string_literal: true

module Jekyll
  module TeXyll
    module Options
      DEFAULTS = YAML.load_file(
        File.join(File.dirname(__FILE__), 'defaults.yaml')
      ).freeze
    end
  end
end
