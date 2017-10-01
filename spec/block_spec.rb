# frozen_string_literal: true

require 'jekyll/antex/block'
require 'jekyll_helper'

describe Jekyll::Antex::Block do
  setup_tmpdir

  describe 'jekyll integration' do
    setup_site

    setup_page <<~'SOURCE'
      ---
      This is my first {% antex %}\TeX{% endantex %} paragraph.
    SOURCE

    before do
      site.setup
      site.read
      # NOTE: we deliberately omit generation
      #   in order to test only the rendering
      # site.generate
    end

    it 'renders matched regexp with typeset image' do
      expect { site.pages.first.render site.layouts, site.site_payload }
        .to change { site.pages.first.content }
        .from(<<~'READ').to(include <<~'RENDERED')
          ---
          This is my first {% antex %}\TeX{% endantex %} paragraph.
      READ
          <p>This is my first <span class="antex"><img style="margin: 0.001ex 0.056ex -0.5ex 0.0ex; height: 2.086ex; width: 4.267ex;" src="antex/eccd48af60d2010639393a7de1b901c7.svg" /></span> paragraph.</p>
      RENDERED
    end

    it 'includes rendered image into static files' do
      expect { site.pages.first.render site.layouts, site.site_payload }
        .to change { site.static_files.length }.by 1
    end
  end
end
