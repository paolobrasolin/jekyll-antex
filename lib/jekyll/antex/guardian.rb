# frozen_string_literal: true

require 'securerandom'

module Jekyll
  module Antex
    class Guardian
      attr_reader :guards

      def initialize(tag: 'antex')
        @guards = []
        @stash = {}
        @tag = tag
      end

      def add_guards(guards)
        @guards.concat(guards).sort_by!(&:priority).reverse!
      end

      def apply(content)
        @content = content.dup
        @stash = {}
        stash_guards
        @content
      end

      def remove(content)
        @content = content.dup
        unstash_guards
        @content
      end

      private

      def stash_guards
        @guards.each do |guard|
          @content.gsub!(guard.regexp) do
            uuid = SecureRandom.uuid
            @stash.store uuid, Regexp.last_match.to_s
            uuid
          end
        end
      end

      def unstash_guards
        @stash.each do |uuid, guard_match|
          @content.gsub!(uuid) { guard_match }
        end
      end
    end
  end
end
