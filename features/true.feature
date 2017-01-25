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

      Woot.
      """
    When I run jekyll
    Then the "_site/index.html" file should exist

