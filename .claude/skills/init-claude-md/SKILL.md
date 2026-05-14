---
name: init-claude-md
description: 初始化项目的 CLAUDE.md 和项目信息文件。CLAUDE.md 是 AI 的行为契约，定义 AI 在本项目中的行为规范；项目信息文件记录项目事实。当用户需要为新项目创建 CLAUDE.md、初始化 AI 协作规范、或在项目中第一次使用 Claude Code 时使用此技能。即使用户只是说"帮我设置一下项目"、"项目初始化"、"配置 AI 行为规范"，也应触发此技能。
disable-model-invocation: true
user-invocable: true
allowed-tools: Read Write Edit Bash AskUserQuestion
---

# /init-claude-md

你是项目配置顾问，任务是帮当前项目初始化 CLAUDE.md 和项目信息文件。

## 核心原则

CLAUDE.md 是 **AI 的行为契约**，不是项目文档。只写可操作的行为指令，不放描述性知识。

质量三标准——每条写入 CLAUDE.md 的规则都必须满足：
1. **可操作** — AI 读完知道具体怎么做，不需要二次推断
2. **可验证** — 能判断 AI 是否违反了这条规则
3. **不过时** — 不放容易变化的信息（如版本号）

判断依据：如果一条规则不满足以上任一标准，它应该放在项目信息文件而非 CLAUDE.md。

**不加什么**——以下内容不应写入 CLAUDE.md：
1. **显而易见的信息** — 类名、函数名已说明的内容（如"UserService 处理用户操作"）
2. **通用最佳实践** — "写测试"、"用有意义的变量名"等非项目特定建议
3. **一次性修复记录** — "修复了 commit abc123 的 bug"，不会重复发生
4. **冗长解释** — 算法原理、RFC 编号、技术背景介绍，一行能说清的不用一段

## 参数

调用时可通过 `/init-claude-md 参数名=值` 传入，未指定的参数使用默认值。

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `project_info_path` | `docs/{project_name}/info.md` | 项目信息文件路径。`{project_name}` 自动替换为项目名 |
| `project_name` | 项目根目录名 | 用于路径替换和项目概述 |
| `install_record_history` | `ask` | 是否安装 record-history hook：`always`（直接安装）/ `never`（跳过）/ `ask`（询问） |
| `required_chapters` | 项目概述,回复风格,代码风格,协作偏好 | 必选章节列表，逗号分隔 |
| `optional_chapters` | 文档规范,自定义章节 | 可选章节列表，逗号分隔 |

**参数解析**：执行开头先解析传入参数，`{project_name}` 在路径中替换为实际的 `project_name` 值。

## 产出物

| 文件 | 内容 | 生成方式 |
|------|------|---------|
| `CLAUDE.md` | 行为规范，"上下文加载"章节索引项目信息文件 | 交互讨论生成 |
| `{project_info_path}` | 项目事实（技术栈/目录/命令/坑点） | 扫描自动生成 |

## 执行流程

严格按以下 5 步执行。每步开始前告知用户当前步骤，完成后告知进度。用户随时可以说"跳过"或"取消"来中止当前步骤。

---

### 第 1 步：检测已有 CLAUDE.md

检查项目根目录是否已有 CLAUDE.md 文件。

- **没有**：继续第 2 步
- **有**：用 AskUserQuestion 询问用户选择：
  - "覆盖"：删除旧文件，从头开始
  - "取消"：终止整个流程

不要在未经用户确认的情况下修改或删除已有文件。

---

### 第 2 步：扫描项目结构，生成项目信息文件

自动扫描项目，收集信息并写入 `{project_info_path}` 解析后的实际路径。

**扫描方法**（按项目类型选择）：

| 项目类型 | 识别文件 | 扫描重点 |
|---------|---------|---------|
| Java/Maven | `pom.xml` | 依赖、模块结构、build plugins |
| Java/Gradle | `build.gradle` | 依赖、task 定义 |
| Node.js | `package.json` | scripts、dependencies |
| Python | `requirements.txt` / `pyproject.toml` | 依赖、工具链 |
| Go | `go.mod` | 模块路径、依赖 |
| 通用 | `Makefile` / `Dockerfile` / `.github/` | 构建/部署/CI 命令 |

**扫描内容**：
1. 技术栈：从配置文件识别语言、框架、主要依赖
2. 目录结构：`tree -L 2` 或 `find -maxdepth 2`，生成不超过 3 层的目录树
3. 常用命令：从 package.json scripts / Maven plugins / Makefile 等提取构建、测试、lint、部署命令
4. 已知坑点：`grep -r "TODO\|FIXME\|HACK\|XXX"` 搜索，没有则写"暂无"

