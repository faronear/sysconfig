#!/usr/bin/env node

const fs = require('fs')
const os = require('os')
const path = require('path')
const readline = require('readline')

async function askQuestion (rl, prompt, defaultValue = '') {
  const suffix = defaultValue ? ` [${defaultValue}]` : ''
  const answer = await new Promise(resolve => {
    rl.question(`${prompt}${suffix}>> `, value => resolve(value))
  })

  const trimmed = answer.trim()
  return trimmed || defaultValue || ''
}

function readJsonIfExists (filePath) {
  if (!fs.existsSync(filePath)) {
    return null
  }

  try {
    const content = fs.readFileSync(filePath, 'utf8')
    return JSON.parse(content)
  } catch (error) {
    // fall through to JS parsing below
  }

  try {
    const content = fs.readFileSync(filePath, 'utf8')
    const normalized = content
      .replace(/module\.exports\s*=\s*/, 'return ')
      .replace(/export\s+default\s*/, 'return ')
      .replace(/export\s+const\s+(\w+)\s*=\s*/, 'const $1 = ')
      .replace(/export\s+let\s+(\w+)\s*=\s*/, 'let $1 = ')
      .replace(/export\s+function\s+(\w+)\s*\(/, 'function $1(')

    const wrapper = new Function(`return (function(){${normalized}})()`)
    return wrapper()
  } catch (error) {
    return null
  }
}

function writeJson (filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true })
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`, 'utf8')
}

function resolveValue (source, fallbackPaths) {
  for (const candidate of fallbackPaths) {
    if (!candidate) {
      continue
    }

    const parts = candidate.split('.')
    let current = source
    let found = true

    for (const part of parts) {
      if (
        current === null ||
        current === undefined ||
        typeof current !== 'object' ||
        !(part in current)
      ) {
        found = false
        break
      }
      current = current[part]
    }

    if (found && current !== undefined && current !== null && current !== '') {
      return current
    }
  }

  return ''
}

async function main () {
  const settingsFile = path.join(os.homedir(), '.claude', 'settings.json')
  const claudeFile = path.join(os.homedir(), '.claude.json')

  const existingSettings = readJsonIfExists(settingsFile) || {}
  const existingEnv = existingSettings.env || {}

  const existingAuthToken = existingEnv.ANTHROPIC_AUTH_TOKEN || ''
  const existingBaseUrl = existingEnv.ANTHROPIC_BASE_URL || ''
  const existingModel = existingEnv.ANTHROPIC_MODEL || 'glm-5.3'

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  })

  console.log(
    'Please \n - enter a [file path] to load secret values from a file, \n - or [leave blank] to enter values directly.'
  )

  const filePath = (await askQuestion(rl, '', '')).trim()

  let authToken = existingAuthToken
  let baseUrl = existingBaseUrl
  let model = existingModel

  if (filePath) {
    const secret = readJsonIfExists(filePath)
    if (!secret || typeof secret !== 'object' || Array.isArray(secret)) {
      rl.close()
      console.error(
        'The selected file did not contain a JSON or JavaScript object.'
      )
      process.exit(1)
    }

    const keys = Object.keys(secret)
    let selectedSecret = secret

    if (keys.length > 0) {
      console.log('Available keys:')
      keys.forEach((key, index) => console.log(`${index + 1}. ${key}`))
      const chosenKey = (
        await askQuestion(rl, 'Choose a configuration from the file', '')
      ).trim()

      if (chosenKey) {
        const numericChoice = Number(chosenKey)
        if (
          !Number.isNaN(numericChoice) &&
          numericChoice >= 1 &&
          numericChoice <= keys.length
        ) {
          selectedSecret = secret[keys[numericChoice - 1]]
        } else {
          selectedSecret = secret[chosenKey]
        }
      }
    }

    if (
      !selectedSecret ||
      typeof selectedSecret !== 'object' ||
      Array.isArray(selectedSecret)
    ) {
      rl.close()
      console.error('The selected key did not contain an object.')
      process.exit(1)
    }

    authToken =
      resolveValue(selectedSecret, [
        'apikey',
        'apiKey',
        'authToken',
        'token'
      ]) || existingAuthToken
    baseUrl =
      resolveValue(selectedSecret, [
        'url.anthropic',
        'url.anthropic.baseUrl',
        'baseUrl',
        'url'
      ]) || existingBaseUrl
    model = resolveValue(selectedSecret, ['model']) || existingModel

    if (!authToken) {
      console.log('Auth token was not found in the selected file.')
      authToken = await askQuestion(
        rl,
        'ANTHROPIC_AUTH_TOKEN',
        existingAuthToken
      )
    }

    if (!baseUrl) {
      console.log('Base URL was not found in the selected file.')
      baseUrl = await askQuestion(rl, 'ANTHROPIC_BASE_URL', existingBaseUrl)
    }

    if (!model) {
      console.log('Model was not found in the selected file.')
      model = await askQuestion(rl, 'ANTHROPIC_MODEL', existingModel)
    }

    console.log('Loaded values from the selected file or original:')
    console.log(`  Auth Token: ${authToken}`)
    console.log(`  Base URL: ${baseUrl}`)
    console.log(`  Model: ${model}`)
  } else {
    console.log('\nPlease provide your Anthropic configuration.')
    authToken = await askQuestion(rl, 'ANTHROPIC_AUTH_TOKEN', existingAuthToken)
    baseUrl = await askQuestion(rl, 'ANTHROPIC_BASE_URL', existingBaseUrl)
    model = await askQuestion(rl, 'ANTHROPIC_MODEL', existingModel)
  }

  rl.close()

  if (!authToken || !baseUrl || !model) {
    console.error(
      'Missing required values. Please re-run the script and provide all fields.'
    )
    process.exit(1)
  }

  const nextSettings = {
    ...existingSettings,
    env: {
      ...existingSettings.env,
      ANTHROPIC_AUTH_TOKEN: authToken,
      ANTHROPIC_BASE_URL: baseUrl,
      ANTHROPIC_MODEL: model
    }
  }

  writeJson(settingsFile, nextSettings)

  const nextClaudeConfig = {
    hasCompletedOnboarding: true
  }

  writeJson(claudeFile, nextClaudeConfig)

  console.log(`\nUpdated ${settingsFile}`)
  console.log(`Updated ${claudeFile}`)
}

main().catch(error => {
  console.error(error.message)
  process.exit(1)
})
