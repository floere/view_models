Feature: User rendering with view models

  Background:
    Given the following heroes exist:
      | name            | email               |
      | Frozen&Yoghurt  | frozen@yoghurt.com  |
    And Frozen&Yoghurt has stunned an international crowd
    
  Scenario:
    When I visit hero Frozen&Yoghurt's show page
    Then I should see "Frozen&Yoghurt" within "div#user_name"
    And I should see "less than a minute" within "#creation"
    And I should see "1000" within "#age"
    And I should see "man" within "#gender"
    And I should see "frozen(at)yoghurt.com" within "#email"
    And I should see "Reactions provoked by Frozen&amp;Yoghurt so far: Magico!, Fantastico!, Fantastique!, Marvelous!, Marveloso!!, Magnifique!, (speachless), Fantastisch!, supergut!" within "#biography"