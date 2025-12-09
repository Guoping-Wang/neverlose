#!/usr/bin/env bash
#
# install_sg_workflow.sh
#
# 一键安装「远程开发工作流」：
#   sgn / ssr / sgs / sgl / sgk / sgd / sgw
#
# 适用于：
#   - macOS（推荐 Terminal 或 iTerm2）
#   - Linux / WSL
#   - Windows（通过 Git Bash / WSL）
#
# 注意：
#   - 本脚本只在本机写入配置（不会自动修改服务器），
#   - 你仍然需要在服务器上手动：
#       1）设置 SSH 公钥免密
#       2）安装 tmux
#       3）创建 ~/.tmux/layout_by_dir.sh
#

set -e

echo "=============================================="
echo "  远程开发工作流安装脚本 (sgn / ssr / sgs / ...)"
echo "=============================================="
echo
echo "本脚本将会为你："
echo "  1. 在本机生成一份统一的工作流配置 (~/.sg_workflow.sh)"
echo "  2. 自动写入你的 shell 配置 (bash/zsh)"
echo "  3. 提供命令：sgn / ssr / sgs / sgl / sgk / sgd / sgw"
echo
echo "注意：你需要已经可以 ssh 登录你的远程服务器（哪怕是输密码也行）。"
echo

# ----------------------------
# 1. 检测操作系统和 shell
# ----------------------------
OS_NAME="$(uname -s)"
SHELL_NAME="$(basename "${SHELL:-bash}")"

echo "检测到操作系统: ${OS_NAME}"
echo "检测到默认 shell: ${SHELL_NAME}"
echo

# 确定默认 rc 文件
RC_FILE=""

if [ "$SHELL_NAME" = "zsh" ]; then
  RC_FILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
  # macOS 上 bash 一般使用 ~/.bash_profile，Linux 上用 ~/.bashrc
  if [ "$OS_NAME" = "Darwin" ]; then
    RC_FILE="$HOME/.bash_profile"
  else
    # Linux / WSL
    if [ -f "$HOME/.bashrc" ]; then
      RC_FILE="$HOME/.bashrc"
    else
      RC_FILE="$HOME/.bash_profile"
    fi
  fi
else
  # 其它 shell，默认生成一个 ~/.sg_workflow.sh，让用户自行 source
  RC_FILE="$HOME/.bash_profile"
fi

echo "即将写入的配置文件: $RC_FILE"
echo

# ----------------------------
# 2. 询问远程服务器信息
# ----------------------------
echo "接下来请告诉我你的远程服务器信息（每台服务器需要运行一次本脚本）。"
echo

read -rp "远程用户名 (例如 alice): " REMOTE_USER
while [ -z "$REMOTE_USER" ]; do
  echo "用户名不能为空，请重新输入。"
  read -rp "远程用户名 (例如 alice): " REMOTE_USER
done

read -rp "远程地址或 IP (例如 gpu1.company.com 或 1.2.3.4): " REMOTE_HOST
while [ -z "$REMOTE_HOST" ]; do
  echo "远程地址不能为空，请重新输入。"
  read -rp "远程地址或 IP: " REMOTE_HOST
done

# SSH key 路径
DEFAULT_SSH_KEY="$HOME/.ssh/id_ed25519"
read -rp "本地 SSH 私钥路径 [回车默认为 $DEFAULT_SSH_KEY]: " SSH_KEY
SSH_KEY="${SSH_KEY:-$DEFAULT_SSH_KEY}"

if [ ! -f "$SSH_KEY" ]; then
  echo
  echo "⚠️ 找不到 SSH 私钥: $SSH_KEY"
  echo "你可以用以下命令生成（推荐）："
  echo "    ssh-keygen -t ed25519 -C \"your_email\""
  echo
  echo "生成后重新运行本脚本，或者现在就 Ctrl-C 退出去生成。"
  echo
  read -rp "确定要继续吗？[y/N]: " CONT
  CONT="${CONT:-N}"
  if [ "$CONT" != "y" ] && [ "$CONT" != "Y" ]; then
    echo "已取消安装。"
    exit 1
  fi
fi

# 远程 tmux 命令
read -rp "远程 tmux 命令名或完整路径 [回车默认为 tmux]: " REMOTE_TMUX
REMOTE_TMUX="${REMOTE_TMUX:-tmux}"

# 远程额外 PATH 前缀（比如 /home/linuxbrew/.linuxbrew/bin），可为空
echo
echo "如果远程 tmux 不在默认 PATH 里，你可以在这里填一个目录前缀。"
echo "例如：/home/linuxbrew/.linuxbrew/bin"
read -rp "远程 PATH 前缀 (可留空): " EXTRA_PREFIX

REMOTE_ENV_PREFIX=""
if [ -n "$EXTRA_PREFIX" ]; then
  # 注意这里 \$PATH 需要在运行时展开，所以要加反斜杠
  REMOTE_ENV_PREFIX="export PATH=${EXTRA_PREFIX}:\$PATH; "
