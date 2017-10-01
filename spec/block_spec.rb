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

    it 'renders matched regexp with typeset image' do
      expect { site.pages.first.render site.layouts, site.site_payload }
        .to change { site.pages.first.content }
        .from(<<~'GENERATED').to(include <<~'GENERATED')
          ---
          This is my first {% antex ---
          classes:
          - antex
          - inline
           %}\TeX{% endantex %} paragraph.
      GENERATED
          <p>This is my first <span class="antex inline"><img style="margin: 0.001ex 0.056ex -0.5ex 0.0ex; height: 2.086ex; width: 4.267ex;" src="antex/eccd48af60d2010639393a7de1b901c7.svg" /></span> paragraph.</p>
      GENERATED
    end
  end
end
