require 'nokogiri'

module Jekyll
  module TeX
    class SVGBox
      attr_reader :ox # x origin
      attr_reader :oy # y origin
      attr_reader :dx # x size (width)
      attr_reader :dy # y size (height)

      def load_from_svg(filename)
        file = File.read(filename)
        svg = Nokogiri::XML.parse(file)
        @ox, @oy, @dx, @dy = svg.css('svg').attribute('viewBox')
                                .to_s.split(' ').map(&:to_f)
      end

      def scale(r)
        @ox, @oy, @dx, @dy = [@ox, @oy, @dx, @dy].map { |x| r * x }
      end
    end
  end
end
