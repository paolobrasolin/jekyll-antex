# frozen_string_literal: true

require 'securerandom'

module Jekyll
  module Antex
    class Stasher
      attr_reader :matchers

      def initialize(matchers)
        @stash = []
        @matchers = matchers
        @matchers.sort_by!(&:priority)
        @matchers.reverse!
      end

      def lift(input)
        input.dup.tap do |output|
          @matchers.each do |matcher|
            output.gsub!(matcher.regexp) do
              store(Regexp.last_match, matcher)
            end
          end
        end
      end

      def bake
        @stash.map! do |uuid, match, matcher|
          replacement = yield match, matcher
          [uuid, match, matcher, replacement]
        end
      end

      def drop(input)
        input.dup.tap do |output|
          @stash.each do |uuid, match, _, replacement|
            output.gsub!(uuid) { replacement || match.to_s }
          end
        end
      end

      private

      def store(match, matcher)
        SecureRandom.uuid.tap do |uuid|
          @stash.push([uuid, match, matcher, nil])
        end
      end
    end
  end
end
