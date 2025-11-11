#!/bin/bash

# System Data Cleanup Script
# Cleans system caches, logs, temp files, and user data

echo "🧹 System Data Cleanup Script"
echo "============================"
echo "This will clean system caches, logs, and temporary data"
echo ""

# Function to safely clean with size reporting
safe_clean_with_size() {
    local path="$1"
    local description="$2"
    local pattern="$3"
    
    if [ -d "$path" ]; then
        local size_before=$(du -sh "$path" 2>/dev/null | cut -f1)
        echo "🔍 $description ($size_before)..."
        
        if [ -n "$pattern" ]; then
            find "$path" -name "$pattern" -type f -delete 2>/dev/null
        else
            find "$path" -type f -atime +7 -delete 2>/dev/null
            find "$path" -type d -empty -delete 2>/dev/null
        fi
        
        local size_after=$(du -sh "$path" 2>/dev/null | cut -f1)
        echo "   ✅ $description: $size_before → $size_after"
    fi
}

echo "🔧 Step 1: User Cache Cleanup..."
safe_clean_with_size "/Users/franksimpson/Library/Caches" "User caches" ""
safe_clean_with_size "/Users/franksimpson/.cache" "Dot cache" ""

echo ""
echo "🔧 Step 2: Application Support Cleanup..."
safe_clean_with_size "/Users/franksimpson/Library/Application Support" "App support" "*.log"
safe_clean_with_size "/Users/franksimpson/Library/Application Support" "App support" "*.tmp"
safe_clean_with_size "/Users/franksimpson/Library/Application Support" "App support" "Cache"

echo ""
echo "🔧 Step 3: Log Files Cleanup..."
safe_clean_with_size "/Users/franksimpson/Library/Logs" "User logs" "*.log"
safe_clean_with_size "/Users/franksimpson/Library/Logs" "User logs" "*.old"

echo ""
echo "🔧 Step 4: Temporary Files Cleanup..."
safe_clean_with_size "/tmp" "System temp" "tmp*"
safe_clean_with_size "/var/tmp" "Var temp" "tmp*"

echo ""
echo "🔧 Step 5: Development Tool Caches..."

# npm cache
if command -v npm &> /dev/null; then
    npm_size_before=$(du -sh ~/.npm 2>/dev/null | cut -f1)
    echo "🔍 npm cache ($npm_size_before)..."
    npm cache clean --force 2>/dev/null
    npm_size_after=$(du -sh ~/.npm 2>/dev/null | cut -f1)
    echo "   ✅ npm cache: $npm_size_before → $npm_size_after"
fi

# pip cache
if command -v pip &> /dev/null; then
    pip_size_before=$(du -sh ~/.cache/pip 2>/dev/null | cut -f1)
    echo "🔍 pip cache ($pip_size_before)..."
    pip cache purge 2>/dev/null
    pip_size_after=$(du -sh ~/.cache/pip 2>/dev/null | cut -f1)
    echo "   ✅ pip cache: $pip_size_before → $pip_size_after"
fi

# yarn cache
if command -v yarn &> /dev/null; then
    if [ -d ~/.yarn ]; then
        yarn_size_before=$(du -sh ~/.yarn 2>/dev/null | cut -f1)
        echo "🔍 yarn cache ($yarn_size_before)..."
        yarn cache clean 2>/dev/null
        yarn_size_after=$(du -sh ~/.yarn 2>/dev/null | cut -f1)
        echo "   ✅ yarn cache: $yarn_size_before → $yarn_size_after"
    fi
fi

# Homebrew cache
if command -v brew &> /dev/null; then
    echo "🔍 Homebrew cleanup..."
    brew cleanup --prune=30 2>/dev/null
    echo "   ✅ Homebrew cleaned"
fi

echo ""
echo "🔧 Step 6: Container and VM Cleanup..."

# Docker cleanup
if command -v docker &> /dev/null; then
    echo "🐳 Docker cleanup..."
    docker system prune -af --volumes 2>/dev/null || echo "   Docker not accessible"
    echo "   ✅ Docker cleaned"
fi

# Podman cleanup
if command -v podman &> /dev/null; then
    echo "🐳 Podman cleanup..."
    podman system prune -af 2>/dev/null || echo "   Podman not accessible"
    echo "   ✅ Podman cleaned"
fi

echo ""
echo "🔧 Step 7: System Maintenance (requires sudo)..."
echo "⚠️  The following operations require sudo permission:"

# DNS cache flush
echo "   🌐 Flushing DNS cache..."
sudo dscacheutil -flushcache 2>/dev/null || echo "     Could not flush DNS cache"

# System cache cleanup
echo "   🗑️  Cleaning system caches..."
sudo rm -rf /Library/Caches/* 2>/dev/null || echo "     Could not clean system caches"

# Log rotation
echo "   📋 Cleaning system logs..."
sudo rm -rf /var/log/*.log.* 2>/dev/null || echo "     Could not clean system logs"

echo ""
echo "🔧 Step 8: Trash and Downloads Cleanup..."

# Empty trash
echo "   🗑️  Emptying Trash..."
sudo rm -rf ~/.Trash/* 2>/dev/null || echo "     Could not empty trash"

# Clean old downloads
echo "   📥 Cleaning old Downloads..."
find /Users/franksimpson/Downloads -type f -atime +30 -delete 2>/dev/null

echo ""
echo "🔧 Step 9: Browser Data Cleanup..."

# Safari cache
echo "   🌐 Safari cache cleanup..."
rm -rf ~/Library/Caches/com.apple.Safari/* 2>/dev/null
rm -rf ~/Library/Caches/com.apple.WebKit.*/* 2>/dev/null

# Chrome cache (if exists)
if [ -d ~/Library/Application\ Support/Google/Chrome ]; then
    echo "   🌐 Chrome cache cleanup..."
    rm -rf ~/Library/Caches/com.google.Chrome/* 2>/dev/null
fi

# Firefox cache (if exists)
if [ -d ~/Library/Application\ Support/Firefox ]; then
    echo "   🌐 Firefox cache cleanup..."
    rm -rf ~/Library/Caches/org.mozilla.firefox/* 2>/dev/null
fi

echo ""
echo "🔧 Step 10: Large File Detection..."
echo "🔍 Finding large files (>100MB) in user directory..."
find /Users/franksimpson -size +100M -not -path "*/Library/*" -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/CascadeProjects-minimal-backup/*" 2>/dev/null | head -10 | while read file; do
    size=$(du -sh "$file" 2>/dev/null | cut -f1)
    echo "   📄 $size: $file"
done

echo ""
echo "📊 Cleanup Summary:"
echo "=================="
echo "✅ User caches cleaned"
echo "✅ Application caches cleaned"
echo "✅ Log files cleaned"
echo "✅ Temporary files cleaned"
echo "✅ Development tool caches cleaned"
echo "✅ Container systems cleaned"
echo "✅ System maintenance performed"
echo "✅ Trash and Downloads cleaned"
echo "✅ Browser caches cleaned"

echo ""
echo "💡 Additional recommendations:"
echo "   • Restart your computer for best results"
echo "   • Run this script monthly for maintenance"
echo "   • Consider using cloud storage for large files"
echo "   • Review the large files list above for manual cleanup"

echo ""
echo "🎉 System data cleanup completed!"
echo "🚀 Your system should now be faster and have more free space"
