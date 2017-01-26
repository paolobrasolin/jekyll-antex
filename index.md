---
layout: default
---

# Introducing {% tex %}\TeX\kern-.15em yll{% endtex %}

This is my first paragraph

## What is this?

Display math: $$\int\sum_{i=0}^\infty x_i$$

Inline math: $\int\sum_{i=0}^\infty x_i$.

Not really inline: $something
someting else$.

Alignment test:

<span class="wrap"><span class="rule"></span></span>
ex{% tex %}xcel{% endtex %}lent:
{% tex ---
preamble: >
  \usepackage{xcolor}
  \color{red}
%}\rule{1ex}{1ex}{% endtex %}
{% tex %}$\displaystyle\int\sum_{i=0}^\infty x_i${% endtex %}

{% tikz %}
  \fill circle (10pt);
{% endtikz %}

{% raw %}
    This $is$ literal code
{% endraw %}
