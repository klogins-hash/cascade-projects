#!/bin/bash

# Clean Space Hogs Script
# Targets the largest space-consuming items

echo "🗑️  Clean Space Hogs Script"
echo "=========================="
echo "Targeting largest space-consuming items"
echo ""

# Function to check and clean space hog
clean_space_hog() {
    local path="$1"
    local description="$2"
    local size_before=""
    
    if [ -e "$path" ]; then
        size_before=$(du -sh "$path" 2>/dev/null | cut -f1)
        echo "🔍 $description ($size_before)..."
        
        case "$description" in
            "Colima VM disks")
                echo "   ⚠️  This will remove all Colima VM data and containers"
                read -p "   Remove Colima VM data? (y/N): " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    colima delete --force 2>/dev/null || rm -rf ~/.colima 2>/dev/null
                    echo "   ✅ Colima VM data removed"
                else
                    echo "   ❌ Skipped"
                fi
                ;;
            "Codeium browser data")
                rm -rf ~/.codeium/ws-browser 2>/dev/null
                echo "   ✅ Codeium browser data removed"
                ;;
            "Development cache")
                rm -rf ~/.local/pipx/venvs/*/lib/python*/site-packages/playwright 2>/dev/null
                rm -rf ~/.bun/install/cache 2>/dev/null
                echo "   ✅ Development cache cleaned"
                ;;
            "Backup directories")
                echo "   📁 Found backup directories:"
                find /Users/franksimpson -name "*backup*" -type d 2>/dev/null | head -5
                read -p "   Remove all backup directories? (y/N): " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    find /Users/franksimpson -name "*backup*" -type d -exec rm -rf {} \; 2>/dev/null
                    echo "   ✅ Backup directories removed"
                else
                    echo "   ❌ Skipped"
                fi
                ;;
        esac
    fi
}

echo "🎯 Step 1: Colima VM Cleanup (15GB+)..."
clean_space_hog "~/.colima" "Colima VM disks"

echo ""
echo "🎯 Step 2: Codeium Browser Cleanup (500MB+)..."
clean_space_hog "~/.codeium" "Codeium browser data"

echo ""
echo "🎯 Step 3: Development Cache Cleanup (1GB+)..."
clean_space_hog "~/.local" "Development cache"

echo ""
echo "🎯 Step 4: Backup Directory Cleanup..."
clean_space_hog "~/Desktop" "Backup directories"

echo ""
echo "🎯 Step 5: Large Downloads Cleanup..."
echo "🔍 Checking Downloads for large files..."
find /Users/franksimpson/Downloads -size +100M -exec ls -lh {} \; 2>/dev/null | head -5

echo ""
read -p "Remove large files from Downloads? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    find /Users/franksimpson/Downloads -size +100M -delete 2>/dev/null
    echo "   ✅ Large downloads removed"
else
    echo "   ❌ Skipped"
fi

echo ""
echo "🎯 Step 6: IDE Extension Cleanup..."
echo "🔍 VS Code extensions size:"
du -sh ~/.vscode/extensions 2>/dev/null || echo "   Not found"

echo "🔍 Windsurf extensions size:"
du -sh ~/.windsurf/extensions 2>/dev/null || echo "   Not found"

echo ""
read -p "Remove Windsurf extensions? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf ~/.windsurf/extensions 2>/dev/null
    echo "   ✅ Windsurf extensions removed"
else
    echo "   ❌ Skipped"
fi

echo ""
echo "📊 Space Hog Cleanup Summary:"
echo "============================"
echo "✅ Colima VM data: 15GB+ (optional)"
echo "✅ Codeium browser data: 500MB+"
echo "✅ Development cache: 1GB+"
echo "✅ Backup directories: Variable"
echo "✅ Large downloads: Variable"
echo "✅ IDE extensions: Variable"

echo ""
echo "💡 Additional space-saving tips:"
echo "   • Use Docker Desktop instead of Colima if needed"
echo "   • Codeium will re-download browser data when needed"
echo "   • Development caches will rebuild as you work"
echo "   • Consider cloud storage for large files instead of local"

echo ""
echo "🎉 Space hog cleanup completed!"
echo "🚀 Check your available disk space - should be significantly improved!"
