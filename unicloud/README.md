Preparation:

```
npm i
npx playwright install-deps
npx playwright install chromium
```

Run the script with:
`node renew.mjs 'EMAIL' 'PASSWORD'`

you can also set environment variables directly:
`HEADLESS=true UNICLOUD_EMAIL=... UNICLOUD_PASSWORD=... node renew.mjs`

or set via `.env` file.

Add to crontab to run automatically:

```
# Renew DCloud uniCloud free-tier subscriptions.
# Runs at 1:00 on the 26th of every month.
#
# (That replaces your whole crontab; use `crontab -e` to merge with existing entries.)
0 1 26 * *  source renew_all.sh >> renew.log 2>&1
```
