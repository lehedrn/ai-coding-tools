# 输出模板

## CLAUDE.md 模板

以下是 CLAUDE.md 的标准输出结构。`{占位符}` 部分在 Skill 执行时替换为实际内容，不需要的章节直接删除。

```markdown
# CLAUDE.md

## 上下文加载

读取本文件后，必须立即读取 docs/{project_name}/info.md，获取项目技术栈、目录结构、常用命令等信息。

## 项目概述

{项目概述内容}

## AI 行为偏好

### 回复风格
{回复风格规则}

### 代码风格
{代码风格规则}

### 协作偏好
{协作偏好规则}

## 文档规范
{文档规范内容，如不需要则删除整个章节}

{自定义章节标题}
{自定义章节内容，如不需要则删除}
```

---

## 项目信息文件模板

默认路径：`docs/{project_name}/info.md`

```markdown
# 项目信息

## 技术栈
{从 package.json / pom.xml / build.gradle / requirements.txt 等识别}

## 目录结构
{项目主要目录树，不超过 3 层深度}

## 常用命令
{从 Makefile / package.json scripts / build 配置等提取}

## 已知坑点与技术债
{从 TODO/FIXME/HACK 注释、已知问题中提取，没有则写"暂无"}
```

---

## settings.local.json Hook 配置模板

安装 record-history hook 时，需要在 `.claude/settings.local.json` 中添加以下配置。如果文件已有其他配置，合并而非覆盖。

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/record-history.js"
          }
        ]
      }
    ]
  }
}
```

同时需要将 `scripts/record-history.js` 复制到项目的 `.claude/hooks/record-history.js`，并确保有执行权限（`chmod +x`）。