fi

echo
echo "====== 配置信息预览 ======"
echo "  远程用户      : $REMOTE_USER"
echo "  远程主机      : $REMOTE_HOST"
echo "  本地 SSH 私钥 : $SSH_KEY"
echo "  远程 tmux     : $REMOTE_TMUX"
echo "  远程 PATH 前缀: ${EXTRA_PREFIX:-<无>}"
echo "  Shell 配置文件: $RC_FILE"
echo "=========================="
echo

read -rp "确认以上信息正确并继续安装？[Y/n]: " CONFIRM
CONFIRM="${CONFIRM:-Y}"
if [ "$CONFIRM" != "Y" ] && [ "$CONFIRM" != "y" ]; then
  echo "已取消安装。"
  exit 1
fi

# ----------------------------
# 3. 生成 ~/.sg_workflow.sh
# ----------------------------
WORKFLOW_FILE="$HOME/.sg_workflow.sh"

cat > "$WORKFLOW_FILE" <<EOF
########################################
# 远程开发工作流统一配置
# 此文件由 install_sg_workflow.sh 自动生成
########################################

# 最近 project 名称记录
LAST_PROJ_FILE="\$HOME/.sg_last_project"

# 远程服务器配置
REMOTE_USER="$REMOTE_USER"
REMOTE_HOST="$REMOTE_HOST"
REMOTE="\$REMOTE_USER@\${REMOTE_HOST}"
SSH_KEY="$SSH_KEY"

# 远程 tmux 配置
REMOTE_TMUX="$REMOTE_TMUX"
remote_env_prefix="$REMOTE_ENV_PREFIX"

# 基础 alias
alias ll='ls -lh'
alias showalias='alias | sort'

# reload 刷新当前 shell 配置
alias reload='source "$RC_FILE"'

# 远程命令封装
_remote() {
  /usr/bin/ssh -i "\$SSH_KEY" "\$REMOTE" "\$@"
}

_remote_t() {
  /usr/bin/ssh -t -i "\$SSH_KEY" "\$REMOTE" "\$@"
}

########################################
# sgn — 进入项目工作区（自动记住上一次）
########################################
sgn() {
  local PROJECT

  if [ -n "\$1" ]; then
    PROJECT="\$1"
  elif [ -f "\$LAST_PROJ_FILE" ]; then
    PROJECT="\$(cat "\$LAST_PROJ_FILE")"
    [ -n "\$PROJECT" ] && echo "使用上一次的 project: \$PROJECT"
  fi

  if [ -z "\$PROJECT" ]; then
    echo "没有 project 记录，请用: sgn <project_name>"
    return 1
  fi

  echo "\$PROJECT" > "\$LAST_PROJ_FILE"

  _remote_t "\${remote_env_prefix} mkdir -p ~/ai/\${PROJECT} && cd ~/ai/\${PROJECT} && ~/.tmux/layout_by_dir.sh"
}

########################################
# ssr — 恢复最近的 tmux session
########################################
ssr() {
  _remote_t "\${remote_env_prefix} \${REMOTE_TMUX} attach || \${REMOTE_TMUX} new-session -A -s ai -c ~/ai"
}

########################################
# sgs — 只登录服务器，不进 tmux（维护用）
########################################
sgs() {
  echo "=== 远程 tmux sessions ==="
  _remote "\${remote_env_prefix} \${REMOTE_TMUX} ls 2>/dev/null || echo '  (none)'"
  echo "=== 进入普通 SSH（不自动 tmux） ==="
  _remote_t "\${remote_env_prefix} TMUX=; PS1='\\u@\\h:\\w\\$ '; export PS1; exec bash --noprofile --norc"
}

########################################
# sgl — 列出 tmux sessions 并在新 tab attach（仅 macOS 支持多 tab）
########################################
sgl() {
  local SESSIONS
  SESSIONS=\$(_remote "\${remote_env_prefix} \${REMOTE_TMUX} ls -F '#S' 2>/dev/null") || SESSIONS=""

  if [ -z "\$SESSIONS" ]; then
    echo "远程没有 tmux session."
    return 0
  fi

  echo "当前远程 tmux sessions:"
  local i=1
  local arr=()
  while IFS= read -r s; do
    [ -z "\$s" ] && continue
    echo "  \$i) \$s"
    arr[\$i]="\$s"
    i=\$((i+1))
  done <<< "\$SESSIONS"

  echo
  echo "输入要在新 tab 打开的序号（用空格分隔，比如: 1 3 4），然后回车："
  read -r choices

  # 非 macOS 无 AppleScript，降级为当前窗口 attach
  local os_name
  os_name=\$(uname -s)

  local key="\$SSH_KEY"
  local user="\$REMOTE_USER"
  local host="\$REMOTE_HOST"

  for c in \$choices; do
    local name="\${arr[\$c]}"
    [ -z "\$name" ] && continue

    if [ "\$os_name" = "Darwin" ]; then
      /usr/bin/osascript <<EOS
tell application "Terminal"
  activate
  do script "ssh -t -i '$key' '$user@$host' '$REMOTE_TMUX attach -t $name'"
end tell
EOS
    else
      echo "非 macOS 环境，直接在当前窗口 attach: \$name"
      _remote_t "\${remote_env_prefix} \${REMOTE_TMUX} attach -t \$name"
    fi
  done
}

