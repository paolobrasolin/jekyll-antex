# frozen_string_literal: true

module Jekyll
  module TeXyll
    module Metrics
      class Gauge
        def initialize(yml:, tfm:, fit:, precision: 3)
          @tex = TeXBox.new(yml)
          @tfm = SVGBox.new(tfm)
          @fit = SVGBox.new(fit)
          @precision = precision
          scale_bounds
          compute_margins
        end

        def scale_bounds
          r = (@tex.ht + @tex.dp) / @tfm.dy
          @tfm.scale(r)
          @fit.scale(r)
        end

        def compute_margins
          @ml = - @tfm.ox + @fit.ox
          @mt = - @tfm.oy + @fit.oy
          @mr =   @tfm.dx - @fit.dx - @ml
          @mb =   @tfm.dy - @fit.dy - @mt - @tex.dp
        end

        def render_img_tag(src)
          <<-IMG_TAG.gsub(/(\s\s+)/m, ' ').strip!
          <img style='margin: #{@mt.round(@precision)}ex
                              #{@mr.round(@precision)}ex
                              #{@mb.round(@precision)}ex
                              #{@ml.round(@precision)}ex;
                      height: #{@fit.dy.round(@precision)}ex'
              src='#{src}' />
          IMG_TAG
        end
      end
    end
  end
end
