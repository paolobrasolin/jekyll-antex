# frozen_string_literal: true

require 'jekyll/antex/block'
require 'jekyll_helper'

require 'byebug'

require 'jekyll/antex'

describe Jekyll::Antex::Block do
  setup_tmpdir

  context 'full page rendering' do
    setup_site

    setup_page <<~'SOURCE'
      ---
      This is my first \TeX paragraph.
    SOURCE

    # before { site.process }

    before do
      site.setup
      site.read
      site.generate
    end

    it 'does something' do
      # site.pages.first.render site.layouts, site.site_payload
      # site.pages.first.content
    end
  end
end
