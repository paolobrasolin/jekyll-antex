# frozen_string_literal: true

module Jekyll
  module Antex
    Guard = Struct.new(:priority, :regexp, keyword_init: true)
  end
end
