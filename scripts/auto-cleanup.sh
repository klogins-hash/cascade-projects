#!/bin/bash

# Automated Cleanup Script
# Runs automatically to keep system clean

LOG_FILE="/Users/franksimpson/.auto-cleanup.log"
CASCADE_DIR="/Users/franksimpson/CascadeProjects"

echo "🤖 Auto Cleanup Started: $(date)" >> "$LOG_FILE"

# Function to log cleanup action
log_cleanup() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Quick daily cleanup tasks
log_cleanup "Starting daily cleanup..."

# Clean user caches (keep recent stuff)
find /Users/franksimpson/Library/Caches -type f -atime +7 -delete 2>/dev/null
log_cleanup "Cleaned old cache files"

# Clean temporary files
find /tmp -name "tmp*" -atime +1 -delete 2>/dev/null
find /var/tmp -name "tmp*" -atime +1 -delete 2>/dev/null
log_cleanup "Cleaned temporary files"

# Clean npm cache (keep it small)
if command -v npm &> /dev/null; then
    npm cache clean --force 2>/dev/null
    log_cleanup "Cleaned npm cache"
fi

# Clean pip cache
if command -v pip &> /dev/null; then
    pip cache purge 2>/dev/null
    log_cleanup "Cleaned pip cache"
fi

# Empty trash if it's getting large
if [ -d ~/.Trash ]; then
    trash_size=$(du -sm ~/.Trash 2>/dev/null | cut -f1)
    if [ "$trash_size" -gt 500 ]; then
        rm -rf ~/.Trash/* 2>/dev/null
        log_cleanup "Emptied trash (${trash_size}MB)"
    fi
fi

# Clean old downloads (older than 30 days)
find /Users/franksimpson/Downloads -type f -atime +30 -delete 2>/dev/null
log_cleanup "Cleaned old downloads"

# Clean log files (keep recent ones)
find /Users/franksimpson/Library/Logs -name "*.log" -size +10M -delete 2>/dev/null
log_cleanup "Cleaned large log files"

# Clean VS Code workspace storage (keep only recent)
find "/Users/franksimpson/Library/Application Support/Code/User/workspaceStorage" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null
log_cleanup "Cleaned VS Code workspace storage"

# Clean swap files (aggressive)
/Users/franksimpson/CascadeProjects/scripts/swap-cleanup.sh &>> "$LOG_FILE"
log_cleanup "Cleaned swap files"

# Check disk space and log it
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
log_cleanup "Disk usage: ${disk_usage}%"

# If disk usage is high, run more aggressive cleanup
if [ "$disk_usage" -gt 85 ]; then
    log_cleanup "High disk usage detected, running aggressive cleanup..."
    
    # Clean development caches aggressively
    rm -rf ~/.cache/* 2>/dev/null
    rm -rf ~/.local/share/* 2>/dev/null
    
    # Clean browser caches
    rm -rf ~/Library/Caches/com.google.Chrome/* 2>/dev/null
    rm -rf ~/Library/Caches/org.mozilla.firefox/* 2>/dev/null
    rm -rf ~/Library/Caches/com.apple.Safari/* 2>/dev/null
    
    log_cleanup "Aggressive cleanup completed"
fi

log_cleanup "Auto cleanup completed successfully"
echo "" >> "$LOG_FILE"

# Keep log file from getting too large
if [ -f "$LOG_FILE" ]; then
    log_lines=$(wc -l < "$LOG_FILE")
    if [ "$log_lines" -gt 1000 ]; then
        tail -500 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
        log_cleanup "Trimmed log file"
    fi
fi
