#!/bin/bash

# Cleanup Monitor Script
# Monitors cleanup effectiveness and system health

echo "📊 Cleanup Monitor Report"
echo "======================="
echo "Generated: $(date)"
echo ""

# Get current disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}')
echo "💾 Current disk usage: $disk_usage"

# Show cache sizes
echo ""
echo "📁 Cache Sizes:"
echo "   Library Caches: $(du -sh ~/Library/Caches 2>/dev/null | cut -f1)"
echo "   Dot Cache: $(du -sh ~/.cache 2>/dev/null | cut -f1)"
echo "   npm Cache: $(du -sh ~/.npm 2>/dev/null | cut -f1)"
echo "   pip Cache: $(du -sh ~/.cache/pip 2>/dev/null | cut -f1)"

# Show log sizes
echo ""
echo "📋 Log Sizes:"
echo "   Auto Cleanup Log: $(du -sh ~/.auto-cleanup.log 2>/dev/null | cut -f1)"
echo "   System Logs: $(du -sh ~/Library/Logs 2>/dev/null | cut -f1)"

# Show recent cleanup activity
echo ""
echo "🕐 Recent Cleanup Activity:"
if [ -f ~/.auto-cleanup.log ]; then
    echo "   Last cleanup: $(tail -1 ~/.auto-cleanup.log | grep -o '\[.*\]' | head -1)"
    echo "   Cleanups today: $(grep "$(date '+%Y-%m-%d')" ~/.auto-cleanup.log | wc -l | tr -d ' ')"
fi

# Show swap files status
echo ""
echo "🔄 Swap Files Status:"
swap_count=$(find /Users/franksimpson -name "*.swp" -o -name "*.swo" -o -name "*.swn" -o -name "*~" 2>/dev/null | wc -l | tr -d ' ')
echo "   Swap files found: $swap_count"
if [ -f ~/.swap-cleanup.log ]; then
    echo "   Last swap cleanup: $(tail -1 ~/.swap-cleanup.log 2>/dev/null | grep -o '.*:' | head -1)"
fi

# Show large files warning
echo ""
echo "⚠️  Large Files (>100MB):"
find /Users/franksimpson -size +100M -not -path "*/Library/*" -not -path "*/.git/*" -not -path "*/node_modules/*" 2>/dev/null | wc -l | xargs echo "   Found:"

# Show automation status
echo ""
echo "🤖 Automation Status:"
if launchctl list | grep -q "com.user.autocleanup"; then
    echo "   ✅ Launch Agent: Running (every 6 hours)"
else
    echo "   ❌ Launch Agent: Not running"
fi

if launchctl list | grep -q "com.user.swapcleanup"; then
    echo "   ✅ Swap Cleanup: Running (daily at 3 AM)"
else
    echo "   ❌ Swap Cleanup: Not running"
fi

if crontab -l 2>/dev/null | grep -q "auto-cleanup.sh"; then
    echo "   ✅ Cron Job: Scheduled (daily at 2 AM)"
else
    echo "   ❌ Cron Job: Not scheduled"
fi

# Recommendations
echo ""
echo "💡 Recommendations:"
if [ "${disk_usage%?}" -gt 85 ]; then
    echo "   🚨 Disk usage is high - consider running 'clean-space-hogs'"
fi

if [ -f ~/.auto-cleanup.log ]; then
    recent_cleanups=$(grep "$(date '+%Y-%m-%d')" ~/.auto-cleanup.log | wc -l | tr -d ' ')
    if [ "$recent_cleanups" -lt 2 ]; then
        echo "   📅 Cleanup frequency seems low - check automation"
    fi
fi

echo ""
echo "🔧 Management Commands:"
echo "   auto-cleanup          - Run manual cleanup"
echo "   swap-cleanup          - Clean swap files manually"
echo "   clean-space-hogs     - Clean large space hogs"
echo "   system-data-cleanup  - Full system cleanup"
echo "   cleanup-monitor       - View this report"

echo ""
echo "📈 To disable automation:"
echo "   launchctl unload ~/Library/LaunchAgents/com.user.autocleanup.plist"
echo "   launchctl unload ~/Library/LaunchAgents/com.user.swapcleanup.plist"
echo "   crontab -e  # and remove the cleanup line"