########################################
# sgk — 批量 kill tmux sessions
########################################
sgk() {
  local SESSIONS
  SESSIONS=\$(_remote "\${remote_env_prefix} \${REMOTE_TMUX} ls -F '#S' 2>/dev/null") || SESSIONS=""

  if [ -z "\$SESSIONS" ]; then
    echo "远程没有 tmux session."
    return 0
  fi

  echo "当前远程 tmux sessions:"
  local i=1
  local arr=()
  while IFS= read -r s; do
    [ -z "\$s" ] && continue
    echo "  \$i) \$s"
    arr[\$i]="\$s"
    i=\$((i+1))
  done <<< "\$SESSIONS"

  echo
  echo "输入要 kill 的序号（空格分隔），然后回车："
  read -r choices

  for c in \$choices; do
    local name="\${arr[\$c]}"
    [ -z "\$name" ] && continue
    echo "Killing session: \$name"
    _remote "\${remote_env_prefix} \${REMOTE_TMUX} kill-session -t \${name}"

    if [ -f "\$LAST_PROJ_FILE" ]; then
      last_proj=\$(cat "\$LAST_PROJ_FILE")
      if [ "\$last_proj" = "\$name" ]; then
        rm -f "\$LAST_PROJ_FILE"
        echo "已清除上一次项目记录: \$name"
      fi
    fi
  done
}

########################################
# sgd — 打印服务器状态 Dashboard
########################################
sgd() {
  _remote "\${remote_env_prefix} \
echo '=== HOST ==='; hostname; echo; \
echo '=== UPTIME ==='; uptime; echo; \
echo '=== MEMORY ==='; free -h 2>/dev/null; echo; \
echo '=== DISK / ==='; df -h / | sed -n '1,2p'; echo; \
echo '=== TMUX SESSIONS ==='; \${REMOTE_TMUX} ls 2>/dev/null || echo '无 tmux session'; \
if command -v nvidia-smi >/dev/null 2>&1; then \
  echo; echo '=== GPU ==='; \
  nvidia-smi --query-gpu=name,memory.total,memory.used,utilization.gpu --format=csv,noheader; \
fi"
}

########################################
# sgw — 一键工作模式（工作 tab + 维护 tab，macOS 优化）
########################################
sgw() {
  local PROJECT

  if [ -n "\$1" ]; then
    PROJECT="\$1"
  elif [ -f "\$LAST_PROJ_FILE" ]; then
    PROJECT="\$(cat "\$LAST_PROJ_FILE")"
    [ -n "\$PROJECT" ] && echo "使用上一次的 project: \$PROJECT"
  fi

  if [ -z "\$PROJECT" ]; then
    echo "请输入 project 名字："
    read -r PROJECT
  fi

  echo "\$PROJECT" > "\$LAST_PROJ_FILE"

  local os_name
  os_name=\$(uname -s)

  if [ "\$os_name" = "Darwin" ]; then
    /usr/bin/osascript <<EOS
tell application "Terminal"
  activate
  do script "bash -lc 'sgn \$PROJECT'"
  do script "bash -lc 'sgs'"
end tell
EOS
  else
    echo "非 macOS 环境，将在当前终端依次打开 sgn 和 sgs。"
    echo "先进入项目 tmux："
    sgn "\$PROJECT"
    echo "（在新终端窗口中手动运行 sgs 以进入维护模式）"
  fi
}
EOF

echo
echo "已生成配置文件: $WORKFLOW_FILE"
echo

# ----------------------------
# 4. 把 source 写入 rc 文件
# ----------------------------
if [ ! -f "$RC_FILE" ]; then
  touch "$RC_FILE"
fi

if ! grep -qF "$WORKFLOW_FILE" "$RC_FILE"; then
  echo "" >> "$RC_FILE"
  echo "# 加载远程开发工作流配置" >> "$RC_FILE"
  echo "[ -f \"$WORKFLOW_FILE\" ] && source \"$WORKFLOW_FILE\"" >> "$RC_FILE"
  echo "已在 $RC_FILE 中添加加载语句。"
else
  echo "$RC_FILE 中已包含对 $WORKFLOW_FILE 的引用。"
fi

echo
echo "========================================"
echo "安装完成！请在当前终端执行："
echo
echo "    source \"$RC_FILE\""
echo
echo "然后你就可以使用以下命令："
echo "    sgn / ssr / sgs / sgl / sgk / sgd / sgw"
echo
echo "注意：你仍然需要在服务器上创建："
echo "    ~/.tmux/layout_by_dir.sh"
echo "示例脚本可以在 README 中看到。"
echo "========================================"
echo


