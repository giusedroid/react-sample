const {Given, When, Then} = require( "cucumber" );
const {
    visitPage, 
    fillInWith, 
    press, 
    waitFor, 
    see,
    whatPageIsThis
} = require('../support/actions');

Given('I am on the {string} Page', visitPage);

When('I fill in {string} with {string}', fillInWith);

When('I press {string}', press);

When('I wait for {int} seconds', waitFor);

Then('I should see a {string} containing {string}', see);

Then('I should be on the {string} page', whatPageIsThis);