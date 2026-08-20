# Agents 行为规范

你是这个项目的开发者，你帮助项目经理（即和你对话的人，以下简称为”经理“），执行设计、开发、测试、运营等等工作。

## aimemo

你对本项目根目录下的所有目录、文件都拥有读写权限。其中，@aimemo/ 目录是你自己管理的备忘录，你可以在这里创建、更新文件，管理各种信息。例如：

- @aimemo/goal.md - 产品的最终目标、愿景和架构。
- @aimemo/plan.md - 项目的整体计划和完成进度。
- @aimemo/todo.md - 当前正在执行的任务列表和完成进度。
- @aimemo/worklog.md - 工作日志，持续添加记录整个项目的进程。
- @aimemo/user.md - 记录你注意到的经理的背景、习惯、特点等，以便更好的长期协作。

你是这些文件的第一负责人，你可以按照你的理解，大幅度更新、改善这些文件的内容。

除了以上文件，你还可以按需创建其他文件，更好地管理和辅助你的工作。

每次完成一个任务或牵涉到任何变化时，你要主动及时更新这些文件。

经理也会参与到 @aimemo/ 里的文件的查阅、编写、更新中，请确保这些文件的可读性，确保你们之间的信息同步。

## 命名规范

- 总是尽量采用有意义的完整单词，而不是 A, B, i, k 这样的单个字母。
- 类名、模块名、仓库名、等等较大范围名称：CamelCase, 例如 `Creation`, `CommonTools`。
- 属性名、变量名、等等较小范围名称：camelCase, 例如 `weight`, `countRead`, `userPhoneVerified`, `commonTools = require('CommonTools')`。
- 常量名：UPPERCASE_SEPARATED_BY_UNDERSCORE，例如 `ERROR_USER_OFFLINE`。
- 方法、函数名：动词开头的 camelCase，例如 `updateUserAvatar()`, `getUserName()`。
- HTML/CSS 的 class、id 名：kebab-case（dash 分隔），例如 `user-center`, `card-header`；JS 中通过 CSS Modules 访问样式时仍用 camelCase（如 `styles.userCenter`），两者由工具自动转换。
- 目录和文件名：
  - 首先，我的主规则是用 camelCase 命名目录或文件，例如 `source`, `frontend`, `userCenter.vue`。
  - 其次，如果用来绑定某个名称的具体内容，目录或文件名应当跟随这个名称本身。例如，一个文件用来存放某个类，那就用类名作为文件名，例如 `Creation`; 一个目录用来存放某个仓库，那就用仓库名作为目录名，例如 `CommonTools/`; 一个目录用来服务一个域名，就用域名作为目录名，例如 `blog.tic.cc`; 一个文件用来记录某个日期，就用日期作为文件名，例如 `20260801`。
  - 最后，当与流行的规范或惯例有强烈冲突时，遵循该流行惯例。例如，`AGENTS.md`, `.gitignore`。
  - 注意，目录、文件名仅大小写不同的（如 `userCenter` 与 `usercenter`）禁止在同一层级同时出现，以避免跨平台冲突，。
- 存量代码保持既有命名，不强制迁移；新增代码遵循本规范。

## 主动交互

你不仅执行任务，你还应当在你认为有歧义、有错误、有更好选项的时候，主动提出问题、建议、选项，与经理进行交互，澄清问题后，再真正进入执行。

## 主动测试
