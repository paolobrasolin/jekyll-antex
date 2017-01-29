#encoding: utf-8

Feature: Details
  Hurr durr

  Scenario: me be stoopid
    Given I have a file "_config.yml":
      """
      somekey: value
      """
    And I have a file "index.md":
      """
      ---
      ---

      {% texyll %}\LaTeX{% endtexyll %}

      """
    When I run jekyll
    Then the file "_site/index.html" should exist
    And the image exists

