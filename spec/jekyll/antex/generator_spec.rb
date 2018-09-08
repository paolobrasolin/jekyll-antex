# frozen_string_literal: true

require 'jekyll/antex/generator'
require 'jekyll_helper'

describe Jekyll::Antex::Generator do
  setup_tmpdir

  describe 'plain old jekyll' do
    setup_site

    setup_page <<~'SOURCE'
      ---
      This is my first *very plain* paragraph.
    SOURCE

    before do
      site.setup
      site.read
      site.generate
    end

    it 'generates smoothly' do
      expect(site.pages.first.content).to include(<<~'GENERATED'.chomp)
        This is my first *very plain* paragraph.
      GENERATED
    end
  end

  describe 'jekyll integration' do
    context 'writing a page' do
      setup_site

      setup_page <<~'SOURCE'
        ---
        This is my first \TeX paragraph.
      SOURCE

      before do
        site.setup
        site.read
      end

      it 'dealiases matched regexp as an "antex" liquid tag' do
        expect { site.generate }
          .to change { site.pages.first.content }
          .from(<<~'READ').to(<<~'GENERATED')
            ---
            This is my first \TeX paragraph.
        READ
            ---
            This is my first {% antex ---
            classes:
            - antex
            - inline
             %}\TeX{% endantex %} paragraph.
        GENERATED
      end
    end

    context 'writing a post' do
      setup_site

      setup_post <<~'SOURCE'
        ---
        This is my first \TeX paragraph.
      SOURCE

      before do
        site.setup
        site.read
      end

      it 'dealiases matched regexp as an "antex" liquid tag' do
        expect { site.generate }
          .to change { site.posts.first.content }
          .from(<<~'READ').to(<<~'GENERATED')
            ---
            This is my first \TeX paragraph.
        READ
            ---
            This is my first {% antex ---
            classes:
            - antex
            - inline
             %}\TeX{% endantex %} paragraph.
        GENERATED
      end
    end

    describe 'guard/alias interaction' do
      setup_site

      setup_config <<~'CONFIG'
        antex:
          aliases:
            test_alias:
              priority: 7777777
              regexp: !ruby/regexp /FOO(?<code>.*?)OOF/
          guards:
            test_guard:
              priority: 7777777
              regexp: !ruby/regexp /<!-.*?-->/
      CONFIG

      setup_page <<~'SOURCE'
        ---
        <!- aaa FOO bbb OOF ccc -->
        aaa <!- FOO --> bbb OOF ccc
        aaa FOO bbb <!- OOF --> ccc
      SOURCE

      before do
        site.setup
        site.read
      end

      it 'protects code from dealiasing with guards' do
        expect { site.generate }
          .to_not change { site.pages.first.content }
          .from(<<~'READ')
            ---
            <!- aaa FOO bbb OOF ccc -->
            aaa <!- FOO --> bbb OOF ccc
            aaa FOO bbb <!- OOF --> ccc
        READ
      end
    end
  end
end
