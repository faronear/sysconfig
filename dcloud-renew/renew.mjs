import 'dotenv/config'
import { chromium } from 'playwright'

// dotenv.config({
//   path: '.env.local'
// })

const email = process.env.UNICLOUD_EMAIL
const password = process.env.UNICLOUD_PASSWORD

if (!email || !password) {
  throw new Error('Missing UNICLOUD_EMAIL or UNICLOUD_PASSWORD')
}

async function waitForLoginFrame (page, timeoutMs = 30000) {
  const start = Date.now()
  while (Date.now() - start < timeoutMs) {
    const f = page
      .frames()
      .find(fr => fr.url().includes('account.dcloud.net.cn'))
    if (f) return f
    await page.waitForTimeout(500)
  }
  throw new Error('Timed out waiting for account.dcloud.net.cn login iframe')
}

async function waitForUrl (page, predicate, timeoutMs = 30000) {
  const start = Date.now()
  while (Date.now() - start < timeoutMs) {
    if (predicate(page.url())) return page.url()
    await page.waitForTimeout(500)
  }
  throw new Error(`Timed out waiting for URL condition. Current: ${page.url()}`)
}

;(async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: false,
    slowMo: 200
  })

  const context = await browser.newContext()
  const page = await context.newPage()
  page.setDefaultTimeout(30000)

  await page.goto('https://unicloud.dcloud.net.cn/', {
    waitUntil: 'domcontentloaded',
    timeout: 60000
  })

  console.log('Page loaded, waiting for login iframe...')

  // 1. Login via the account.dcloud.net.cn iframe.
  const loginFrame = await waitForLoginFrame(page)
  await loginFrame.waitForSelector('input.uni-input-input', { timeout: 20000 })
  await page.waitForTimeout(1500)

  const inputs = loginFrame.locator('input.uni-input-input')
  if ((await inputs.count()) < 2) {
    throw new Error('Expected 2 inputs in login iframe')
  }
  await inputs.nth(0).click({ clickCount: 3 })
  await inputs.nth(0).fill(email)
  await inputs.nth(1).click({ clickCount: 3 })
  await inputs.nth(1).fill(password)

  await loginFrame.getByText('登录', { exact: true }).click()

  await waitForUrl(
    page,
    u => u.includes('unicloud.dcloud.net.cn') && !u.includes('/login/login')
  )
  await page.waitForTimeout(5000)
  console.log('Login successful. URL:', page.url())

  // 2. Click "续费" — opens a NEW TAB that first goes through SSO
  //    (uni-trade.dcloud.net.cn/pages/login/login?oauthToken=...) then lands
  //    on the create-order page.
  const renewBtn = page.getByText('续费', { exact: true }).first()
  await renewBtn.waitFor({ timeout: 30000 })
  const newPagePromise = new Promise(resolve => context.once('page', resolve))
  await renewBtn.click()
  const orderPage = await newPagePromise

  // Wait for the OAuth redirect to settle on create-order.
  await waitForUrl(
    orderPage,
    u => u.includes('uni-trade.dcloud.net.cn') && u.includes('create-order'),
    45000
  )
  await orderPage.waitForTimeout(3000)
  console.log('Order page ready:', orderPage.url())

  // 3. Click "立即购买" — same tab navigates to /order-payment.
  const buyBtn = orderPage.getByText('立即购买', { exact: true }).first()
  await buyBtn.waitFor({ timeout: 30000 })
  await buyBtn.click()

  await waitForUrl(orderPage, u => u.includes('order-payment'), 30000)
  await orderPage.waitForTimeout(3000)
  console.log('Payment page ready:', orderPage.url())

  // 4. Click "确认开通" to finalize.
  const confirmBtn = orderPage.getByText('确认开通', { exact: true }).first()
  await confirmBtn.waitFor({ timeout: 30000 })
  await confirmBtn.click()
  console.log('Clicked 确认开通. Renewal submitted.')

  // Wait briefly for the confirmation redirect to complete, then exit.
  await orderPage.waitForTimeout(5000)

  await browser.close()
  process.exit(0)
})()
