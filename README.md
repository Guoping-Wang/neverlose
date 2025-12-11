<div align="center">
  <h1>🚀 neverlose</h1>
  <p><strong>Remote Tmux Workflow · 远程 Tmux 工作流</strong></p>
  <p><em>Make remote servers feel almost like local dev · 让远程开发体验尽可能接近本地</em></p>
  
  <br/>
  
  <p>
    <img src="https://img.shields.io/badge/tmux-automation-green?style=for-the-badge&logo=tmux&logoColor=white"/>
    <img src="https://img.shields.io/badge/ssh-optimized-blue?style=for-the-badge&logo=openssh&logoColor=white"/>
    <img src="https://img.shields.io/badge/macOS-supported-000000?style=for-the-badge&logo=apple&logoColor=white"/>
    <img src="https://img.shields.io/github/license/Guoping-Wang/neverlose?style=for-the-badge"/>
  </p>
</div>

<br/>

---

<div align="center">
  <h3>💫 Never lose your session. Never lose your progress. Never lose your flow.</h3>
  <p>不会再丢失会话，不会再丢失运行任务，不会再丢失编程 Flow。</p>
</div>

---

<br/>

## 📌 What is neverlose? · neverlose 是什么？

**neverlose** is a tiny workflow that makes working on remote Linux servers with tmux feel natural, stable, and local-like.  
**neverlose** 是一套小巧但非常实用的工具，让你在远程 Linux 服务器上的 tmux 工作流变得稳定、顺手、接近本地体验。

It solves common pains for ML researchers, engineers, and anyone using remote servers.  
它专门解决远程开发中最常见的痛点，适合 AI/ML 研究者、工程师，以及任何使用远程服务器的人。

<br/>

## 🔥 Why neverlose? · 为什么需要 neverlose？

### 💥 **Problem 1: Closing laptop / Wi-Fi drop kills your vibe**
💥 **痛点 1：合盖 / 掉线导致工作中断**

✅ **Solution**: neverlose keeps everything running in tmux and lets you resume instantly.  
✅ **解决方案**：所有任务都在 tmux 里持久运行，一条命令即可恢复现场。

---

### 🌀 **Problem 2: Multiple projects, messy sessions**
🌀 **痛点 2：多个项目 session 混乱难管理**

✅ **Solution**: neverlose maps one project = one tmux session, auto-named and auto-layout.  
✅ **解决方案**：neverlose 将 一个项目 = 一个 tmux 会话，自动命名、自动布局。

---

### 🧠 **Problem 3: Need a unified, memorable workflow**
🧠 **痛点 3：简单易记的命令**

✅ **Solution**: Commands like `sgn` / `ssr` / `sgs` / `sgl` / `sgk` / `sgd` / `sgw`  
✅ **解决方案**：可记忆的短命令：`sgn` / `ssr` / `sgs` / `sgl` / `sgk` / `sgd` / `sgw`

---

### 📊 **Problem 4: No quick way to check server status**
📊 **痛点 4：没有一键查看服务器状态的工具**

✅ **Solution**: `sgd` gives host/mem/disk/GPU/tmux in one view.  
✅ **解决方案**：`sgd` 一键展示主机 / 内存 / 磁盘 / GPU / tmux 会话。

<br/>

## ✨ Features · 功能亮点

- 🧠 **Smart Resume**: `sgn` remembers your last project  
  **智能恢复**：记住上一次项目，一条命令恢复工作区
  
- 🔄 **Instant Recovery**: `ssr` resumes after disconnect  
  **即时恢复**：断网 / 合盖后立即恢复 tmux 会话
  
- 🖥 **Server Dashboard**: `sgd` shows system status at a glance  
  **服务器仪表盘**：一键查看服务器状态（CPU/内存/磁盘/GPU）
  
- 🧩 **Project Isolation**: One project = one tmux session  
  **项目隔离**：每个项目自动对应一个 tmux session
  
- 🪟 **Multi-Tab Mode**: macOS multi-tab work mode (`sgw`)  
  **多标签模式**：macOS 自动多 Tab 工作模式
  
- 🧹 **Session Cleanup**: Clean up unused sessions with `sgk`  
  **会话清理**：清理不再使用的 tmux 会话
  
- 🌍 **Cross-Platform**: macOS / Linux / Windows + Git Bash/WSL  
  **跨平台支持**：支持所有主流操作系统

<br/>

## ⚡ Commands Overview · 命令速查表

| Command | Description (EN) | 描述（中文） |
|---------|------------------|-------------|
| `sgn <project>` | Start/attach project session | 启动/进入项目会话 |
| `sgn` | Reopen last project | 打开上次项目 |
| `ssr` | Resume recent tmux session | 恢复最近 tmux 会话 |
| `sgs` | SSH only, no tmux | 纯 SSH 模式（不进入 tmux） |
| `sgl` | List and open tmux sessions | 列出并打开 tmux 会话 |
| `sgk` | Kill selected tmux sessions | 清理选定会话 |
| `sgd` | Dashboard | 服务器仪表盘 |
| `sgw <project>` | Work mode (tabs) | 工作模式（多 tab） |

<br/>

## 🚀 Installation · 安装方式

### Method 1: Clone + local installer (recommended) · 克隆仓库 + 安装脚本（推荐）

```bash
git clone https://github.com/Guoping-Wang/neverlose.git
cd neverlose
bash install_sg_workflow.sh
```

### Method 2: One-line online install · 在线一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/Guoping-Wang/neverlose/main/install_sg_workflow.sh | bash
```

<br/>

## 🧩 Requirements · 环境要求

### Local laptop · 本地环境
- macOS Terminal / iTerm2
- Linux shell
- Windows Git Bash / WSL

### Remote server · 远程服务器
- Linux (Ubuntu / Debian / CentOS / etc.)
- tmux installed （推荐额外安装 htop / nvidia-smi）

<br/>

## 🔑 SSH Setup (if needed) · 如未配置 SSH，需要先生成密钥

```bash
ssh-keygen -t ed25519 -C "you@example.com"
ssh-copy-id user@host
```

<br/>

## 📂 Directory Structure · 仓库结构

```
neverlose/
├── LICENSE
├── README.md
├── install_sg_workflow.sh     # 本地安装脚本
└── layout_by_dir.sh           # 远程 tmux 自动布局逻辑
```

<br/>

## 💡 Philosophy · 设计理念

> **The remote workflow should disappear.**  
> **You code. It stays alive. You never lose.**
> 
> 最好的远程工作流，就是让你感觉不到它的存在。  
> 你写代码，它保持在线，你永不丢失现场。

<br/>

## 🤝 Contributing · 参与贡献

PRs and Issues are welcome! Feel free to submit feature requests, bug reports, or optimization PRs.  
PR / Issue 欢迎！欢迎提供功能建议、Bug 反馈或优化 PR。

<br/>

## 📄 License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

<br/>

---

<div align="center">
  <h3>⭐ Star This Repo · 如果觉得好用，请点个 Star！</h3>
  <p>Your star motivates new features & ongoing development. · 你的 Star 会让项目继续更新、进化。</p>
  <br/>
  <p>Made with ❤️ by <a href="https://github.com/Guoping-Wang">Guoping Wang</a></p>
</div>
