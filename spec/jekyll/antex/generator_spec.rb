# frozen_string_literal: true

require 'jekyll_helper'

describe Jekyll::Antex::Dealiaser do
  subject { Jekyll::Antex::Dealiaser }
  setup_tmpdir

  describe '.build_guarder' do
    it 'ignores guards set to false' do
      expect(subject.build_guarder(YAML.safe_load(<<~YAML)).matchers).to be_empty
        guards:
          foo: false
      YAML
    end
  end

  describe '.build_aliaser' do
    it 'ignores aliases set to false' do
      expect(subject.build_aliaser(YAML.safe_load(<<~YAML)).matchers).to be_empty
        aliases:
          foo: false
      YAML
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

      let(:page) { site.pages.first }

      it 'dealiases matched regexp as an "antex" liquid tag' do
        expect { Jekyll::Hooks.trigger :pages, :pre_render, page }.
          to change { page.content }.
          from(<<~'READ').to(<<~'GENERATED')
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

      let(:post) { site.posts.first }

      it 'dealiases matched regexp as an "antex" liquid tag' do
        expect { Jekyll::Hooks.trigger :documents, :pre_render, post }.
          to change { post.content }.
          from(<<~'READ').to(<<~'GENERATED')
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

      let(:page) { site.pages.first }

      it 'protects code from dealiasing with guards' do
        expect { Jekyll::Hooks.trigger :pages, :pre_render, page }.
          to_not change { page.content }.
          from(<<~'READ')
            ---
            <!- aaa FOO bbb OOF ccc -->
            aaa <!- FOO --> bbb OOF ccc
            aaa FOO bbb <!- OOF --> ccc
        READ
      end
    end
  end

  describe '.dealias_tag' do
    let(:simple_alias) { Jekyll::Antex::Alias.new(regexp: /FOO(?<code>.*?)OOF/) }
    let(:tricky_alias) do
      Jekyll::Antex::Alias.new(
        regexp: /BAZ(?<markup>.*?)#(?<code>.*?)ZAB/,
        options: { 'a' => 1, 'b' => 2 }
      )
    end

    it 'interpolates basic alias' do
      expect(described_class.dealias_tag(simple_alias.regexp.match(<<~INPUT), simple_alias)).to eq <<~OUTPUT.chomp
        FOO code here OOF
      INPUT
        {% antex --- {}
         %} code here {% endantex %}
      OUTPUT
    end

    it 'interpolates alias options' do
      expect(described_class.dealias_tag(tricky_alias.regexp.match(<<~INPUT), tricky_alias)).to eq <<~OUTPUT.chomp
        BAZ# code here ZAB
      INPUT
        {% antex ---
        a: 1
        b: 2
         %} code here {% endantex %}
      OUTPUT
    end

    it 'interpolates markup options' do
      expect(described_class.dealias_tag(tricky_alias.regexp.match(<<~INPUT), tricky_alias)).to eq <<~OUTPUT.chomp
        BAZ { b: 0, c: -1 } # code here ZAB
      INPUT
        {% antex ---
        a: 1
        b: 0
        c: -1
         %} code here {% endantex %}
      OUTPUT
    end
  end
end
