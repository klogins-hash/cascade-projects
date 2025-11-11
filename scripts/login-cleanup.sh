#!/bin/bash

# Login Cleanup Script
# Runs when you log in to clean up recent mess

# Only run if it's been more than 12 hours since last run
LAST_RUN_FILE="/Users/franksimpson/.last-login-cleanup"
RUN_INTERVAL=43200 # 12 hours in seconds

if [ -f "$LAST_RUN_FILE" ]; then
    last_run=$(cat "$LAST_RUN_FILE")
    current_time=$(date +%s)
    if [ $((current_time - last_run)) -lt $RUN_INTERVAL ]; then
        exit 0
    fi
fi

# Quick cleanup tasks
echo "🧹 Running login cleanup..."

# Clean recent cache files
find /Users/franksimpson/Library/Caches -type f -atime +1 -delete 2>/dev/null

# Clean recent temp files
find /tmp -name "tmp*" -atime +0 -delete 2>/dev/null

# Quick npm cache clean
if command -v npm &> /dev/null; then
    npm cache clean --force 2>/dev/null
fi

# Clean recent downloads
find /Users/franksimpson/Downloads -type f -atime +7 -delete 2>/dev/null

# Quick swap cleanup
find /Users/franksimpson -name "*.swp" -type f -exec rm -f {} \; 2>/dev/null
find /Users/franksimpson -name "*.swo" -type f -exec rm -f {} \; 2>/dev/null
find /Users/franksimpson -name "*~" -type f -exec rm -f {} \; 2>/dev/null

# Update last run time
date +%s > "$LAST_RUN_FILE"

echo "✅ Login cleanup completed"
