#require 'execjs'
#require 'digest'
#require 'yaml'
require 'nokogiri'
#require 'fileutils'
require 'open3'

module Jekyll
    module TeX
        class TeXBlock < Liquid::Block

            @@config = {
                'path' => 'tex',
                'work_dir' => '.tex-cache',
                'preamble' => ''
            }

            @@config.merge!( Jekyll.configuration({})['tex'] || {} )

            @@path = @@config['path']
            @@work_dir = @@config['work_dir']
            @@output_dir = "#{@@work_dir}/#{@@path}"
            FileUtils.mkdir_p "#{@@work_dir}"
            FileUtils.mkdir_p "#{@@output_dir}"

            def initialize(tag, markup, tokens)
                super
                @markup = markup
                @inline = markup.include? 'inline'
                @subtle = markup.include? 'subtle'
                @tokens = tokens
            end

            def render(context)
                puts context.class
                site = context.registers[:site]
                math = super

                # page_preamble = context.environments.first["page"]["preamble"] || ""
                preamble = @@config["preamble"]

                code = <<'CLASS' + preamble + <<'TEXT' + <<SNIPPET + <<'BODY'
\documentclass{article}
\pagestyle{empty}
CLASS
\newsavebox\snippet
\newlength\height
\newlength\depth
\newlength\width
TEXT
\\begin{lrbox}{\\snippet}#{math}\\end{lrbox}
SNIPPET
\settoheight\height{\usebox\snippet}
\settodepth \depth {\usebox\snippet}
\settowidth \width {\usebox\snippet}
\makeatletter
\newwrite\file
\immediate\openout\file=\jobname.yml
\immediate\write\file{ex: \strip@pt\dimexpr 1ex}
\immediate\write\file{dp: \strip@pt\depth}
\immediate\write\file{ht: \strip@pt\height}
\immediate\write\file{wd: \strip@pt\width}
\addtolength{\height} {\depth}
\immediate\write\file{th: \strip@pt\height}
\closeout\file
\makeatother
\begin{document}\usebox{\snippet}\end{document}
BODY

                hash = Digest::MD5.hexdigest(code+@markup)

                File.open("#{@@work_dir}/#{hash}.tex", 'w') do |file|
                    file.write(code)
                end

                if !File.exists?("#{@@output_dir}/#{hash}.svg")
                    puts "Processing TeX snippet #{hash}..."
                    latexmk_parameters = "-silent -output-directory=#{@@work_dir} #{@@work_dir}/#{hash}.tex"
#                    output = `latexmk #{latexmk_parameters}`
                    stdout, stderr, status = Open3.capture3(
                      'latexmk',
                      "-output-directory=#{@@work_dir}",
                      "#{@@work_dir}/#{hash}.tex"
                    )
                    output = `dvisvgm    -n #{@@work_dir}/#{hash}.dvi -o #{@@work_dir}/#{hash}.tfm.svg`
                    output = `dvisvgm -e -n #{@@work_dir}/#{hash}.dvi -o #{@@work_dir}/#{hash}.fit.svg`
#                    output = `latexmk -C #{latexmk_parameters}`
                end

                # get TeX metrics for box and convert them from (TeX) pt to ex
                metrics = YAML.load_file("#{@@work_dir}/#{hash}.yml")
                @th = metrics["th"]/metrics["ex"]
                @ht = metrics["ht"]/metrics["ex"]
                @dp = metrics["dp"]/metrics["ex"]
                @wd = metrics["wd"]/metrics["ex"]

                file = File.read("#{@@work_dir}/#{hash}.tfm.svg")
                svg = Nokogiri::XML.parse(file)
                ox, oy, dx, dy = svg.css("svg").attribute("viewBox").to_s.split(" ").map(&:to_f)
                r = @th/dy
                ox, oy, dx, dy = [ox, oy, dx, dy].map{|x|r*x}

                if @subtle

                    file = File.read("#{@@work_dir}/#{hash}.fit.svg")
                    svg = Nokogiri::XML.parse(file)
                    oX, oY, dX, dY = svg.css("svg").attribute("viewBox").to_s.split(" ").map(&:to_f).map{|x|r*x}
                    ml = oX - ox
                    mr = dx - dX - ml
                    mt = oY - oy
                    mb = dy - dY - mt - @dp
                    output = "<img style='margin:#{mt}ex #{mr}ex #{mb}ex #{ml}ex;height:#{dY}ex' src='tex/#{hash}.svg'>"

                    File.open("#{@@output_dir}/#{hash}.svg", 'w') do |file|
                        file.write(svg)
                    end
                else
                    file = File.read("#{@@work_dir}/#{hash}.tfm.svg")
                    output = "<img style='margin-bottom:#{-@dp}ex;height:#{dy}ex;' src='tex/#{hash}.svg'>"
                    File.open("#{@@output_dir}/#{hash}.svg", 'w') do |file|
                        file.write(svg)
                    end
                end

                site.static_files << Jekyll::StaticFile.new(site, @@work_dir, @@path, "#{hash}.svg")
                return output

            end

        end
    end
end

Liquid::Template.register_tag('tex', Jekyll::TeX::TeXBlock)

#                svg.css("svg").set(:style, "overflow:visible;")
#                svg.css("svg").set(:height, "#{r*dY}ex")
#                svg.css("svg").set(:width, "#{r*dX}ex")
#                svg.xpath('//comment()').remove
