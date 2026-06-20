# Linux Server Health Monitor

## Overview

Linux Server Health Monitor is a Linux administration project developed using Bash and Python to automate the monitoring of critical server health metrics. The solution continuously monitors CPU, memory, disk usage, and critical system services while generating detailed reports, incident logs, and automated email notifications for proactive system administration.

The project demonstrates real-world Linux system monitoring, automation, incident detection, alert management, cron scheduling, and SMTP-based email notifications commonly used in production environments.

---

## Project Highlights

* Automated Linux Server Health Monitoring
* Cron-Based Scheduled Execution
* Service Availability Monitoring
* Incident Logging and Tracking
* Gmail SMTP Email Notifications
* Secure Credential Management
* Git Version Controlled Development

---

## Key Features

### System Monitoring

* CPU utilization monitoring
* Memory utilization monitoring
* Disk utilization monitoring
* System uptime tracking
* Hostname information collection
* Logged-in user monitoring
* Top memory-consuming process tracking

### Service Monitoring

* SSH service monitoring
* Cron service monitoring
* NetworkManager monitoring
* Service failure detection
* Critical service health checks

### Logging & Reporting

* Automated health report generation
* Historical report storage
* Alert logging
* Incident tracking
* Health status classification (HEALTHY / WARNING)

### Automation & Alerting

* Cron-based scheduled execution
* Automated incident detection
* Gmail SMTP email notifications
* Detailed health alert emails
* Secure credential management using config.env

---

## Technologies Used

* Linux (RHEL 9)
* Bash Scripting
* Python 3
* Cron
* Gmail SMTP
* Git
* GitHub

---

## Project Structure

```text
linux-server-health-monitor/
├── logs/
│   ├── health_report.log
│   └── alerts.log
├── screenshots/
├── scripts/
│   ├── monitor.sh
│   └── send_alert.py
├── config.env          # Ignored by Git
├── .gitignore
└── README.md
```

---

## Monitoring Workflow

```text
monitor.sh
     │
     ▼
Collect System Metrics
     │
     ▼
Evaluate Health Status
     │
     ▼
Generate Health Report
     │
     ▼
Write to health_report.log
     │
     ▼
Check Critical Services
     │
     ▼
ATTENTION REQUIRED?
     │
 ┌───┴────┐
 │        │
No       Yes
 │        │
 ▼        ▼
End    Generate Alert
             │
             ▼
      Write alerts.log
             │
             ▼
      Send Email Alert
```

---

## Sample Output

The monitoring script generates a detailed server health report containing:

* CPU Usage and Status
* Memory Usage and Status
* Disk Usage and Status
* Service Status
* Logged-in Users
* Top Processes by Memory Consumption
* System Uptime
* Hostname Information
* Overall Server Health Summary

---

## Screenshots

### Monitoring Report

![Monitor Output](screenshots/monitor_output.png)

### Git Commit History

![Git History](screenshots/Git_History.png)

### Healthy Server

![Healthy Server](screenshots/server_no_attention_required.png)

### Attention Required

![Attention Required](screenshots/server_attention_required_case.png)

### Services Running

![Services Running](screenshots/services_Running.png)

### Attention Required (Service Warning)

![Service Warning](screenshots/services_warning.png)

### Service Failure Alert

![Service Failure Alert](screenshots/Crond_Alerts.png)

### Email Sent Successfully

![Email Sent Successfully](screenshots/Email_sent_successfully.png)

### Email Alert Received

![Email Alert](screenshots/Email_Received.png)

### Email Alert Content

![Email Content](screenshots/Email_Content.png)

---

## Current Version

**Latest Release:** V9.1

### Completed Milestones

| Version | Feature                         |
| ------- | ------------------------------- |
| V1      | Basic Server Monitoring         |
| V2      | Report Logging                  |
| V3      | Memory & Disk Health Checks     |
| V4      | CPU Monitoring                  |
| V5      | Overall Health Summary          |
| V6      | Cron Automation                 |
| V7      | Service Monitoring              |
| V8      | Alert Engine & Incident Logging |
| V9      | Gmail SMTP Email Notifications  |
| V9.1    | Enhanced Email Alert Content    |

---

## Release History

### Version 1.0

* Basic server monitoring
* Hostname information
* System uptime monitoring
* User session monitoring
* Process monitoring

### Version 2.0

* Report logging functionality
* Health report persistence

### Version 3.0

* Memory utilization monitoring
* Disk utilization monitoring
* Threshold-based health checks

### Version 4.0

* CPU utilization monitoring
* CPU health status reporting

### Version 5.0

* Overall server health summary
* Consolidated CPU, Memory, and Disk status reporting
* ATTENTION REQUIRED / HEALTHY status classification

### Version 6.0

* Cron-based automation
* Automated report generation
* Scheduled execution every 5 minutes

### Version 7.0

* Critical service monitoring
* SSHD monitoring
* Cron monitoring
* NetworkManager monitoring
* Service health integration

### Version 8.0

* Alert engine implementation
* Incident logging
* Failed service tracking
* alerts.log generation

### Version 9.0

* Gmail SMTP integration
* Automated email notifications
* Secure credential management using config.env

### Version 9.1

* Enhanced email alert content
* Detailed health summary emails
* Failed service information included in alerts
* Professional email formatting

---

## Skills Demonstrated

* Linux Administration
* Bash Scripting
* Python Automation
* System Monitoring
* Service Monitoring
* Cron Scheduling
* Email Alerting (SMTP)
* Incident Response
* Log Management
* Troubleshooting
* Git Version Control
* System Health Assessment

---

## Future Enhancements

* Log Rotation & Retention
* AWS EC2 Deployment
* Multi-Server Monitoring
* Custom Threshold Configuration
* Configuration File Based Thresholds
* Slack / Teams Notifications
* Web Dashboard for Monitoring Reports
* Monitoring Metrics Visualization

---

## Author

**Bharath Chand Seshapu**

MCA Graduate | Linux Administrator Aspirant | RHCSA Learner | Cloud & DevOps Enthusiast

