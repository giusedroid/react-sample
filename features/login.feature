Feature: Login
    Users must be authenticated in order to access many parts of the app

    Scenario:
        Given I am on the "login" Page
        When I fill in "email" with "a cloudreach email address"
        And  I fill in "password" with "a valid password"
        And  I press "login"
        And  I wait for 2 seconds
        Then I should be on the "home" page
        And  I should see a "div" containing "Notes"
    
    Scenario:
        Given I am on the "login" Page
        When  I fill in "email" with "a wrong email address"
        And   I fill in "password" with "a valid password"
        And   I press "login"
        And   I wait for 3 seconds
        Then  I should be on the "login" page