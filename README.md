# ai-coding-tools

收集和开发 AI 辅助编码工具，提升 AI 编码体验。

## 获取

```bash
git clone https://github.com/coderlee/ai-coding-tools.git
cd ai-coding-tools
```

## 工具总览

本项目按类型组织，各工具独立安装、互不依赖：

| 目录 | 类型 | 工具 | 一句话说明 | 安装方式 |
|------|------|------|-----------|---------|
| `skills/init-claude-md/` | Skill | init-claude-md | 初始化项目的 CLAUDE.md 和项目信息文件 | 复制到 `.claude/skills/` |
| `tools/ccstatusline/` | Tool | ccstatusline | Claude Code 状态栏一键配置 | `bash tools/ccstatusline/setup.sh` |
| `hooks/record-history.js` | Hook | record-history | 记录 Claude Code 会话历史 | 配置到 `.claude/settings.local.json` 的 hooks |

## 安装指南

### 1. Skill：init-claude-md

为项目初始化 CLAUDE.md（AI 行为契约）和项目信息文件。

**安装**：将 Skill 目录复制到目标项目的 `.claude/skills/` 下：

```bash
cp -r skills/init-claude-md/ <目标项目>/.claude/skills/
```

**使用**：在目标项目的 Claude Code 会话中输入：

```
/init-claude-md
```

详细参数和流程见 [skills/init-claude-md/README.md](skills/init-claude-md/README.md)。

### 2. Tool：ccstatusline

一键安装 ccstatusline 并配置 Claude Code 状态栏，显示模型、token 用量、上下文进度、Git 状态等信息。

**依赖**：Node.js + npm、Python 3

**安装**：

```bash
bash tools/ccstatusline/setup.sh
```

脚本会自动完成：全局安装 ccstatusline → 写入状态栏布局配置 → 启用 Claude Code statusLine。安装后重启 Claude Code 生效。

详细说明见 [tools/ccstatusline/README.md](tools/ccstatusline/README.md)。

### 3. Hook：record-history

每次 Claude Code 会话结束时自动保存会话记录到 `docs/history/`。

**安装**：

1. 复制 Hook 脚本到项目的 `.claude/hooks/`：

```bash
cp hooks/record-history.js <目标项目>/.claude/hooks/
chmod +x <目标项目>/.claude/hooks/record-history.js
```

2. 在 `.claude/settings.local.json` 中添加 hook 配置：

```json
{
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "node .claude/hooks/record-history.js"
      }
    ]
  }
}
```

3. 确保项目的 `docs/history/` 目录存在：

```bash
mkdir -p <目标项目>/docs/history
```

## 目录结构

```
ai-coding-tools/
├── skills/          # Skill 源文件（需复制到目标项目的 .claude/skills/ 使用）
├── tools/           # 独立工具（各有安装脚本）
├── hooks/           # Hook 脚本源文件（需复制到目标项目的 .claude/hooks/ 使用）
├── configs/         # 配置模板/预设（预留）
├── docs/            # 项目文档
│   ├── ai-coding-tools/   # 项目信息
│   └── history/           # 会话历史记录
└── .claude/         # 本项目的 Claude Code 运行时配置
    ├── hooks/              # Hook 安装副本
    └── skills/             # Skill 安装副本
```

**源文件 vs 安装副本**：`skills/`、`hooks/` 是源文件；`.claude/skills/`、`.claude/hooks/` 是安装到本项目的运行时副本。修改源文件后需重新复制到对应位置。
