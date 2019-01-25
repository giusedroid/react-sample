const scope = require('./scope');
const pages = require('./pages');
const selectors = require('./selectors');
const variables = require('./variables');

// Defines whether puppeteer runs Chrome in headless mode.
let headless = false;
let slowMo = 5;
let args = [];
// Chrome is set to run headlessly and with no slowdown in CircleCI
if (process.env.CIRCLECI) headless = true;
if (process.env.CIRCLECI) slowMo = 0;
if (process.env.CIRCLECI) args.push('--no-sandbox','–disable-setuid-sandbox' );



const visitPage = async (page) => {
    if (!scope.browser)
        scope.browser = await scope.driver.launch( {headless, slowMo, args} );
    
    scope.context.currentPage = await scope.browser.newPage();
    scope.context.currentPage.setViewport({
        width: 1280,
        height: 1024
    });

    const url = `${scope.host}${pages[page]}`;
    const visit = await scope.context.currentPage.goto(url, {
        waitUntil: 'networkidle2'
    });

    return visit;
}

const fillInWith = async (target, whatKey) => {
    const what = variables[whatKey];
    const input = await scope.context.currentPage.$(selectors.input[target]);
    const filled = await input.type(what, {delay:10});
    return filled;
}

const press = async (target) => {
    const button = await scope.context.currentPage.$(selectors.button[target]);
    const pressed = await button.click();
    return pressed;
}

const waitFor = async (seconds) => await scope.context.currentPage.waitFor(seconds * 1000);

const see = async (what, content) => {
    const selector = selectors[what][content];
    const element = await scope.context.currentPage.$(selector);
    if(!element){
        throw new Error(`Element not found on ${scope.context.currentPage.url()}`);
    }
    return element;
}

const whatPageIsThis = async page => {
    const url = await scope.context.currentPage.url();
    const expected = `${scope.host}${pages[page]}`;
    if( url !== expected ) throw new Error(`I am on page ${url}, but I should be on ${expected}`);
    return url;
}


module.exports = {
    visitPage,
    fillInWith,
    press,
    waitFor,
    see,
    whatPageIsThis
}