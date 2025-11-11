#!/bin/bash

# Swap Files Cleanup Script
# Aggressively cleans all swap files and memory pressure

echo "🧹 Swap Files Cleanup: $(date)"

# Function to clean swap files safely
clean_swap_files() {
    local swap_cleaned=0
    local space_freed=0
    
    echo "🔍 Scanning for swap files..."
    
    # Clean user swap files in common locations
    local swap_locations=(
        "/Users/franksimpson"
        "/Users/franksimpson/Library"
        "/Users/franksimpson/Documents"
        "/Users/franksimpson/Desktop"
        "/Users/franksimpson/Downloads"
        "/Users/franksimpson/CascadeProjects"
        "/tmp"
        "/var/tmp"
    )
    
    for location in "${swap_locations[@]}"; do
        if [ -d "$location" ]; then
            # Find and remove swap files
            find "$location" -name "*.swp" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name "*.swo" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name "*.swn" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name ".*.swp" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name ".*.swo" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name ".*.swn" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name "*~" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name ".#*" -type f -exec rm -f {} \; 2>/dev/null
            find "$location" -name "#*#" -type f -exec rm -f {} \; 2>/dev/null
            
            # Clean vim/emacs swap directories
            find "$location" -type d -name ".vim-swap" -exec rm -rf {} \; 2>/dev/null
            find "$location" -type d -name ".emacs.d/auto-save-list" -exec rm -rf {} \; 2>/dev/null
        fi
    done
    
    # Clean VS Code swap files
    if [ -d "/Users/franksimpson/Library/Application Support/Code/User/workspaceStorage" ]; then
        find "/Users/franksimpson/Library/Application Support/Code/User/workspaceStorage" -name "*.swp" -type f -exec rm -f {} \; 2>/dev/null
    fi
    
    # Clean Windsurf swap files
    if [ -d "/Users/franksimpson/Library/Application Support/Windsurf" ]; then
        find "/Users/franksimpson/Library/Application Support/Windsurf" -name "*.swp" -type f -exec rm -f {} \; 2>/dev/null
    fi
    
    # Clean system swap files (requires sudo for some)
    echo "🗑️  Cleaning system swap files..."
    
    # Clean sleepimage if it exists and system is not sleeping
    if [ -f "/private/var/vm/sleepimage" ]; then
        # Check if system is awake
        if pmset -g | grep -q "sleepstate"; then
            echo "   🗑️  Removing sleepimage..."
            sudo rm -f /private/var/vm/sleepimage 2>/dev/null || echo "   ⚠️  Could not remove sleepimage (need sudo)"
        fi
    fi
    
    # Clean swap files in /private/var/vm
    find /private/var/vm -name "swapfile*" -type f -exec rm -f {} \; 2>/dev/null
    
    # Force memory pressure relief
    echo "💾 Applying memory pressure relief..."
    sudo purge 2>/dev/null || echo "   ⚠️  Could not purge memory (need sudo)"
    
    echo "✅ Swap files cleanup completed"
}

# Function to get memory pressure
get_memory_pressure() {
    if command -v memory_pressure &> /dev/null; then
        memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | sed 's/%//'
    else
        echo "N/A"
    fi
}

# Main execution
memory_before=$(get_memory_pressure)
echo "💾 Memory pressure before: ${memory_before}%"

clean_swap_files

memory_after=$(get_memory_pressure)
echo "💾 Memory pressure after: ${memory_after}%"

# Count remaining swap files
remaining_swaps=$(find /Users/franksimpson -name "*.swp" -o -name "*.swo" -o -name "*.swn" -o -name "*~" 2>/dev/null | wc -l | tr -d ' ')
echo "📊 Remaining swap files: $remaining_swaps"

if [ "$remaining_swaps" -eq 0 ]; then
    echo "🎉 All swap files cleaned!"
else
    echo "⚠️  $remaining_swaps swap files remain"
fi

echo ""
