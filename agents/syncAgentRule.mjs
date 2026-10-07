// 功能：从 https://git.tic.cc/opx/sysconfig/ 同步 agents/AGENTS.md 和 agents/CLAUDE.md
// 到本项目根目录（覆盖现有文件）；并在当前目录初始化 aimemo/ 工作记忆目录，
// 按 AGENTS.md 约定创建缺失的 productLens.md / projectPlan.md / worklog.md / userProfile.md（空白文件），已存在的保持不动。
// 使用 Node 内置 fetch，跨 Windows / Linux / macOS 平台，无需额外工具。

// 调用：在 package.json 的 scripts 里添加 "syncAgentRule": "node -e \"fetch('https://git.tic.cc/opx/sysconfig/raw/branch/main/agents/syncAgentRule.mjs').then(r=>{if(!r.ok)throw new Error('HTTP '+r.status);return r.text()}).then(async t=>{await import('data:text/javascript;base64,'+Buffer.from(t).toString('base64'))})\""
import { writeFile, mkdir, access } from 'node:fs/promises';

const BASE_URL = 'https://git.tic.cc/opx/sysconfig/raw/branch/main/agents/';
const FILES = ['AGENTS.md', 'CLAUDE.md'];

// aimemo 工作记忆目录：按 AGENTS.md 约定初始化，仅在调用时的工作目录（process.cwd()）下创建缺失文件，已存在的一律沿用
const AIMEMO_DIR = 'aimemo';
const AIMEMO_FILES = ['productLens.md', 'projectPlan.md', 'worklog.md', 'userProfile.md'];

for (const name of FILES) {
  const response = await fetch(BASE_URL + name);
  if (!response.ok) {
    throw new Error(`下载 ${name} 失败: HTTP ${response.status}`);
  }
  await writeFile(name, await response.text());
  console.log(`已同步 ${name}`);
}

console.log('agents 文件同步完成');

// 初始化 aimemo/（相对路径解析到调用时的工作目录，即 process.cwd()）
await mkdir(AIMEMO_DIR, { recursive: true });
for (const name of AIMEMO_FILES) {
  const filePath = `${AIMEMO_DIR}/${name}`;
  try {
    await access(filePath);
    console.log(`已存在，沿用 ${filePath}`);
  } catch {
    await writeFile(filePath, '');
    console.log(`已创建 ${filePath}`);
  }
}
console.log('aimemo 目录初始化完成');