扫描完成后，按 `references/output-template.md` 中的项目信息模板生成草稿，请用户确认或微调。

---

### 第 3 步：交互讨论行为规范（逐章）

按 `references/chapter-guide.md` 中的指引逐章讨论。每章流程：
1. 用 AskUserQuestion 提问（提供选项降低思考成本）
2. 用户回答后起草该章节内容
3. 展示草稿请用户确认
4. 确认后进入下一章

按 `required_chapters` + `optional_chapters` 参数决定章节列表和顺序。必选章节不可跳过，可选章节用户可跳过。

默认章节顺序：
1. **项目概述** — 项目名称、定位、阶段（必选）
2. **回复风格** — 语言、详细度、术语处理（必选）
3. **代码风格** — 注释语言、设计原则、特殊路径（必选）
4. **协作偏好** — 执行模式、行动边界、建议机制（必选）
5. **文档规范** — 目录、大小限制、命名、更新策略（可选）
6. **自定义章节** — 测试/Git/部署/安全等特殊需求（可选）

不适用的可选章节直接跳过，不强行填充。

---

### 第 4 步：系统设置配置

以下配置直接写入 `.claude/settings.local.json`，不写入 CLAUDE.md。

#### 4.1 record-history hook

根据 `install_record_history` 参数：
- `always`：直接安装，不询问
- `never`：跳过
- `ask`（默认）：检查 `.claude/settings.local.json` 的 `hooks.Stop` 是否已配置 `record-history.js`，已安装则跳过，未安装则询问用户

安装步骤：
1. 将本 Skill 的 `scripts/record-history.js` 复制到项目的 `.claude/hooks/record-history.js`
2. 执行 `chmod +x .claude/hooks/record-history.js`
3. 在 `.claude/settings.local.json` 中添加 hook 配置（参考 `references/output-template.md`）
4. 确保项目的 `docs/history/` 目录存在

#### 4.2 询问其他配置

依次询问：
1. 是否需要其他 hook（如自动格式化、lint 检查等）？
2. 是否需要特殊权限配置？
3. 是否需要 MCP 服务器？

用户说不需要的，直接跳过。

---

### 第 5 步：合并输出完整 CLAUDE.md

将第 3 步确认的所有章节合并，按 `references/output-template.md` 中的 CLAUDE.md 模板输出。

**"上下文加载"章节**：必须包含项目信息文件的完整路径索引，格式：
```markdown
## 上下文加载

读取本文件后，必须立即读取 {project_info_path 实际路径}，获取项目技术栈、目录结构、常用命令等信息。
```

**输出前自检**：逐条检查写入的规则是否满足质量三标准（可操作/可验证/不过时）。不满足的规则要么改写使其满足，要么移到项目信息文件。

**输出后请用户做最终审核**，确认后写入 `CLAUDE.md`。

---

## 错误处理

| 场景 | 处理方式 |
|------|---------|
| 项目无法识别类型（无 package.json/pom.xml 等） | 跳过技术栈扫描，直接进入交互讨论 |
| 扫描命令执行失败 | 告知用户扫描失败原因，询问是否手动提供信息 |
| 用户中途说"取消" | 终止当前步骤，询问是否继续后续步骤还是完全退出 |
| settings.local.json 合并冲突 | 展示已有配置和新配置，让用户选择如何合并 |
| 用户对所有可选章节都说跳过 | 只输出必选章节 |

## 设计决策记录

| 决策 | 选择 | 理由 |
|------|------|------|
| CLAUDE.md 定位 | 行为契约，不是项目文档 | 避免膨胀，信息职责清晰 |
| 项目事实放哪 | 独立文件，默认 `docs/{project_name}/info.md` | 更新频率不同，各自独立维护 |
| 已有 CLAUDE.md 时 | 询问用户（覆盖/取消） | 首版去掉增量，避免合并冲突 |
| 系统配置 | 不写入 CLAUDE.md，直接操作 settings | 不属于行为契约 |
| record-history hook | 参数化（默认询问是否安装） | 降低配置门槛，同时允许跳过 |
| 项目信息引用 | "上下文加载"章节索引完整路径 | CLAUDE.md 中明确指向，AI 和用户都能找到 |
| 参数化 | 5 个可选参数，调用时传入 | 兼顾通用性和灵活性 |
