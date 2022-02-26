module.exports = {
  before : function (browser) {
    browser.setWindowSize(1200 + 32, 800 + 168);
  },
  //Each "export" counts as one test case
  'home': browser => {
    browser.url('http://localhost:8000')
      .waitForElementVisible('body', 1000)
      .saveScreenshot('./reports/home.png')

    // browser.end()
  },
  'projects': browser => {
    browser.url('http://localhost:8000/projects')
      .waitForElementVisible('body', 1000)
      .pause(1000) // loading images
      .saveScreenshot('./reports/projects.png')

    // browser.end()
  },
}
