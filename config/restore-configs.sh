#!/bin/bash
# Restore configurations from CascadeProjects to their proper locations

echo "🔧 Restoring configurations..."
CONFIG_DIR="/Users/franksimpson/CascadeProjects/config"

# Restore home directory configs
for item in .env.local .zshrc .zprofile .gitconfig .ssh .git-credentials; do
    if [ -e "$CONFIG_DIR/$item" ]; then
        echo "   Restoring $item to home directory..."
        cp -r "$CONFIG_DIR/$item" "/Users/franksimpson/"
    fi
done

# Restore VS Code settings
if [ -e "$CONFIG_DIR/vscode-settings.json" ]; then
    echo "   Restoring VS Code settings..."
    mkdir -p "/Users/franksimpson/Library/Application Support/Code/User"
    cp "$CONFIG_DIR/vscode-settings.json" "/Users/franksimpson/Library/Application Support/Code/User/settings.json"
fi

# Restore Windsurf settings
if [ -e "$CONFIG_DIR/windsurf-settings.json" ]; then
    echo "   Restoring Windsurf settings..."
    mkdir -p "/Users/franksimpson/Library/Application Support/Windsurf/User"
    cp "$CONFIG_DIR/windsurf-settings.json" "/Users/franksimpson/Library/Application Support/Windsurf/User/settings.json"
fi

echo "✅ Configurations restored!"
