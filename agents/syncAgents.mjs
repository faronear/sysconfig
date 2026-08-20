// 从 https://git.tic.cc/opx/sysconfig/ 同步 agents/AGENTS.md 和 agents/CLAUDE.md
// 到本项目根目录（覆盖现有文件）。
// 使用 Node 内置 fetch，跨 Windows / Linux / macOS 平台，无需额外工具。
import { writeFile } from 'node:fs/promises';

const BASE_URL = 'https://git.tic.cc/opx/sysconfig/raw/branch/main/agents/';
const FILES = ['AGENTS.md', 'CLAUDE.md'];

for (const name of FILES) {
  const response = await fetch(BASE_URL + name);
  if (!response.ok) {
    throw new Error(`下载 ${name} 失败: HTTP ${response.status}`);
  }
  await writeFile(name, await response.text());
  console.log(`已同步 ${name}`);
}

console.log('agents 文件同步完成');
