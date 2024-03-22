const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Navigate to webpage
  await page.goto('https://cdillon-bpcalc-staging.northeurope.azurecontainer.io/');

  // Fill in the systolic and diastolic values
  await page.waitForSelector('#BP_Systolic');
  await page.evaluate(() => {
    document.querySelector('#BP_Systolic').value = '140';
  });
  await page.waitForSelector('#BP_Diastolic');
  await page.evaluate(() => {
    document.querySelector('#BP_Diastolic').value = '85';
  });

  // Click the submit button
  await page.click('input[type="submit"]');

  // Wait for the result to be displayed
  await page.waitForSelector('.form-group');

  // Get the displayed result
  const result = await page.$eval('.form-group', (el) => el.innerText);

  // Check if the result is as expected
  const resultText = await page.evaluate(() => {
    return document.body.textContent.includes('Pre-High Blood Pressure');
  });

  if (resultText) {
    console.log('Test Passed: Result is Pre-High Blood Pressure');
  } else {
    console.error('Test Failed: Unexpected result');
  }
  // Close the browser
  await browser.close();
})();

