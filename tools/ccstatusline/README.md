# ccstatusline

一键安装和配置 [ccstatusline](https://www.npmjs.com/package/ccstatusline)，为 Claude Code 提供丰富的状态栏显示。

## 功能

安装后状态栏包含 6 行信息：

- 行1: 工作目录 | 会话 ID
- 行2: 模型 | 输出风格 | 思考强度 | 版本
- 行3: 缓存 token | 输入 token | 输出 token | 总 token
- 行4: 上下文进度 | 上下文长度 | 会话花费
- 行5: 剩余内存
- 行6: Git 分支 | Git 变更

## 依赖

- Node.js + npm
- Python 3

## 安装

```bash
bash tools/ccstatusline/setup.sh
```

安装完成后重启 Claude Code 即可生效。

## 脚本行为

`setup.sh` 依次执行以下步骤：

1. 检查 Node.js / npm 是否可用，不可用则报错退出
2. 全局安装 ccstatusline：`npm install -g ccstatusline`
3. 写入 `~/.config/ccstatusline/settings.json`：状态栏布局配置（6 行布局、配色、间距等）
4. 更新 `~/.claude/settings.json`：添加 `statusLine` 字段，启用 ccstatusline

## 卸载

1. 删除 ccstatusline：`npm uninstall -g ccstatusline`
2. 删除配置：`rm -rf ~/.config/ccstatusline`
3. 移除 `~/.claude/settings.json` 中的 `statusLine` 字段

## 自定义

安装后可编辑 `~/.config/ccstatusline/settings.json` 调整状态栏布局。支持的组件类型（type 字段）：

| 组件 | type 值 | 说明 |
|------|---------|------|
| 工作目录 | `current-working-dir` | 当前路径，fishStyle 缩短 |
| 会话 ID | `claude-session-id` | 当前会话标识 |
| 模型 | `model` | 当前使用的模型 |
| 输出风格 | `output-style` | 输出格式模式 |
| 思考强度 | `thinking-effort` | 思考模式级别 |
| 版本 | `version` | Claude Code 版本 |
| 缓存 token | `tokens-cached` | 缓存命中量 |
| 输入 token | `tokens-input` | 输入 token 数 |
| 输出 token | `tokens-output` | 输出 token 数 |
| 总 token | `tokens-total` | 总 token 数 |
| 上下文进度 | `context-bar` | 上下文窗口使用进度条 |
| 上下文长度 | `context-length` | 上下文窗口大小 |
| 会话花费 | `session-cost` | 当前会话费用 |
| 剩余内存 | `free-memory` | 系统可用内存 |
| Git 分支 | `git-branch` | 当前 Git 分支 |
| Git 变更 | `git-changes` | 未提交变更数量 |
| 分隔符 | `separator` | 组件之间的视觉分隔 |
