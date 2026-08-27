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

// Match on the real page PATH, not a bare substring. The uni-trade SSO login
// page URL contains `uniIdRedirectUrl=...create-order...` (URL-encoded) in its
// query string, so `u.includes('create-order')` wrongly matches the login page
// and the script would click 立即购买 before the redirect to the real order
// page has finished — causing "Timed out waiting for URL condition".
const ORDER_PATH = '/uni_modules/uni-trade/pages/create-order/create-order'
const PAYMENT_PATH = '/uni_modules/uni-trade/pages/order-payment/order-payment'
const isOrderPage = u => u.includes(ORDER_PATH)
const isPaymentPage = u => u.includes(PAYMENT_PATH)
const isDashboard = u => u.startsWith('https://unicloud.dcloud.net.cn')

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

// Wait until any of the named predicates matches. Resolves with the matching
// name, or null on timeout. Predicates are checked in insertion order.
async function waitForUrlAny (page, predicates, timeoutMs = 30000) {
  const start = Date.now()
  while (Date.now() - start < timeoutMs) {
    const u = page.url()
    for (const [name, pred] of Object.entries(predicates)) {
      if (pred(u)) return name
    }
    await page.waitForTimeout(500)
  }
  return null
}

// Click "立即购买" and wait for the payment page. The first click can be a
// no-op (page still initialising, a resource 403'd, etc.), so retry a few
// times. Also accepts landing back on the dashboard as "order already
// completed without a payment step".
async function clickBuyAndWait (orderPage, index, attempts = 3) {
  for (let i = 1; i <= attempts; i++) {
    const buyBtn = orderPage.getByText('立即购买', { exact: true }).first()
    await buyBtn.waitFor({ timeout: 30000 })
    await buyBtn.click()
    console.log(`[${index}] Clicked 立即购买 (attempt ${i}/${attempts})`)
    const landed = await waitForUrlAny(
      orderPage,
      { payment: isPaymentPage, dashboard: isDashboard },
      25000
    )
    if (landed) return landed
    console.log(
      `[${index}] Payment page not reached, current URL: ${orderPage.url()}`
    )
    await orderPage.waitForTimeout(3000)
  }
  throw new Error(`Timed out waiting for payment page. Current: ${orderPage.url()}`)
}

// Run the purchase flow for a single "续费" button that has already been
// located on the dashboard. Resolves once the renewal is submitted and the
// browser has returned to the dashboard (so the caller can re-query rows).
async function renewOne (context, dashboardPage, renewLocator, index) {
  // Clicking 续费 opens a NEW TAB that first goes through SSO login, then
  // lands on the uni-trade create-order page.
  const newPagePromise = new Promise((resolve, reject) => {
    const timer = setTimeout(
      () => reject(new Error('No new tab opened after clicking 续费')),
      30000
    )
    context.once('page', p => {
      clearTimeout(timer)
      resolve(p)
    })
  })
  await renewLocator.click()
  const orderPage = await newPagePromise
  orderPage.setDefaultTimeout(30000)

  // Useful diagnostics: any JS errors / dialogs / navigations on the order tab.
  orderPage.on('console', msg => {
    if (msg.type() === 'error')
      console.log(`  [console.error] ${msg.text()}`)
  })
  orderPage.on('dialog', d => {
    console.log(`  [dialog ${d.type()}] ${d.message()}`)
    d.accept().catch(() => {})
  })

  // Wait for the OAuth redirect to settle on the REAL create-order page, then
  // give the page a moment to finish initialising.
  await waitForUrl(orderPage, isOrderPage, 60000)
  await orderPage.waitForTimeout(4000)
  console.log(`[${index}] Order page ready:`, orderPage.url())

  // Click "立即购买" — same tab navigates to /order-payment.
  const landed = await clickBuyAndWait(orderPage, index)
  if (landed === 'dashboard') {
    console.log(`[${index}] Order completed without a payment page.`)
    await orderPage.close().catch(() => {})
    return
  }
  await orderPage.waitForTimeout(3000)
  console.log(`[${index}] Payment page ready:`, orderPage.url())

  // Click "确认开通" to finalize.
  const confirmBtn = orderPage.getByText('确认开通', { exact: true }).first()
  await confirmBtn.waitFor({ timeout: 30000 })
  await confirmBtn.click()
  console.log(`[${index}] Clicked 确认开通. Renewal submitted.`)

  // After confirmation the tab redirects back to unicloud.dcloud.net.cn.
  // Don't fail the renewal if the redirect is not observed — the order may
  // already be submitted.
  try {
    await waitForUrl(orderPage, isDashboard, 30000)
  } catch (e) {
    console.log(`[${index}] No dashboard redirect observed: ${orderPage.url()}`)
  }
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
  //    After renewOne() completes, the tab is closed and the dashboard is
  //    reloaded so the renewed row's 续费 button disappears and the list is
  //    fresh (avoids acting on a stale row). We keep going until no 续费
  //    button remains, with a safety cap and a consecutive-failure limit so a
  //    single broken row doesn't abort the whole account or loop forever.
  const MAX_RENEWALS = 50
  const MAX_CONSECUTIVE_FAILURES = 3
  let done = 0
  let consecutiveFailures = 0
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
    try {
      // Always pick the first remaining row. After renewal the button disappears.
      await renewOne(context, page, renewBtns.first(), done + 1)
      consecutiveFailures = 0
      done++
    } catch (err) {
      consecutiveFailures++
      console.error(`[${done + 1}] Renewal FAILED: ${err.message}`)
      // Close any stray tabs left open by the failed attempt.
      for (const p of context.pages()) {
        if (p !== page) await p.close().catch(() => {})
      }
      if (consecutiveFailures >= MAX_CONSECUTIVE_FAILURES) {
        console.error(
          `${consecutiveFailures} consecutive failures, giving up on this account.`
        )
        break
      }
    }
    // Reload the dashboard for a clean, fresh view before the next iteration.
    await page
      .reload({ waitUntil: 'domcontentloaded', timeout: 60000 })
      .catch(() => {})
    await page.waitForTimeout(5000)
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
