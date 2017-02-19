#encoding: utf-8

Feature: Details
  Hurr durr

  Scenario Outline: me be stoopid
    Given I have a file "index.md" containing:
    """
    {% texyll %}\vrule width<wd>ex height<ht>ex depth<dp>ex{% endtexyll %}
    """
    When I run jekyll
    Then the file "_site/index.html" should exist
    And the image exists
    And the image has margins: <top>ex <right>ex <bottom>ex <left>ex
    And the image has size: <width>ex <height>ex

    Examples:
      | wd | ht | dp | top | right | bottom | left | width | height |
      |  1 |  1 |  1 | 0.0 |   0.0 |   -1.0 |  0.0 |   1.0 |    2.0 |
      |  1 |  0 |  1 | 0.0 |   0.0 |   -1.0 |  0.0 |   1.0 |    1.0 |
      |  1 |  1 |  0 | 0.0 |   0.0 |    0.0 |  0.0 |   1.0 |    1.0 |

  # Scenario: me be stoopid
  #   Given I have a file "index.md" containing "{% texyll %}Hello world.{% endtexyll %}"
  #   When I run jekyll
  #   Then the file "_site/index.html" should exist
  #   And the image exists


  # Scenario: me be stoopid
  #   Given I have a file "_config.yml":
  #     """
  #     texyll:
  #       aliases:
  #         foo:
  #           priority: 100
  #           regexp: !ruby/regexp
  #             /{%\s*foo\s*(?<markup>.*?)%}(?<code>.*?){%\s*endfoo\s*%}/m
  #     """
  #   And I have a file "index.md":
  #     """
  #     ---
  #     texyll:
  #       aliases:
  #         foo:
  #           priority: 0
  #           regexp: !ruby/regexp
  #             /FOO(?<markup>.*?)BAR(?<code>.*?)BAZ/m
  #     ---

  #     FOO BAR \LaTeX BAZ

  #     """
  #   When I run jekyll
  #   Then the file "_site/index.html" should exist
  #   And the image exists
