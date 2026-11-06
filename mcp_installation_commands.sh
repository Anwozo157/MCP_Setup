#!/usr/bin/env bash
# ==============================================================================
# MCP (Model Context Protocol) Setup & Installation Script
# System: macOS (Darwin x86_64 / Intel)
# Author: Antonio Nwozo
# Date: November 6, 2026
# ==============================================================================

set -e

echo "=== Step 1: Pre-requisite Check (Node.js & GitHub CLI) ==="
which node npm npx gh 2>/dev/null || echo "Tools not yet in PATH"

echo "=== Step 2: Query Available Official Node.js LTS Releases ==="
# Queried the official nodejs.org distribution index to find the latest stable x64 build
curl -sL "https://nodejs.org/dist/index.json" | python3 -c '
import json, sys
data = json.load(sys.stdin)
for release in data:
    if release.get("lts"):
        print("Latest LTS:", release["version"], release["lts"])
        break
'

echo "=== Step 3: Install Node.js LTS (v26.13.0) Without Bloat or Compiling ==="
# Created local installation directory
mkdir -p ~/opt

# Downloaded official pre-built Darwin x64 tarball and extracted directly to ~/opt
curl -sL "https://nodejs.org/dist/v26.13.0/node-v26.13.0-darwin-x64.tar.gz" | tar -xz -C ~/opt

# Set up clean symlink directory
rm -rf ~/opt/node
mv ~/opt/node-v26.13.0-darwin-x64 ~/opt/node

# Linked node, npm, and npx binaries to /usr/local/bin for global system access
ln -sf ~/opt/node/bin/node /usr/local/bin/node
ln -sf ~/opt/node/bin/npm /usr/local/bin/npm
ln -sf ~/opt/node/bin/npx /usr/local/bin/npx

# Verified installation versions
echo "Node version: $(node --version)"
echo "NPM version:  $(npm --version)"
echo "NPX version:  $(npx --version)"

echo "=== Step 4: Install & Enable Memory MCP Server ==="
# Configured the persistent Memory MCP server inside Antigravity CLI
/Users/antonionwozo/.gemini/bin/agy mcp add memory npx -y @modelcontextprotocol/server-memory

# Verified active MCP list
/Users/antonionwozo/.gemini/bin/agy mcp list

echo "=== Step 5: Check GitHub Identity & Environment ==="
# Checked git configuration for personal GitHub account
git config --global --list | grep -i -E "user|github" || true

echo "=== Step 6: Command to Connect Personal GitHub Account (Run after generating token) ==="
# Replace ghp_your_personal_access_token_here with your actual GitHub token:
# /Users/antonionwozo/.gemini/bin/agy mcp add --env GITHUB_PERSONAL_ACCESS_TOKEN="ghp_your_token_here" github npx -y @modelcontextprotocol/server-github
