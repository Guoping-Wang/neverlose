#!/usr/bin/env bash
# layout_by_dir.sh
#
# This script defines a tmux layout customised for a project directory.
# It is called by the local sgn/ssr helpers.  Feel free to edit it to suit
# your own workflow.

set -e

TMUX_BIN=${TMUX_BIN:-"$(command -v tmux || echo tmux)"}
if [[ -z "$TMUX_BIN" ]]; then
  echo "tmux not found.  Please install tmux on the remote server."
  exit 1
fi

dirname="$(basename "$PWD")"
session="${dirname//[^a-zA-Z0-9_]/}"  # sanitize

# If session exists, just attach
if "$TMUX_BIN" has-session -t "$session" 2>/dev/null; then
  exec "$TMUX_BIN" attach -t "$session"
fi

# Create new session
"$TMUX_BIN" new-session -d -s "$session" -c "$PWD"

# Window 1: dev (split horizontally)
"$TMUX_BIN" rename-window -t "$session:1" 'dev'
"$TMUX_BIN" split-window -h -t "$session:1"
"$TMUX_BIN" select-pane -t "$session:1.1"
"$TMUX_BIN" resize-pane -t "$session:1.1" -R 20 2>/dev/null || true

# Left pane: remain at project root

# Right pane: show logs or open shell if none
if [[ -d "logs" ]]; then
  "$TMUX_BIN" send-keys -t "$session:1.2" 'ls logs && echo "---- tail logs/*.log ----" && tail -f logs/*.log' C-m
fi

# Window 2: monitor (GPU)
"$TMUX_BIN" new-window -t "$session:2" -n 'mon'
"$TMUX_BIN" send-keys -t "$session:2.1" 'watch -n 2 nvidia-smi || (echo "no nvidia-smi"; bash)' C-m

# Window 3: sys (system resources)
"$TMUX_BIN" new-window -t "$session:3" -n 'sys'
"$TMUX_BIN" send-keys -t "$session:3.1" 'htop || top' C-m

# Return to dev window
"$TMUX_BIN" select-window -t "$session:1"
"$TMUX_BIN" select-pane -t "$session:1.1"

exec "$TMUX_BIN" attach -t "$session"