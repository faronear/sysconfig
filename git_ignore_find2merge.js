#!/usr/bin/env node
// Cross-platform (node) port of git_ignore_find2merge.sh / .bat
//
// Search [ROOTPATH], merge [GLOBALPATH/.gitignore_global] and [ROOTPATH/<dir>/.gitignore.local.txt]
// into [ROOTPATH/<dir>/.gitignore], for every <dir> that has a .gitignore.
// (Judged from .gitignore, not from .git — some git repos keep privacy and hide .git.)
//
// usage:
//   node git_ignore_find2merge.js [rootPath] [globalPath] [y|other]
//     rootPath   start of tree search, must be a directory (default: prompt, blank = current dir)
//     globalPath path to .gitignore_global, or its parent dir, or an http(s) URL
//                (default: https://git.tic.cc/opx/sysconfig/raw/branch/main/nixhome/.gitignore_global)
//     yesNo      'y' to write, anything else = dry-run (list candidates without writing)
//
//   node git_ignore_find2merge.js                      # interactive, dry-run
//   node git_ignore_find2merge.js ~/Shared y
//   node git_ignore_find2merge.js /srv/projects /srv/proj/nixhome y
//
// Same fixes as seafile_ignore_find2merge.js:
//   - blank globalPath falls back to the default URL, as in the .sh
//   - ask() treats stdin EOF as blank, so non-interactive pipes don't hang
//   - the default global is a URL: fetched with fetch() at 30s timeout + one retry
//     (the .sh's `cat $GLOBALPATH` branch never ran for URLs — it went to the curl branch)
//   - the root dir itself is processed too (the .sh's find -name '[^.]*' never matched the root)
//   - non-'y' is a dry-run that still lists the candidate dirs (the .sh just exited silently)

const fs = require('fs')
const os = require('os')
const path = require('path')
const readline = require('readline')

const DEFAULT_GLOBAL_URL = 'https://git.tic.cc/opx/sysconfig/raw/branch/main/nixhome/.gitignore_global'
const GLOBAL_FILE_NAME = '.gitignore_global'
// same skip list as: grep -E -v 'node_modules|uni_modules|\.deploy_git|\.git|.svn|\.vscode|\.wrangler|unpackage|_webroot|_logstore|_datasotre|_archive|_filestore|_ssl'
const SKIP_DIR_PATTERN = /node_modules|uni_modules|\.deploy_git|\.git|\.svn|\.vscode|\.wrangler|unpackage|_webroot|_logstore|_datasotre|_archive|_filestore|_ssl/
const MAX_DEPTH = 3 // relative to ROOTPATH, matching find -mindepth 0 -maxdepth 3

function resolveHome (p) {
  if (p === '~') return os.homedir()
  if (p.startsWith('~/')) return path.join(os.homedir(), p.slice(2))
  return p
}

async function ask (question) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
  const answer = await new Promise(resolve => {
    let settled = false
    const finish = value => { if (!settled) { settled = true; resolve(value) } }
    rl.question(question, a => finish(a))
    rl.on('close', () => finish('')) // stdin ended without input (EOF): treat as blank, like the .sh's `read`
  })
  rl.close()
  return answer.trim()
}

// find . -mindepth 0 -maxdepth 3 -type d -name '[^.]*'  (relative paths, root itself excluded)
function collectCandidateDirs (rootPath) {
  const candidates = []
  function walk (dir, depth) {
    if (depth > MAX_DEPTH) return
    let entries
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true })
    } catch {
      return
    }
    for (const entry of entries) {
      if (!entry.isDirectory()) continue
      if (entry.name.startsWith('.')) continue // -name '[^.]*' excludes hidden dirs
      const absDir = path.join(dir, entry.name)
      const relDir = path.relative(rootPath, absDir)
      if (relDir.split(path.sep).length > MAX_DEPTH) continue
      candidates.push(relDir)
      walk(absDir, depth + 1)
    }
  }
  walk(rootPath, 1)
  return candidates
}

