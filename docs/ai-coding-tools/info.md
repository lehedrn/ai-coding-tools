# 项目信息

## 技术栈

- 语言：Bash 脚本、JavaScript (Node.js)
- 运行环境：Linux / WSL2
- 工具链：Node.js + npm（ccstatusline 依赖）

## 目录结构

```
ai-coding-tools/
├── .claude/                  # Claude Code 运行时配置
│   ├── settings.local.json   # 本地权限配置
│   ├── hooks/                # Hook 安装副本
│   └── skills/               # Skill 安装副本
├── skills/                   # Skill 源文件
│   └── init-claude-md/       # CLAUDE.md 初始化 Skill
│       ├── SKILL.md
│       ├── README.md
│       ├── scripts/
│       ├── references/
│       └── evals/
├── tools/                    # 工具集合
│   └── ccstatusline/         # Claude Code 状态栏工具
│       ├── README.md
│       └── setup.sh
├── hooks/                    # Hook 脚本源文件
│   └── record-history.js
├── configs/                  # 配置模板/预设（预留）
├── docs/                     # 文档
│   ├── ai-coding-tools/      # 项目信息
│   └── history/              # 会话历史记录
├── CLAUDE.md                 # AI 行为契约
├── README.md                 # 项目总览 + 工具索引
└── .gitignore
```

## 常用命令

- 安装 ccstatusline：`bash ccstatus/setup-ccstatusline.sh`
- 安装 Node.js 依赖：`npm install`（如项目后续添加 package.json）

## 已知坑点与技术债

暂无
