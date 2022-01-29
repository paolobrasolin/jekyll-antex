---
layout: default
permalink: /
antex:
  preamble: |
    \usepackage{amsmath,amsfonts}
    \usepackage[all]{xy}
    \usepackage{tikz}
    \def\anTeX{an\kern-.15em\TeX}
    \def\TikZ{Ti\textit{k}Z}
---

**Welcome!**

`jekyll-antex` is a [Jekyll][jekyll-url] plugin (powered by [anTeX][antex-url]) to embed arbitrary [LaTeX][latex-url] in your website.

This is an **unfinished** demo page; for more information please ~~refer to~~ wait until the [documentation][jekyll-antex-doc-url] is completed.

[jekyll-url]: https://jekyllrb.com/
[antex-url]: https://github.com/paolobrasolin/antex
[latex-url]: https://www.latex-project.org/
[jekyll-antex-doc-url]: https://github.com/paolobrasolin/jekyll-antex#readme

Here is a teaser:

<div class="latex">

This plugin is powered by \anTeX and lets you freely use \LaTeX in your website.

You can use inline equations like $(\partial_\mu\partial^\mu+m^2)\Phi=0$, and display equations too:
{% tex classes: [antex, display] %}
$
F([n]) = \coprod*{i=1}^n F([1]) = \coprod*{i=1}^n X = [n] \otimes X
$
{% endtex %}

Of course that's nothing <a href="https://katex.org/">KaTeX</a> or <a href="https://www.mathjax.org/">MathJax</a> can't afford you!
In fact the cool part is using \Xy-pic for commutative diagrams...
{% tex classes: [antex, display] %}
$
\xymatrix{ A\ar[r]^f \ar[d]_f & B \ar[dl]|{\hole\mathrm{id}_B\hole} \ar[d]^g \\ C \ar[r]_g & D}
\qquad
\xymatrix{ A\ar[r]^f \ar[d]_{g\circ f} & B \ar[dl]|{\hole g\hole} \ar[d]^{h\circ g} \\ B \ar[r]_h & C}
$
{% endtex %}
... \TikZ for complex illustrations...
{% tex classes: [antex, display] %}
\begin{tikzpicture}[blend group=screen]
\fill[red!90!black] ( 90:.6) circle (1);
\fill[green!80!black] (210:.6) circle (1);
\fill[blue!90!black] (330:.6) circle (1);
\end{tikzpicture}
{% endtex %}
... or anything else you can come up with, really.

</div>

I hope `jekyll-antex` can help you. ❤️
