# init-claude-md

初始化项目的 CLAUDE.md 和项目信息文件。CLAUDE.md 是 AI 的行为契约，定义 AI 在本项目中的行为规范；项目信息文件记录项目事实。

## 安装

将本目录复制到目标项目的 `.claude/skills/` 下：

```bash
cp -r skills/init-claude-md/ <目标项目>/.claude/skills/
```

复制后目录结构应为：

```
<目标项目>/.claude/skills/init-claude-md/
├── SKILL.md            # Skill 定义（Claude Code 自动读取）
├── scripts/            # 辅助脚本
│   └── record-history.js
├── references/         # 模板和指引
│   ├── chapter-guide.md
│   └── output-template.md
└── evals/              # 评估配置
    └── evals.json
```

## 使用

在目标项目的 Claude Code 会话中输入：

```
/init-claude-md
```

### 参数

```
/init-claude-md project_name=my-project install_record_history=always
```

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `project_info_path` | `docs/{project_name}/info.md` | 项目信息文件路径，`{project_name}` 自动替换 |
| `project_name` | 项目根目录名 | 用于路径替换和项目概述 |
| `install_record_history` | `ask` | 是否安装 record-history hook：`always`（直接安装）/ `never`（跳过）/ `ask`（询问） |
| `required_chapters` | 项目概述,回复风格,代码风格,协作偏好 | 必选章节，逗号分隔 |
| `optional_chapters` | 文档规范,自定义章节 | 可选章节，逗号分隔 |

## 执行流程

1. **检测已有 CLAUDE.md** — 有则询问覆盖或取消
2. **扫描项目结构** — 自动识别技术栈、目录、命令、已知坑点，生成项目信息文件
3. **交互讨论行为规范** — 逐章讨论（必选章节不可跳过，可选可跳过）
4. **系统设置配置** — 可选安装 record-history hook、其他 hook、权限、MCP
5. **合并输出 CLAUDE.md** — 自检质量三标准（可操作/可验证/不过时），用户最终审核

## 产出物

| 文件 | 内容 | 生成方式 |
|------|------|---------|
| `CLAUDE.md` | AI 行为规范，含"上下文加载"章节索引项目信息文件 | 交互讨论生成 |
| `docs/{project_name}/info.md` | 项目事实（技术栈/目录/命令/坑点） | 扫描自动生成 |
