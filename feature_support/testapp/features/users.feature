Feature: User rendering with view models

  Background:
    Given the following users exist:
      | name            | biography                 | email               |
      | Frozen&Banana   | Something > than you & me | frozen@banana.com  |
    
  Scenario:
    When I visit user Frozen&Banana's show page
    Then I should see "Frozen&Banana" within "div#user_name"
    And I should see "less than a minute" within "#creation"
    And I should see "24" within "#age"
    And I should see "woman" within "#gender"
    And I should see "frozen(at)banana.com" within "#email"
    And I should see "Something > than you & me" within "#biography"