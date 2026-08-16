import 'dotenv/config'
import { chromium } from 'playwright'

// Usage:
//   node renew.mjs                          # uses .env
//   node renew.mjs <email> <password>       # CLI args override .env
//   UNICLOUD_EMAIL=... UNICLOUD_PASSWORD=... node renew.mjs   # env override
const [, , cliEmail, cliPassword] = process.argv
const email = cliEmail || process.env.UNICLOUD_EMAIL
const password = cliPassword || process.env.UNICLOUD_PASSWORD

if (!email || !password) {
  throw new Error(
    'Missing credentials. Pass them as `node renew.mjs <email> <password>` ' +
      'or set UNICLOUD_EMAIL / UNICLOUD_PASSWORD env vars (or .env).'
  )
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

// Run the purchase flow for a single "续费" button that has already been
// located on the dashboard. Resolves once the renewal is submitted and the
// browser has returned to the dashboard (so the caller can re-query rows).
async function renewOne (context, dashboardPage, renewLocator, index) {
  // Clicking 续费 opens a NEW TAB that first goes through SSO, then lands on
  // the uni-trade create-order page.
  const newPagePromise = new Promise(resolve => context.once('page', resolve))
  await renewLocator.click()
  const orderPage = await newPagePromise

  // Wait for the OAuth redirect to settle on create-order.
  await waitForUrl(
    orderPage,
    u => u.includes('uni-trade.dcloud.net.cn') && u.includes('create-order'),
    45000
  )
  await orderPage.waitForTimeout(3000)
  console.log(`[${index}] Order page ready:`, orderPage.url())

  // Click "立即购买" — same tab navigates to /order-payment.
  const buyBtn = orderPage.getByText('立即购买', { exact: true }).first()
  await buyBtn.waitFor({ timeout: 30000 })
  await buyBtn.click()

  await waitForUrl(orderPage, u => u.includes('order-payment'), 30000)
  await orderPage.waitForTimeout(3000)
  console.log(`[${index}] Payment page ready:`, orderPage.url())

  // Click "确认开通" to finalize.
  const confirmBtn = orderPage.getByText('确认开通', { exact: true }).first()
  await confirmBtn.waitFor({ timeout: 30000 })
  await confirmBtn.click()
  console.log(`[${index}] Clicked 确认开通. Renewal submitted.`)

  // After confirmation the tab redirects back to unicloud.dcloud.net.cn and
  // is no longer useful — close it and wait for the dashboard to settle.
  await orderPage.waitForTimeout(5000)
  await orderPage.close().catch(() => {})
  await dashboardPage.waitForTimeout(3000)
}

;(async () => {
  const isMac = process.platform === 'darwin'

  // Set HEADLESS=false (or omit) to watch the browser; cron jobs should run
  // headless (HEADLESS=true or just leave it — defaults to true when no TTY).
  const headless =
    process.env.HEADLESS != null
      ? process.env.HEADLESS !== 'false' && process.env.HEADLESS !== '0'
      : isMac
      ? false
      : true

  // On macOS use the installed Microsoft Edge; on Linux (and elsewhere) fall
  // back to the Chromium bundled by Playwright (run `npx playwright install chromium` once there).
  // Override by setting BROWSER_CHANNEL, e.g.
  // `BROWSER_CHANNEL=chrome` or `BROWSER_CHANNEL=`.
  const launchOptions = { headless, slowMo: headless ? 0 : 200 }
  if (process.env.BROWSER_CHANNEL != null) {
    if (process.env.BROWSER_CHANNEL)
      launchOptions.channel = process.env.BROWSER_CHANNEL
  } else if (isMac) {
    launchOptions.channel = 'msedge'
  }

  const browser = await chromium.launch(launchOptions)

  const context = await browser.newContext()
  const page = await context.newPage()
  page.setDefaultTimeout(30000)

  await page.goto('https://unicloud.dcloud.net.cn/', {
    waitUntil: 'domcontentloaded',
    timeout: 60000
  })

  console.log('\n<<<<<<<<<\n', new Date().toJSON(), 'Renew account', email)
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

  // 2. Renew every subscription that shows a "续费" button on the dashboard.
  //    After renewOne() completes, the tab is closed and the dashboard
  //    re-renders (the renewed row's 续费 button disappears), so we re-query
  //    after each iteration. We keep going until no 续费 button remains, with
  //    a safety cap to avoid an infinite loop if something goes wrong.
  const MAX_RENEWALS = 50
  let done = 0
  while (done < MAX_RENEWALS) {
    await page.waitForTimeout(1500)
    const renewBtns = page.getByText('续费', { exact: true })
    const count = await renewBtns.count()
    if (count === 0) {
      console.log(
        `No more "续费" buttons found. Renewed ${done} subscription(s).`
      )
      break
    }
    console.log(
      `Found ${count} subscription(s) still to renew. Renewing next...`
    )
    // Always pick the first remaining row. After renewal the button disappears.
    await renewOne(context, page, renewBtns.first(), done + 1)
    done++
  }

  console.log(
    new Date().toJSON(),
    `Done. ${done} subscription(s) renewed for account`,
    email,
    '\n>>>>>>>>>\n'
  )
  await browser.close()
  process.exit(0)
})()
