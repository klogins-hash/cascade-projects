# Strands Agents Team - Quick Start Guide

## 🎯 What This Team Does

Your Strands Agents team provides **24/7 automated machine management**:

- **Performance Monitor Agent** - Runs every 5 minutes to optimize CPU, memory, disk, and network performance
- **Cleanup Specialist Agent** - Runs every hour to clean caches, temp files, and optimize storage
- **System Orchestrator Agent** - Coordinates all agents and provides comprehensive health reports
- **Security Guardian Agent** - Monitors permissions and security (coming in Phase 2)
- **Automation Engineer Agent** - Maintains and optimizes automation scripts (coming in Phase 2)

## 🚀 Quick Deployment

### 1. Install Dependencies
```bash
pip install strands-agents boto3 psutil
```

### 2. Deploy the Team
```bash
cd /Users/franksimpson/CascadeProjects
python3 scripts/deploy-strands-team.py
```

### 3. Start Automated Operations
```bash
# Load the launch agents
launchctl load ~/Library/LaunchAgents/com.strands.performance-monitor.plist
launchctl load ~/Library/LaunchAgents/com.strands.cleanup-specialist.plist

# Verify they're running
launchctl list | grep strands
```

### 4. Test the Team
```bash
# Test the orchestrator
python3 strands-agents/system_orchestrator.py

# Check logs
tail -f strands-agents/logs/performance-monitor.log
tail -f strands-agents/logs/cleanup-specialist.log
```

## 📊 What to Expect

### **Immediate Benefits (Day 1)**
- Real-time performance monitoring every 5 minutes
- Automated cleanup every hour
- Comprehensive system health reports
- Intelligent alerts for performance issues

### **Week 1 Benefits**
- Optimized disk space usage
- Improved system responsiveness
- Reduced manual maintenance
- Predictive performance insights

### **Month 1 Benefits**
- Self-healing capabilities
- Zero-touch system management
- Advanced optimization recommendations
- Complete automation of routine tasks

## 🛠️ Management Commands

```bash
# Check team status
launchctl list | grep strands

# View performance reports
tail -20 ~/CascadeProjects/strands-agents/logs/performance-monitor.log

# View cleanup reports
tail -20 ~/CascadeProjects/strands-agents/logs/cleanup-specialist.log

# Get comprehensive health report
python3 ~/CascadeProjects/strands-agents/system_orchestrator.py

# Stop the team
launchctl unload ~/Library/LaunchAgents/com.strands.performance-monitor.plist
launchctl unload ~/Library/LaunchAgents/com.strands.cleanup-specialist.plist

# Restart the team
launchctl load ~/Library/LaunchAgents/com.strands.performance-monitor.plist
launchctl load ~/Library/LaunchAgents/com.strands.cleanup-specialist.plist
```

## 📈 Monitoring & Alerts

### **Performance Alerts**
- CPU usage >80% → Automatic optimization suggestions
- Memory pressure >85% → Cleanup and optimization
- Disk usage >85% → Aggressive cleanup and storage analysis
- Network issues → Connectivity diagnostics

### **Automated Reports**
- **Every 5 minutes**: Performance metrics
- **Every hour**: Cleanup operations
- **On demand**: Comprehensive health analysis

### **Log Locations**
- Performance logs: `~/CascadeProjects/strands-agents/logs/performance-monitor.log`
- Cleanup logs: `~/CascadeProjects/strands-agents/logs/cleanup-specialist.log`
- Error logs: `~/CascadeProjects/strands-agents/logs/*-error.log`

## 🔧 Customization

### **Adjust Monitoring Frequency**
Edit the plist files in `~/Library/LaunchAgents/`:
- Change `StartInterval` value (in seconds)
- 300 = 5 minutes, 600 = 10 minutes, 3600 = 1 hour

### **Add Custom Tools**
1. Create new tool functions in agent files
2. Add to agent's tools list
3. Restart the affected launch agent

### **Configure Alerts**
Edit the agent Python files to customize:
- Alert thresholds
- Notification methods
- Report formats

## 🎯 Advanced Features (Coming Soon)

### **Phase 2 - Security & Automation**
- Security Guardian Agent for permission monitoring
- Automation Engineer Agent for script maintenance
- Integration with your existing cleanup system
- Advanced threat detection

### **Phase 3 - Intelligence & Prediction**
- Machine learning for performance prediction
- Self-healing capabilities
- Advanced optimization algorithms
- Integration with cloud services

### **Phase 4 - Full Autonomy**
- Complete zero-touch management
- Predictive maintenance
- Automated system updates
- Cross-system coordination

## 🔍 Troubleshooting

### **Agents Not Running**
```bash
# Check launch agent status
launchctl list | grep strands

# Reload if needed
launchctl unload ~/Library/LaunchAgents/com.strands.performance-monitor.plist
launchctl load ~/Library/LaunchAgents/com.strands.performance-monitor.plist
```

### **High Resource Usage**
```bash
# Check agent logs for issues
tail -50 ~/CascadeProjects/strands-agents/logs/*-error.log

# Adjust monitoring frequency
# Edit StartInterval in plist files
```

### **Missing Dependencies**
```bash
# Install missing packages
pip install strands-agents boto3 psutil

# Verify installation
python3 -c "import strands; print('Strands Agents SDK ready')"
```

## 🎉 Success Metrics

Your Strands Agents team is successful when:
- ✅ System uptime >99.9%
- ✅ Performance issues detected and resolved automatically
- ✅ Disk usage maintained <80%
- ✅ Zero manual intervention for routine tasks
- ✅ Proactive optimization recommendations provided

## 📞 Support

- **Documentation**: `~/CascadeProjects/config/strands-team-operations.md`
- **Logs**: `~/CascadeProjects/strands-agents/logs/`
- **Configuration**: `~/CascadeProjects/strands-agents/configs/`

---

**Your Strands Agents team is ready to transform your machine into a self-maintaining, self-optimizing system! 🚀**