async function loadGlobalContent (globalPathInput) {
  const globalPath = resolveHome(globalPathInput)
  if (/^https?:\/\//i.test(globalPath)) {
    console.log('√√√ GLOBALPATH (url) = [[' + globalPath + ']]')
    // git.tic.cc's TCP connect can exceed node's default 10s connect timeout; allow 30s and retry once.
    let lastError
    for (let attempt = 1; attempt <= 2; attempt++) {
      try {
        const response = await fetch(globalPath, { signal: AbortSignal.timeout(30000) })
        if (!response.ok) throw new Error('HTTP ' + response.status)
        return await response.text()
      } catch (error) {
        lastError = error
        console.log('... fetch attempt ' + attempt + ' failed: ' + (error.cause?.code || error.message))
      }
    }
    console.log('××× Fetch failed: ' + (lastError.cause?.code || lastError.message) + ' for [[' + globalPath + ']]. Exit now...')
    process.exit(1)
  }
  let globalFile = globalPath
  if (fs.existsSync(globalPath) && fs.statSync(globalPath).isDirectory()) {
    globalFile = path.join(globalPath, GLOBAL_FILE_NAME)
  }
  if (!fs.existsSync(globalFile)) {
    console.log('××× Not found [[' + globalFile + ']]. Exit now...')
    process.exit(1)
  }
  console.log('√√√ GLOBALPATH = [[' + globalFile + ']]')
  return fs.readFileSync(globalFile, 'utf8')
}

async function main () {
  console.log('')
  console.log('Search in [ROOTPATH], merge [GLOBALPATH/.gitignore_global] and [ROOTPATH/*/.gitignore.local.txt] files to .gitignore')
  console.log('')

  // --- ROOTPATH ---
  let rootPath = process.argv[2]
  const rootIsDir = p => {
    try { return fs.statSync(p).isDirectory() } catch { return false }
  }
  if (!(rootPath && rootIsDir(resolveHome(rootPath)))) {
    console.log('::*** Enter [root path] or [leave blank] for default [[' + process.cwd() + ']] to start tree search for git repositories')
    rootPath = await ask('***:: ')
    if (!rootPath) rootPath = process.cwd()
    rootPath = path.resolve(resolveHome(rootPath))
  } else {
    rootPath = path.resolve(resolveHome(rootPath))
  }
  if (!rootIsDir(rootPath)) {
    console.log('××× [[' + rootPath + ']] not exist! Exit now. ***')
    process.exit(1)
  }
  console.log('√√√ ROOTPATH = [[' + rootPath + ']]')
  console.log('')

  // --- GLOBALPATH ---
  let globalPathInput = process.argv[3]
  if (!globalPathInput) {
    console.log('::*** Enter [path to .gitignore_global] or [leave blank] for default [[' + DEFAULT_GLOBAL_URL + ']]')
    globalPathInput = await ask('***:: ')
    if (!globalPathInput) globalPathInput = DEFAULT_GLOBAL_URL // blank → default URL, as in the .sh
  }
  const globalContent = await loadGlobalContent(globalPathInput)
  console.log('')

  // --- y/N ---
  let yesNo = process.argv[4]
  if (!yesNo) {
    console.log('::*** Enter [y] to start updating, or [anything else] for dry-run')
    yesNo = await ask('***:: ')
  }
  const willWrite = yesNo === 'y'

  console.log('*** Starting from [[' + rootPath + ']] ***')
  console.log('')

  // --- search + merge ---
  // A dir is a candidate iff it has a .gitignore (judged from .gitignore, not from .git).
  const candidateDirs = collectCandidateDirs(rootPath).sort()
  // The root dir itself is also a candidate: the old .sh's find -name '[^.]*' never matched the root.
  if (fs.existsSync(path.join(rootPath, '.gitignore'))) candidateDirs.unshift('.')

  let updatedCount = 0
  for (const relDir of candidateDirs) {
    const absDir = relDir === '.' ? rootPath : path.join(rootPath, relDir)
    if (relDir !== '.' && SKIP_DIR_PATTERN.test(relDir)) continue
    const targetFile = path.join(absDir, '.gitignore')
    const localFile = path.join(absDir, '.gitignore.local.txt')
    if (!fs.existsSync(targetFile)) continue
    console.log('---- updating [[' + relDir + '/.gitignore]] ----')
    if (willWrite) {
      let merged = globalContent
      if (fs.existsSync(localFile)) merged += fs.readFileSync(localFile, 'utf8')
      fs.writeFileSync(targetFile, merged)
      updatedCount++
    }
    console.log('')
  }
  if (willWrite) {
    console.log('*** done: ' + updatedCount + ' file(s) updated ***')
  } else {
    console.log('*** dry-run: no file written (enter y to update) ***')
  }
}

main().catch(err => {
  console.error(err)
  process.exit(1)
})
