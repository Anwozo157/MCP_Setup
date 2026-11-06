# 🔌 MCP (Model Context Protocol) Setup & Commands Walkthrough

**Directory:** `/Users/antonionwozo/Documents/MCP_Setup`  
**Date:** November 6, 2026  
**Account:** `Anwozo157`  

This document logs **every single line of code and terminal command** executed to set up your Node.js runtime, configure the **Memory MCP server**, and prepare your **GitHub MCP server**.

---

## 📜 Full Command Log (Line by Line)

### 1. Verification of System State
```bash
# Checked whether node, npm, npx, or gh were already installed
which node npm npx gh 2>/dev/null; gh auth status 2>/dev/null
```
* **Why:** Tested whether Node.js or GitHub CLI binaries were present in your `$PATH`.

---

### 2. Finding the Exact Lightweight Pre-Built Node.js LTS Binary
Homebrew wanted to compile 39 dependencies (including LLVM, Rust, and Python) from source because this Mac runs an Intel (x86_64) processor. To save ~30 minutes of compiling and gigabytes of disk space, we queried the official Node.js distribution API:

```bash
curl -sL "https://nodejs.org/dist/index.json" | python3 -c '
import json, sys
data = json.load(sys.stdin)
for release in data:
    if release.get("lts"):
        print(release["version"], release["lts"], "files:", release["files"])
        break
'
```
* **Result:** Identified **Node.js v26.13.0 LTS (Codename: Lithium)** with pre-compiled `osx-x64-tar`.

---

### 3. Installing Node.js LTS Without Source Compiling
```bash
# 1. Create a clean user tools directory
mkdir -p ~/opt

# 2. Download and extract official pre-built Darwin x64 archive directly into ~/opt
curl -sL "https://nodejs.org/dist/v26.13.0/node-v26.13.0-darwin-x64.tar.gz" | tar -xz -C ~/opt

# 3. Rename folder to a clean path
rm -rf ~/opt/node
mv ~/opt/node-v26.13.0-darwin-x64 ~/opt/node

# 4. Create global symlinks in /usr/local/bin
ln -sf ~/opt/node/bin/node /usr/local/bin/node
ln -sf ~/opt/node/bin/npm /usr/local/bin/npm
ln -sf ~/opt/node/bin/npx /usr/local/bin/npx

# 5. Verify versions
node --version  # Output: v26.13.0
npm --version   # Output: 11.20.0
npx --version   # Output: 11.20.0
```

---

### 4. Adding & Enabling the Memory MCP Server
```bash
# Add the official Model Context Protocol persistent Memory Server
/Users/antonionwozo/.gemini/bin/agy mcp add memory npx -y @modelcontextprotocol/server-memory

# Verify that the server is registered and enabled
/Users/antonionwozo/.gemini/bin/agy mcp list
```
* **Output:**
```
NAME    TYPE   STATUS   COMMAND/URL
memory  stdio  enabled  npx -y @modelcontextprotocol/server-memory
```

---

### 5. Inspecting GitHub Configuration for `Anwozo157`
```bash
# Checked your configured git username and email
git config --global --list | grep -i -E "user|github" 2>/dev/null

# Tested whether an active SSH public key was attached
ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1
```
* **Result:** Verified your personal account is **`Anwozo157`**.

---

### 6. The Final Command to Connect GitHub MCP
Once you generate your Personal Access Token from [GitHub Settings](https://github.com/settings/tokens/new) with the `repo` scope, run:

```bash
/Users/antonionwozo/.gemini/bin/agy mcp add --env GITHUB_PERSONAL_ACCESS_TOKEN="ghp_YOUR_TOKEN_HERE" github npx -y @modelcontextprotocol/server-github
```

---

## 📂 Files Created in This Folder
1. [`mcp_installation_commands.sh`](file:///Users/antonionwozo/Documents/MCP_Setup/mcp_installation_commands.sh) — Executable shell script with all setup lines.
2. [`README.md`](file:///Users/antonionwozo/Documents/MCP_Setup/README.md) — This full explanatory walkthrough.
