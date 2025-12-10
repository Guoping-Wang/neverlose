# neverloss
这是一个让你可以放心盒盖, 打开就恢复 Vibe coding 的项目, 让你的 AI牛马们一刻不得闲

# Remote Dev Workflow (sgn / ssr / sgs / sgl / sgk / sgd / sgw)
统一的一套远程开发工作流，解决这些问题：
- 合盖 / 断网 / 断电，不想丢掉服务器上的训练 /运行任务
- 一个人 / 团队同时维护多个项目，每个项目独立工作区
- 想要统一一套简单、可记忆的命令：
  - `sgn` / `ssr` / `sgs` / `sgl` / `sgk` / `sgd` / `sgw`

适用环境：

- 本地：macOS / Linux / WSL / Windows（通过 Git Bash）
- 远程：任意 Linux 服务器（Ubuntu / Debian / CentOS / ...）

## ✨ Features

- ✅ 一行命令进入远程项目工作区（自动 `tmux` 布局）
- ✅ 自动记住上一次项目：`sgn` 再次打开
- ✅ 合盖 / 断网后，一行命令恢复：`ssr`
- ✅ 一个命令查看远程所有 `tmux` 会话并多窗口打开：`sgl`
- ✅ 批量关闭不再使用的会话：`sgk`
- ✅ 一键查看服务器状态：`sgd`
- ✅ 一键工作模式：工作 tab + 维护 tab：`sgw`
- ✅ 支持多种服务器 / 多个用户，各自运行脚本即可


## 🧑‍🏫 使用方式一（推荐）：一键安装脚本（适合中级用户）

> 适合：已经稍微会用命令行的小伙伴。
### 1. 克隆本仓库或直接下载脚本

```bash
git clone https://github.com/Guoping-Wang/neverloss.git
cd <your-repo>
bash install_sg_workflow.sh
```



# Remote Tmux Workflow / 远程 Tmux 工作流

> A tiny workflow to make working on remote servers feel like working locally.  
> 一套让「远程服务器开发」尽量接近「本地开发体验」的小工具。

**Languages / 语言**  
[English](#english) | [简体中文](#简体中文)

---

## English

### What is this?

This repo contains a small workflow for managing **tmux sessions on a remote Linux server** from your laptop (macOS / Linux / Windows + Git Bash/WSL).

It solves a few common pains:

- You start a long training job, close the laptop → **session keeps running**.
- You work on several projects → **one tmux session per project**, auto‑named by directory.
- You disconnect or Wi‑Fi dies → `ssr` can **re‑attach** without thinking.
- You want a quick “server dashboard” → `sgd` shows host, memory, disk, GPU.

After setup, you mainly use these commands **on your laptop**:

| Command          | Description                                                                 |
| ---------------- | --------------------------------------------------------------------------- |
| `sgn <project>`  | Start or attach a tmux session for a project, and remember this project.   |
| `sgn`            | Reopen the **last project** (no argument needed).                          |
| `ssr`            | “Session resume” – re‑attach to a recent tmux session.                     |
| `sgs`            | Plain SSH shell (no auto‑tmux), for maintenance.                           |
| `sgl`            | List remote tmux sessions and choose which ones to open.                   |
| `sgk`            | Kill selected remote sessions cleanly.                                     |
| `sgd`            | Dashboard: host / uptime / memory / disk / tmux / GPU.                     |
| `sgw <project>`  | “Work mode”: open project session **and** a maintenance shell (macOS tabs).|

---

### 0. Requirements

**On your laptop**

- macOS Terminal / iTerm2, or
- Linux shell, or
- Windows with **Git Bash** or **WSL** (Ubuntu etc.)

**On your remote server**

- Linux user account you can SSH into.
- `tmux` installed. (Recommended: also `htop` and `nvidia-smi`.)

---

### 1. SSH key setup (one‑time)

On your **laptop**:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"

### 2. 或直接在线运行
curl -fsSL https://github.com/Guoping-Wang/neverloss/main/install_sg_workflow.sh | bash
