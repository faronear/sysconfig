#!/usr/bin/env node
// Cross-platform (node) port of seafile_ignore_find2merge.sh / .bat
//
// Search [ROOTPATH], merge [GLOBALPATH/seafile-ignore.global.txt] and [ROOTPATH/<dir>/seafile-ignore.local.txt]
// into [ROOTPATH/<dir>/seafile-ignore.txt], for every <dir> that has a seafile-ignore.txt OR a seafile-ignore.local.txt.
// (Unlike git_ignore_find2merge, a .git dir is NOT a trigger — seafile ignore rules are independent of git.)
//
// usage:
//   node seafile_ignore_find2merge.js [rootPath] [globalPath] [y|other]
//     rootPath   start of tree search (default: current dir)
//     globalPath path to seafile-ignore.global.txt, or its parent dir, or an http(s) URL
//                (default: https://git.tic.cc/opx/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt)
//     yesNo      'y' to write, anything else = dry-run (default: dry-run)
//
//   node seafile_ignore_find2merge.js                       # dry-run from cwd
//   node seafile_ignore_find2merge.js ~/Shared y
//   node seafile_ignore_find2merge.js /srv/projects /srv/proj/seafile-ignore.global.txt y
//
// Semantics ported from the .sh (two .sh gaps fixed):
//   - the root dir itself is processed too (the .sh's find -name '[^.]*' never matched the root dir)
//   - a dir is updated iff it has seafile-ignore.txt OR seafile-ignore.local.txt (the .sh's `.git` check was dropped)
//   - tree search is max depth 3, skipping hidden dirs and the known build/dep dirs
//   - the .sh does `cat $GLOBALPATH` which fails when the default is a URL; here http(s) is fetched with fetch(),
//     a local file / parent-dir keeps the original behavior.

const fs = require('fs')
const os = require('os')
const path = require('path')
const readline = require('readline')

const DEFAULT_GLOBAL_URL = 'https://git.tic.cc/opx/sysconfig/raw/branch/main/nixhome/seafile-ignore.global.txt'
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
  const answer = await new Promise(resolve => rl.question(question, resolve))
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
    const response = await fetch(globalPath)
    if (!response.ok) {
      console.log('××× Fetch failed: HTTP ' + response.status + ' for [[' + globalPath + ']]. Exit now...')
      process.exit(1)
    }
    return response.text()
  }
  let globalFile = globalPath
  if (fs.existsSync(globalPath) && fs.statSync(globalPath).isDirectory()) {
    globalFile = path.join(globalPath, 'seafile-ignore.global.txt')
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
  console.log('Search in [ROOTPATH], Merge [GLOBALPATH/seafile-ignore.global.txt] and [ROOTPATH/*/seafile-ignore.local.txt] files to [seafile-ignore.txt]')
  console.log('')

  // --- ROOTPATH ---
  let rootPath = process.argv[2]
  if (!rootPath) {
    console.log('::*** Enter [root path] or [leave blank] for default [[' + process.cwd() + ']] to start tree search for seafile-ignore.txt files')
    rootPath = await ask('***:: ')
  }
  if (rootPath) rootPath = path.resolve(resolveHome(rootPath))
  else rootPath = process.cwd()
  if (!fs.existsSync(rootPath) || !fs.statSync(rootPath).isDirectory()) {
    console.log('××× [[' + rootPath + ']] not exist! Exit now. ***')
    process.exit(1)
  }
  console.log('√√√ ROOTPATH = [[' + rootPath + ']]')
  console.log('')

  // --- GLOBALPATH ---
  let globalPathInput = process.argv[3]
  if (!globalPathInput) {
    console.log('::*** Enter [path to seafile-ignore.global.txt] or [leave blank] for default [[' + DEFAULT_GLOBAL_URL + ']]')
    globalPathInput = await ask('***:: ')
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
  // The root dir itself is also a candidate: the old .sh's find -name '[^.]*' never matched the root,
  // so ROOTPATH's own seafile-ignore.txt was never updated — fixed here (and in the .sh).
  const candidateDirs = collectCandidateDirs(rootPath).sort()
  if (
    fs.existsSync(path.join(rootPath, 'seafile-ignore.txt')) ||
    fs.existsSync(path.join(rootPath, 'seafile-ignore.local.txt'))
  ) candidateDirs.unshift('.')

  let updatedCount = 0
  for (const relDir of candidateDirs) {
    const absDir = relDir === '.' ? rootPath : path.join(rootPath, relDir)
    if (relDir !== '.' && SKIP_DIR_PATTERN.test(relDir)) continue
    const ignoreFile = path.join(absDir, 'seafile-ignore.txt')
    const localFile = path.join(absDir, 'seafile-ignore.local.txt')
    if (!fs.existsSync(ignoreFile) && !fs.existsSync(localFile)) continue
    console.log('---- updating [[' + relDir + '/seafile-ignore.txt]] ----')
    if (willWrite) {
      let merged = globalContent
      if (fs.existsSync(localFile)) merged += fs.readFileSync(localFile, 'utf8')
      fs.writeFileSync(ignoreFile, merged)
      updatedCount++
    }
    console.log('')
  }
  if (willWrite) console.log('*** done: ' + updatedCount + ' file(s) updated ***')
}

main().catch(err => {
  console.error(err)
  process.exit(1)
})
