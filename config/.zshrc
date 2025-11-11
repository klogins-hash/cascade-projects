export VAPI_INSTALL="$HOME/.vapi"
export PATH="$VAPI_INSTALL/bin:$PATH"
export MANPATH="$HOME/.vapi/share/man:$MANPATH"
export PATH="/Users/franksimpson/CascadeProjects/weaviate-doesnt-know-v313/scripts:$PATH"
export PATH="/Users/franksimpson/scripts:$PATH"

# Auto-load API environment for Weaviate project
if [[ -f "/Users/franksimpson/CascadeProjects/weaviate-doesnt-know-v313/scripts/activate.sh" ]]; then
    source "/Users/franksimpson/CascadeProjects/weaviate-doesnt-know-v313/scripts/activate.sh"
fi

. "$HOME/.local/bin/env"
export PATH="/Applications/Windsurf.app/Contents/Resources/app/bin:$PATH"

# Added by Cartesia CLI installer
export PATH="/Users/franksimpson/.cartesia/bin:$PATH"
alias nf="node /opt/homebrew/lib/node_modules/@northflank/cli/dist/cli.js"

# SSH Agent auto-start and key loading
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add --apple-use-keychain ~/.ssh/github_windsurf 2>/dev/null
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
fi

# Auto-start Claude Code in new terminal sessions (DISABLED)
# Check if not already in a Claude Code session
# if [ -z "$CLAUDE_CODE_SESSION" ]; then
#     export CLAUDE_CODE_SESSION=1
#     claude --dangerously-skip-permissions -c --ide --model sonnet --verbose
# fi

# Langflow environment (disabled - file not found)
# . "$HOME/.langflow/uv/env"

# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"

# Scaleway Configuration
export SCW_ACCESS_KEY=SCWCXGXHXZ9GHFV4PA1N
export SCW_SECRET_KEY=6087458f-225d-4da2-916f-ef4a1875246e
export SCW_DEFAULT_ORGANIZATION_ID=c5d299b8-8462-40fb-b5ae-32a8808bf394
export SCW_DEFAULT_PROJECT_ID=b6c2c4f2-4697-4927-9580-143bf8c3f588

# Docker Desktop Configuration (Default)
# Use Docker Desktop by default for local development
export DOCKER_CONTEXT=desktop-linux
unset DOCKER_HOST

# Remote Server Configuration
export REMOTE_HOST="163.172.178.119"
export REMOTE_USER="root"
export DEPLOY_TARGET="dockerdayz"

# Aliases for remote deployment
alias docker-remote="docker --context dockerdayz"
alias docker-scaleway="docker --context scaleway-docker"
alias docker-local="docker --context desktop-linux"
alias deploy-remote="docker --context dockerdayz compose up -d"
alias ssh-dockerdayz="ssh dockerdayz"

# Docker Build Best Practice: Always use AMD64 for cloud deployments
# Most cloud platforms (Scaleway, AWS, GCP) require AMD64 architecture
alias docker-build-cloud='docker build --platform linux/amd64'
alias docker-build-amd64='docker build --platform linux/amd64'

# Reminder function for docker build
docker-build() {
    echo "💡 Reminder: Building for cloud? Use --platform linux/amd64"
    echo "   Quick alias: docker-build-cloud or docker-build-amd64"
    command docker build "$@"
}

# bun completions
[ -s "/Users/franksimpson/.bun/_bun" ] && source "/Users/franksimpson/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set Bun as default package manager
alias npm="bun"
alias yarn="bun" 
alias pnpm="bun"

# === VSCODE_PROJECTS_CONFIG ===
# Workspace shortcuts for agentic development

export VSCODE_PROJECTS="/Users/franksimpson/CascadeProjects/vscode_projects"

# Open VS Code in vscode_projects directory
alias cvp="code $VSCODE_PROJECTS/vscode_projects.code-workspace"

# Navigate to vscode_projects quickly
alias vsp-cd="cd $VSCODE_PROJECTS"

# Clone repository directly to vscode_projects
# Usage: clone-to-vsp owner/repo  OR  clone-to-vsp https://github.com/owner/repo.git
clone-to-vsp() {
    if [ $# -eq 0 ]; then
        echo "Usage: clone-to-vsp <owner/repo> [git-clone-options]"
        echo "Examples:"
        echo "  clone-to-vsp anthropics/anthropic-sdk"
        echo "  clone-to-vsp https://github.com/user/repo.git --depth 1"
        return 1
    fi

    cd "$VSCODE_PROJECTS" && bash ./clone-repo.sh "$@"
}

# Open a project from vscode_projects by name
# Usage: vsp-open project-name
vsp-open() {
    if [ $# -eq 0 ]; then
        echo "Usage: vsp-open <project-name>"
        echo ""
        echo "Available projects:"
        ls -1d "$VSCODE_PROJECTS"/*/ 2>/dev/null | xargs -I {} basename {} | grep -v "^\\." || echo "  (no projects yet)"
        return 1
    fi

    PROJECT_PATH="$VSCODE_PROJECTS/$1"
    if [ -d "$PROJECT_PATH" ]; then
        code "$PROJECT_PATH"
    else
        echo "❌ Project not found: $PROJECT_PATH"
        return 1
    fi
}

# List all projects in vscode_projects
alias vsp-list="ls -1d $VSCODE_PROJECTS/*/ 2>/dev/null | xargs -I {} basename {} | grep -v '^\\.'"

# Jump into vscode_projects and list projects
alias vsp-ls="vsp-cd && echo '📁 Projects:' && vsp-list"

# CascadeProjects shortcuts
alias cp-cd="cd /Users/franksimpson/CascadeProjects"
alias cp-ls="ls -1d /Users/franksimpson/CascadeProjects/*/ 2>/dev/null | xargs -I {} basename {} | grep -v '^\\.'"
alias cp-open="code /Users/franksimpson/CascadeProjects"
alias cp-cleanup="/Users/franksimpson/CascadeProjects/scripts/cleanup-vscode-repos.sh"
alias cp-cleanup-all="/Users/franksimpson/CascadeProjects/scripts/comprehensive-cleanup.sh"
alias home-cleanup="/Users/franksimpson/CascadeProjects/scripts/home-cleanup.sh"
alias system-cleanup="/Users/franksimpson/CascadeProjects/scripts/system-cleanup.sh"
alias vscode-cleanup="/Users/franksimpson/CascadeProjects/scripts/vscode-config-cleanup.sh"
alias remove-all-git="/Users/franksimpson/CascadeProjects/scripts/remove-all-git.sh"
alias clean-projects="/Users/franksimpson/CascadeProjects/scripts/clean-project-folders.sh"

# === END VSCODE_PROJECTS_CONFIG ===

# Exoscale CLI Configuration (Persistent across sessions)

# Load local environment variables
if [ -f ~/.env.local ]; then
    source ~/.env.local
fi
