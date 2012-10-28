Feature: integrate with Rails

  Background:
    When I generate a new rails application
    And  I copy the generic app files from the support folder into the generated app
    And  I configure the application to use the view_models gem from this project
    And  I configure the application to use the following gems
      | Name                  | Version   | Require |
      | factory_girl_rails    | ~> 1.7.0  |         |
      | factory_girl          | ~> 2.6.4  |         |
      | cucumber-rails        | ~> 1.3.0  | false   |
      | rspec-rails           | ~> 2.11.0 |         |
      | capybara              | ~> 1.1.2  |         |
      | slim-rails            | ~> 1.0.3  |         |
    And  I successfully run `bundle install --local`
    And  I successfully run `bundle exec rake db:migrate`
    
  Scenario:
    When I successfully run `bundle exec rake cucumber`
    Then the output should contain "2 scenarios (2 passed)"
    And the output should contain "17 steps (17 passed)"