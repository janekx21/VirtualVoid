module.exports = {
  before : (browser) => {
    browser.setWindowSize(1200 + 32, 800 + 168);
  },
  //Each "export" counts as one test case
  'home': browser => {
    browser.url('http://localhost:8000')
      .waitForElementVisible('body', 1000)
      .saveScreenshot('./reports/home.png')
  },
  'projects': browser => {
    browser.url('http://localhost:8000/projects')
      .waitForElementVisible('body', 1000)
      .pause(1000) // loading images
      .saveScreenshot('./reports/projects.png')
  },
  'projects/demo': browser => {
    browser.url('http://localhost:8000/projects')
        .waitForElementVisible('body', 1000)
        .click("body > div.fc-0-0-0-255.font-size-16.ff-ibm-plex-sanssans-serif.bg-244-244-244-255.s.e.wf.ui.s.e > div.hc.s.c.wf.ct.cl > div.hf.p-100-10.s.e.wf > div > div > div.spacing-2-2.s.e.wf > div > div:nth-child(1) > div.nb.e.fr > div")
        .saveScreenshot('./reports/demo_project.png')
  },
}
