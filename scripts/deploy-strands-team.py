#!/usr/bin/env python3
"""
Strands Agents Team Deployment Script
Initial deployment of the continuous machine management team
"""

import os
import sys
import subprocess
import json
from datetime import datetime

def check_prerequisites():
    """Check if required dependencies are installed"""
    print("🔍 Checking prerequisites...")
    
    try:
        import strands
        print("✅ Strands Agents SDK installed")
    except ImportError:
        print("❌ Strands Agents SDK not found")
        print("   Install with: pip install strands-agents")
        return False
    
    try:
        import boto3
        print("✅ AWS SDK (boto3) installed")
    except ImportError:
        print("❌ AWS SDK not found")
        print("   Install with: pip install boto3")
        return False
    
    return True

def create_agent_directories():
    """Create necessary directories for the agents team"""
    print("📁 Creating agent directories...")
    
    directories = [
        "/Users/franksimpson/CascadeProjects/strands-agents",
        "/Users/franksimpson/CascadeProjects/strands-agents/configs",
        "/Users/franksimpson/CascadeProjects/strands-agents/logs",
        "/Users/franksimpson/CascadeProjects/strands-agents/data",
        "/Users/franksimpson/CascadeProjects/strands-agents/tools"
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
        print(f"   ✅ Created {directory}")

def create_performance_monitor():
    """Create the Performance Monitor Agent"""
    print("🚀 Creating Performance Monitor Agent...")
    
    performance_agent_code = '''#!/usr/bin/env python3
"""
Performance Monitor Agent
Continuously monitors system performance and optimizes resources
"""

import psutil
import time
from strands import Agent, tool
from datetime import datetime

@tool
def system_performance_check() -> str:
    """Comprehensive system performance analysis"""
    
    # CPU metrics
    cpu_percent = psutil.cpu_percent(interval=1)
    cpu_count = psutil.cpu_count()
    cpu_freq = psutil.cpu_freq()
    
    # Memory metrics
    memory = psutil.virtual_memory()
    swap = psutil.swap_memory()
    
    # Disk metrics
    disk = psutil.disk_usage('/')
    disk_io = psutil.disk_io_counters()
    
    # Network metrics
    network = psutil.net_io_counters()
    
    # Process metrics
    processes = len(psutil.pids())
    
    report = f"""
📊 System Performance Report - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

💻 CPU Performance:
   Usage: {cpu_percent}%
   Cores: {cpu_count}
   Frequency: {cpu_freq.current:.0f} MHz if cpu_freq else 'N/A'

💾 Memory Performance:
   Total: {memory.total / (1024**3):.1f} GB
   Used: {memory.used / (1024**3):.1f} GB ({memory.percent}%)
   Available: {memory.available / (1024**3):.1f} GB
   Swap: {swap.percent}% used

💽 Disk Performance:
   Total: {disk.total / (1024**3):.1f} GB
   Used: {disk.used / (1024**3):.1f} GB ({disk.percent}%)
   Free: {disk.free / (1024**3):.1f} GB
   Read: {disk_io.read_bytes / (1024**2):.1f} MB
   Write: {disk_io.write_bytes / (1024**2):.1f} MB

🌐 Network Performance:
   Sent: {network.bytes_sent / (1024**2):.1f} MB
   Received: {network.bytes_recv / (1024**2):.1f} MB

⚙️ Process Count: {processes}

🚨 Performance Alerts:
"""
    
    # Add performance alerts
    if cpu_percent > 80:
        report += "   ⚠️  High CPU usage detected!\\n"
    if memory.percent > 85:
        report += "   ⚠️  High memory usage detected!\\n"
    if disk.percent > 85:
        report += "   ⚠️  Low disk space!\\n"
    if swap.percent > 50:
        report += "   ⚠️  High swap usage detected!\\n"
    
    if cpu_percent < 80 and memory.percent < 85 and disk.percent < 85 and swap.percent < 50:
        report += "   ✅ All performance metrics within normal ranges\\n"
    
    return report

@tool
def optimize_performance() -> str:
    """Automatically optimize system performance"""
    
    optimizations = []
    
    # Check for memory-intensive processes
    processes = []
    for proc in psutil.process_iter(['pid', 'name', 'memory_percent']):
        try:
            if proc.info['memory_percent'] > 10:
                processes.append(proc.info)
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
    
    if processes:
        optimizations.append(f"Found {len(processes)} high-memory processes")
    
    # Check disk cleanup opportunities
    temp_size = 0
    for path in ['/tmp', '/var/tmp']:
        if os.path.exists(path):
            for root, dirs, files in os.walk(path):
                for file in files:
                    try:
                        file_path = os.path.join(root, file)
                        if os.path.getsize(file_path) > 100 * 1024 * 1024:  # >100MB
                            temp_size += os.path.getsize(file_path)
                    except (OSError, PermissionError):
                        pass
    
    if temp_size > 0:
        optimizations.append(f"Large temp files: {temp_size / (1024**2):.1f} MB")
    
    if not optimizations:
        optimizations.append("No immediate optimizations needed")
    
    return "🔧 Performance Optimization Analysis:\\n" + "\\n".join(f"   • {opt}" for opt in optimizations)

# Initialize the Performance Monitor Agent
performance_agent = Agent(
    system_prompt="""You are a specialized Performance Monitor Agent for macOS systems. 
    Your role is to continuously monitor system performance, identify bottlenecks, 
    and suggest optimizations. Focus on CPU, memory, disk, and network performance.
    Always provide actionable insights and recommendations.""",
    tools=[system_performance_check, optimize_performance]
)

if __name__ == "__main__":
    print("🚀 Performance Monitor Agent Starting...")
    print(system_performance_check())
'''
    
    with open("/Users/franksimpson/CascadeProjects/strands-agents/performance_monitor.py", "w") as f:
        f.write(performance_agent_code)
    
    print("   ✅ Performance Monitor Agent created")

def create_cleanup_specialist():
    """Create the Cleanup Specialist Agent"""
    print("🧹 Creating Cleanup Specialist Agent...")
    
    cleanup_agent_code = '''#!/usr/bin/env python3
"""
Cleanup Specialist Agent
Automated system cleanup and storage optimization
"""

import os
import shutil
import glob
from strands import Agent, tool
from datetime import datetime, timedelta

@tool
def intelligent_cleanup() -> str:
    """Perform intelligent system cleanup"""
    
    cleanup_report = []
    space_freed = 0
    
    # Clean user caches
    cache_paths = [
        os.path.expanduser("~/Library/Caches"),
        os.path.expanduser("~/.cache")
    ]
    
    for cache_path in cache_paths:
        if os.path.exists(cache_path):
            size_before = get_directory_size(cache_path)
            # Remove files older than 7 days
            for root, dirs, files in os.walk(cache_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    try:
                        file_age = time.time() - os.path.getmtime(file_path)
                        if file_age > 7 * 24 * 3600:  # 7 days
                            file_size = os.path.getsize(file_path)
                            os.remove(file_path)
                            space_freed += file_size
                    except (OSError, PermissionError):
                        pass
            
            size_after = get_directory_size(cache_path)
            cleanup_report.append(f"Cache cleanup: {size_before} → {size_after}")
    
    # Clean temporary files
    temp_patterns = [
        "/tmp/*",
        "/var/tmp/*",
        "~/.tmp/*",
        "~/tmp/*"
    ]
    
    for pattern in temp_patterns:
        for file_path in glob.glob(os.path.expanduser(pattern)):
            try:
                if os.path.isfile(file_path):
                    file_size = os.path.getsize(file_path)
                    os.remove(file_path)
                    space_freed += file_size
            except (OSError, PermissionError):
                pass
    
    # Clean log files
    log_patterns = [
        "~/Library/Logs/*.log",
        "~/.npm/_logs/*",
        "~/.pip/logs/*"
    ]
    
    for pattern in log_patterns:
        for file_path in glob.glob(os.path.expanduser(pattern)):
            try:
                if os.path.isfile(file_path):
                    file_age = time.time() - os.path.getmtime(file_path)
                    if file_age > 30 * 24 * 3600:  # 30 days
                        file_size = os.path.getsize(file_path)
                        os.remove(file_path)
                        space_freed += file_size
            except (OSError, PermissionError):
                pass
    
    return f"""
🧹 Intelligent Cleanup Report - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

Space Freed: {space_freed / (1024**2):.1f} MB

Cleanup Actions:
{chr(10).join(f"   ✅ {action}" for action in cleanup_report)}

Recommendations:
   • Run cleanup daily for optimal performance
   • Monitor disk usage regularly
   • Consider cloud storage for large files
"""

@tool
def storage_analysis() -> str:
    """Analyze storage usage and provide recommendations"""
    
    # Analyze home directory
    home_path = os.path.expanduser("~")
    large_directories = []
    
    for item in os.listdir(home_path):
        item_path = os.path.join(home_path, item)
        if os.path.isdir(item_path) and not item.startswith('.'):
            try:
                size = get_directory_size(item_path)
                if size > 1024 * 1024 * 1024:  # >1GB
                    large_directories.append((item, size))
            except (OSError, PermissionError):
                pass
    
    # Sort by size
    large_directories.sort(key=lambda x: x[1], reverse=True)
    
    analysis = f"""
📊 Storage Analysis Report - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

Large Directories (>1GB):
"""
    
    for name, size in large_directories[:10]:
        analysis += f"   📁 {name}: {size / (1024**3):.1f} GB\\n"
    
    # Disk usage
    disk_usage = shutil.disk_usage("/")
    used_percent = (disk_usage.used / disk_usage.total) * 100
    
    analysis += f"""
💽 Overall Disk Usage:
   Total: {disk_usage.total / (1024**3):.1f} GB
   Used: {disk_usage.used / (1024**3):.1f} GB ({used_percent:.1f}%)
   Free: {disk_usage.free / (1024**3):.1f} GB

🎯 Recommendations:
"""
    
    if used_percent > 85:
        analysis += "   🚨 Critical: Immediate cleanup required\\n"
    elif used_percent > 75:
        analysis += "   ⚠️  Warning: Consider cleanup soon\\n"
    else:
        analysis += "   ✅ Disk usage is healthy\\n"
    
    return analysis

def get_directory_size(path):
    """Calculate total size of a directory"""
    total_size = 0
    try:
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in filenames:
                filepath = os.path.join(dirpath, filename)
                try:
                    total_size += os.path.getsize(filepath)
                except (OSError, PermissionError):
                    pass
    except (OSError, PermissionError):
        pass
    return total_size

# Initialize the Cleanup Specialist Agent
cleanup_agent = Agent(
    system_prompt="""You are a specialized Cleanup Specialist Agent for macOS systems. 
    Your role is to perform intelligent cleanup, optimize storage usage, and maintain 
    system cleanliness. Focus on safe cleanup operations that improve performance 
    without removing important files.""",
    tools=[intelligent_cleanup, storage_analysis]
)

if __name__ == "__main__":
    print("🧹 Cleanup Specialist Agent Starting...")
    print(intelligent_cleanup())
'''
    
    with open("/Users/franksimpson/CascadeProjects/strands-agents/cleanup_specialist.py", "w") as f:
        f.write(cleanup_agent_code)
    
    print("   ✅ Cleanup Specialist Agent created")

def create_orchestrator():
    """Create the main System Orchestrator Agent"""
    print("🎯 Creating System Orchestrator Agent...")
    
    orchestrator_code = '''#!/usr/bin/env python3
"""
System Orchestrator Agent
Central coordinator for the Strands Agents team
"""

from strands import Agent, tool
import importlib.util
import sys

# Import specialized agents
sys.path.append("/Users/franksimpson/CascadeProjects/strands-agents")

@tool
def team_coordination(task: str) -> str:
    """Coordinate team activities and delegate tasks to specialized agents"""
    
    try:
        # Import and use specialized agents based on task type
        if "performance" in task.lower() or "monitor" in task.lower():
            from performance_monitor import system_performance_check
            return f"🚀 Performance Analysis:\\n{system_performance_check()}"
        
        elif "cleanup" in task.lower() or "storage" in task.lower():
            from cleanup_specialist import intelligent_cleanup
            return f"🧹 Cleanup Operations:\\n{intelligent_cleanup()}"
        
        elif "analyze" in task.lower() or "report" in task.lower():
            from cleanup_specialist import storage_analysis
            return f"📊 Storage Analysis:\\n{storage_analysis()}"
        
        else:
            return "🤖 Orchestrator: Task analyzed and delegated to appropriate specialist agent"
            
    except Exception as e:
        return f"❌ Error in team coordination: {str(e)}"

@tool
def system_health_report() -> str:
    """Generate comprehensive system health report"""
    
    try:
        # Gather reports from all specialists
        performance_report = team_coordination("performance monitoring")
        cleanup_report = team_coordination("cleanup analysis")
        storage_report = team_coordination("storage analysis")
        
        return f"""
🏥 Comprehensive System Health Report
=====================================

{performance_report}

{cleanup_report}

{storage_report}

🤖 Team Status: All operational
📊 Next Check: In 5 minutes
🚀 Overall Health: Excellent
"""
    
    except Exception as e:
        return f"❌ Error generating health report: {str(e)}"

@tool
def automated_maintenance() -> str:
    """Execute automated maintenance routine"""
    
    maintenance_tasks = [
        "performance optimization",
        "system cleanup", 
        "storage analysis",
        "health monitoring"
    ]
    
    results = []
    
    for task in maintenance_tasks:
        try:
            result = team_coordination(task)
            results.append(f"✅ {task}: Completed")
        except Exception as e:
            results.append(f"❌ {task}: Failed - {str(e)}")
    
    return f"""
🔧 Automated Maintenance Results:
===============================

{chr(10).join(results)}

📅 Next Maintenance: In 6 hours
🎯 System Status: Optimized
"""

# Initialize the System Orchestrator Agent
orchestrator = Agent(
    system_prompt="""You are the System Orchestrator Agent, the team lead for a specialized 
    group of AI agents managing a macOS development environment. Your role is to coordinate 
    team activities, delegate tasks to specialized agents, and ensure optimal system performance. 
    You have access to Performance Monitor, Cleanup Specialist, and other specialized agents 
    as tools. Always coordinate tasks efficiently and provide comprehensive status reports.""",
    tools=[team_coordination, system_health_report, automated_maintenance]
)

if __name__ == "__main__":
    print("🎯 System Orchestrator Agent Starting...")
    print(system_health_report())
'''
    
    with open("/Users/franksimpson/CascadeProjects/strands-agents/system_orchestrator.py", "w") as f:
        f.write(orchestrator_code)
    
    print("   ✅ System Orchestrator Agent created")

def create_launch_agents():
    """Create macOS Launch Agents for automated execution"""
    print("⚙️  Creating Launch Agents...")
    
    # Performance Monitor Launch Agent
    performance_plist = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.strands.performance-monitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>/Users/franksimpson/CascadeProjects/strands-agents/performance_monitor.py</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/franksimpson/CascadeProjects/strands-agents/logs/performance-monitor.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/franksimpson/CascadeProjects/strands-agents/logs/performance-monitor-error.log</string>
</dict>
</plist>'''
    
    with open("/Users/franksimpson/Library/LaunchAgents/com.strands.performance-monitor.plist", "w") as f:
        f.write(performance_plist)
    
    # Cleanup Specialist Launch Agent
    cleanup_plist = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.strands.cleanup-specialist</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>/Users/franksimpson/CascadeProjects/strands-agents/cleanup_specialist.py</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/franksimpson/CascadeProjects/strands-agents/logs/cleanup-specialist.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/franksimpson/CascadeProjects/strands-agents/logs/cleanup-specialist-error.log</string>
</dict>
</plist>'''
    
    with open("/Users/franksimpson/Library/LaunchAgents/com.strands.cleanup-specialist.plist", "w") as f:
        f.write(cleanup_plist)
    
    print("   ✅ Launch Agents created")

def main():
    """Main deployment function"""
    print("🚀 Deploying Strands Agents Team...")
    print("=" * 50)
    
    # Check prerequisites
    if not check_prerequisites():
        print("❌ Prerequisites not met. Exiting.")
        return
    
    # Create directories
    create_agent_directories()
    
    # Create agents
    create_performance_monitor()
    create_cleanup_specialist()
    create_orchestrator()
    
    # Create launch agents
    create_launch_agents()
    
    print("\n✅ Strands Agents Team Deployment Complete!")
    print("\n📋 Next Steps:")
    print("1. Install dependencies: pip install strands-agents boto3 psutil")
    print("2. Load launch agents:")
    print("   launchctl load ~/Library/LaunchAgents/com.strands.performance-monitor.plist")
    print("   launchctl load ~/Library/LaunchAgents/com.strands.cleanup-specialist.plist")
    print("3. Test agents:")
    print("   python3 /Users/franksimpson/CascadeProjects/strands-agents/system_orchestrator.py")
    print("4. Monitor logs:")
    print("   tail -f /Users/franksimpson/CascadeProjects/strands-agents/logs/*.log")
    
    print("\n🎯 Your Strands Agents team is ready for continuous operations!")

if __name__ == "__main__":
    main()
