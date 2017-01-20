module Jekyll
  module TeX
    class Options
      attr_reader :merged

      def initialize(*levels)
        @merged = default
        levels.each do |level|
          @merged.merge!(level)
        end
      end

      private

      def default
        {
          'path' => 'tex',
          'work_dir' => '.tex-cache',
          'preamble' => '',
          'template' => <<'TEMPLATE'
\documentclass{article}
\pagestyle{empty}
{{preamble}}
\newsavebox\snippet
\begin{lrbox}{\snippet}{{snippet}}\end{lrbox}
\newwrite\file
\immediate\openout\file=\jobname.yml
\immediate\write\file{em: \the\dimexpr1em}
\immediate\write\file{ex: \the\dimexpr1ex}
\immediate\write\file{ht: \the\ht\snippet}
\immediate\write\file{dp: \the\dp\snippet}
\immediate\write\file{wd: \the\wd\snippet}
\closeout\file
\begin{document}\usebox{\snippet}\end{document}
TEMPLATE
        }
      end
    end
  end
end
