# frozen_string_literal: true

module Jekyll::Antex
  module Options
    DEFAULTS = YAML.safe_load(<<~'YAML', [Regexp]).freeze
      dest_dir: antex
      work_dir: .antex-cache
      preamble: |
        \usepackage{amsmath, amsthm, amssymb, amsfonts}
        \usepackage{tikz}
        \usepackage{graphicx}
      template: |
        \documentclass{article}
        \pagestyle{empty}
        {{preamble}}
        \newsavebox\snippet
        \begin{lrbox}{\snippet}{{prepend}}{{snippet}}{{append}}\end{lrbox}
        \newwrite\file
        \immediate\openout\file=\jobname.yml
        \immediate\write\file{em: \the\dimexpr1em}
        \immediate\write\file{ex: \the\dimexpr1ex}
        \immediate\write\file{ht: \the\ht\snippet}
        \immediate\write\file{dp: \the\dp\snippet}
        \immediate\write\file{wd: \the\wd\snippet}
        \closeout\file
        \begin{document}\usebox{\snippet}\end{document}
      classes: [antex]
      pipeline:
        - latexmk
        - dvisvgm_tfm
        - dvisvgm_fit
      engines:
        latexmk:
          command:
            - latexmk
            - -output-directory=<%=dir(:work)%>
            - <%=file(:tex)%>
          sources:
            - <%=file(:tex)%>
          targets:
            - <%=file(:dvi)%>
            - <%=file(:yml)%>
        dvisvgm_tfm:
          command:
            - dvisvgm
            - --no-fonts
            - <%=file(:dvi)%>
            - --output=<%=file(:tfm)%>
          sources:
            - <%=file(:dvi)%>
          targets:
            - <%=file(:tfm)%>
        dvisvgm_fit:
          command:
            - dvisvgm
            - --no-fonts
            - --exact
            - <%=file(:dvi)%>
            - --output=<%=file(:fit)%>
          sources:
            - <%=file(:dvi)%>
          targets:
            - <%=file(:fit)%>
      aliases:
        internal:
          priority: 1000
          regexp: !ruby/regexp
            /{%\s*antex\s*(?<markup>.*?)%}(?<code>.*?){%\s*endantex\s*%}/m
        default:
          priority: 100
          regexp: !ruby/regexp
            /{%\s*tex\s*(?<markup>.*?)%}(?<code>.*?){%\s*endtex\s*%}/m
        tikzpicture:
          priority: 90
          regexp: !ruby/regexp
            /{%\s*tikz\s*(?<markup>.*?)%}(?<code>.*?){%\s*endtikz\s*%}/m
          options:
            prepend: '\\begin{tikzpicture}'
            append: '\\end{tikzpicture}'
            classes: [antex, tikz]
        display_math:
          priority: 20
          regexp: !ruby/regexp /\$\$(?<code>.*?)\$\$/m
          options:
            prepend: '$\\displaystyle'
            append: $
            classes: [antex, display]
        inline_math:
          priority: 10
          regexp: !ruby/regexp /\$(?<code>.*?)\$/
          options:
            prepend: $
            append: $
            classes: [antex, inline]
        simple_macro:
          priority: 0
          regexp: !ruby/regexp /(?<code>\\[A-z]+)/
          options:
            prepend:
            append:
            classes: [antex, inline]
    YAML

    def self.build(*hashes)
      hashes.reduce({}) do |result, hash|
        Jekyll::Utils.deep_merge_hashes result, hash
      end
    end
  end
end
