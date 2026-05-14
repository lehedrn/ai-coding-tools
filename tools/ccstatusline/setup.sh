#!/usr/bin/env bash
# ccstatusline 一键安装配置脚本
# 用途：安装 ccstatusline 并导入预定义的状态栏配置

set -e

CONFIG_DIR="$HOME/.config/ccstatusline"
SETTINGS_JSON="$HOME/.claude/settings.json"

echo "=== ccstatusline 安装脚本 ==="

# 1. 检查 Node.js / npm
if ! command -v node &>/dev/null; then
  echo "❌ 未检测到 Node.js，请先安装 Node.js"
  exit 1
fi
echo "✅ Node.js $(node -v)"

if ! command -v npm &>/dev/null; then
  echo "❌ 未检测到 npm，请先安装 npm"
  exit 1
fi

# 2. 安装 ccstatusline
echo ""
echo "📦 正在全局安装 ccstatusline..."
npm install -g ccstatusline
echo "✅ ccstatusline 安装完成"

# 3. 写入 ccstatusline 配置
echo ""
echo "⚙️  正在写入 ccstatusline 配置..."
mkdir -p "$CONFIG_DIR"

python3 -c "
import json, os

config = {
    'version': 3,
    'lines': [
        [
            {'id': '32dea639-38db-450b-acf7-d94bdc141468', 'type': 'current-working-dir', 'metadata': {'fishStyle': 'true'}},
            {'id': '270aa782-0914-4b4a-9b4a-910e8f1d8ecf', 'type': 'separator'},
            {'id': '0d909025-ff85-4737-a43f-8f94611fa206', 'type': 'claude-session-id'}
        ],
        [
            {'id': '87db5f64-d9d0-4b9f-b385-6813ffe9235b', 'type': 'model'},
            {'id': '669931d8-75fa-46ad-9b37-12b320456674', 'type': 'separator'},
            {'id': 'b6824546-853f-4ee0-ab81-47c979b6eb82', 'type': 'output-style'},
            {'id': 'f7251b5b-291c-4dc4-8ba8-76604361ef2b', 'type': 'separator'},
            {'id': 'e6b48fc9-aab8-4707-9787-1deafce5a247d', 'type': 'thinking-effort'},
            {'id': 'df3fc570-2f5b-47d7-8a5c-b5adce5a4a4a', 'type': 'separator'},
            {'id': 'dba2988d-efb9-4af3-a367-c0ec890e6b27', 'type': 'version'}
        ],
        [
            {'id': '3a55e5c6-978b-465b-b540-656e71589b61', 'type': 'tokens-cached'},
            {'id': '71b12633-6f30-40f3-88f4-191659bfb337', 'type': 'separator'},
            {'id': '543f0b08-7599-413c-a5ea-d7f9ace08140', 'type': 'tokens-input'},
            {'id': '685cc96c-13e7-4194-889d-d713e0e42a92', 'type': 'separator'},
            {'id': '76578a9b-8289-404e-9428-16f9c89505a0', 'type': 'tokens-output'},
            {'id': '66a0fa4c-6689-41fd-84de-79c1e3d0bb98', 'type': 'separator'},
            {'id': 'b7f6084f-2b77-4677-91a9-f01cde60132d', 'type': 'tokens-total'}
        ],
        [
            {'id': '29c2ad65-49dc-49a8-b3e6-f24971d941a1', 'type': 'context-bar'},
            {'id': '7cd1879b-a9b7-4732-b175-e045d6d6f34a', 'type': 'separator'},
            {'id': 'b26b69a3-aa28-4c33-a482-476971d941a1', 'type': 'context-length'},
            {'id': 'c0191cd5-1646-4745-b55b-4978203adcbd', 'type': 'separator'},
            {'id': 'c388a7e2-0250-4fbf-8aa0-3ade2bd63b06', 'type': 'session-cost'}
        ],
        [
            {'id': '976256c2-a06e-4ff1-b26e-1f0f52b2a2a3', 'type': 'free-memory'}
        ],
        [
            {'id': 'c14cd5f1-388e-4a48-b4a6-a5a612704d37', 'type': 'git-branch'},
            {'id': '0ae7eb70-232e-4d31-a4f0-952170101c44', 'type': 'separator'},
            {'id': '31dc2117-6eaf-42df-bf28-93679637b82a', 'type': 'git-changes'}
        ]
    ],
    'flexMode': 'full-minus-40',
    'compactThreshold': 60,
    'colorLevel': 2,
    'inheritSeparatorColors': False,
    'globalBold': False,
    'minimalistMode': False,
    'powerline': {
        'enabled': False,
        'separators': [''],
        'separatorInvertBackground': [False],
        'startCaps': [],
        'endCaps': [],
        'autoAlign': False,
        'continueThemeAcrossLines': False
    }
}

path = os.path.join(os.environ['HOME'], '.config', 'ccstatusline', 'settings.json')
with open(path, 'w', encoding='utf-8') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
    f.write('\n')
"
echo "✅ ccstatusline 配置已写入 $CONFIG_DIR/settings.json"

# 4. 更新 Claude Code settings.json
echo ""
echo "🔧 正在配置 Claude Code statusLine..."

python3 -c "
import json, os

path = os.path.join(os.environ['HOME'], '.claude', 'settings.json')

if os.path.exists(path):
    with open(path, 'r') as f:
        settings = json.load(f)
else:
    settings = {}

settings['statusLine'] = {
    'type': 'command',
    'command': 'npx -y ccstatusline@latest',
    'padding': 0
}

with open(path, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write('\n')
"
echo "✅ Claude Code settings.json 已更新"

echo ""
echo "=== 安装完成 ==="
echo "重启 Claude Code 即可看到新的状态栏效果"
echo ""
echo "状态栏包含 6 行："
echo "  行1: 📁 工作目录 | 会话ID"
echo "  行2: 🤖 模型 | 输出风格 | 思考强度 | 版本"
echo "  行3: 📊 缓存token | 输入token | 输出token | 总token"
echo "  行4: 📏 上下文进度 | 上下文长度 | 会话花费"
echo "  行5: 💾 剩余内存"
echo "  行6: 🌿 Git分支 | Git变更"

