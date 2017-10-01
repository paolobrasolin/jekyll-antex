# frozen_string_literal: true

require 'jekyll/antex'
require 'jekyll_helper'

describe 'default configuration' do
  setup_tmpdir

  setup_site

  setup_page <<~'SOURCE'
  SOURCE

  before do
    site.setup
    site.read
    # NOTE: we deliberately omit generation
    #   in order to test only the rendering
    # site.generate
  end

  # it 'renders matched regexp with typeset image' do
  #   expect { site.pages.first.render site.layouts, site.site_payload }
  #     .to change { site.pages.first.content }
  #     .from(<<~'READ').to(include <<~'RENDERED')
  #   READ
  #   RENDERED
  # end

  # it 'includes rendered image into static files' do
  #   expect { site.pages.first.render site.layouts, site.site_payload }
  #     .to change { site.static_files.length }.by 1
  # end
end
