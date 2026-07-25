# Linux Server Health Monitor

## Overview

Linux Server Health Monitor is a modular server monitoring solution built using Bash and Python that automates Linux health checks, service monitoring, incident detection, and intelligent email alerting.

The project follows a production-inspired architecture by separating data collection from presentation. Bash collects system metrics and generates structured JSON reports, while Python converts the collected data into professional HTML email dashboards delivered through Gmail SMTP.

The monitoring system implements **state-aware alerting**, ensuring notifications are sent only when the server health changes, preventing alert fatigue and duplicate notifications during scheduled monitoring.

The project demonstrates Linux system administration, automation, monitoring, alerting, logging, incident detection, JSON data processing, and operational reporting practices commonly used in DevOps and Site Reliability Engineering (SRE).
---

## Project Highlights

- Automated Linux Server Health Monitoring
- Modular Bash Architecture
- JSON-Based Monitoring Reports
- Professional HTML Email Dashboard
- Intelligent State-Based Alerting
- Service Availability Monitoring
- Incident Detection & Recovery Notifications
- Cron-Based Scheduled Execution
- Log Rotation & Retention
- Gmail SMTP Email Notifications
- Secure Credential Management
- Git Version Controlled Development

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

- Automated health report generation
- JSON report generation
- Historical report storage
- HTML dashboard generation
- Alert logging
- Incident tracking
- Health status classification (HEALTHY / WARNING)

### Automation & Alerting

- Cron-based scheduled execution
- Automated incident detection
- Intelligent state-based alerting
- Recovery notification emails
- HTML email dashboard generation
- Gmail SMTP email notifications
- Secure credential management using config.env
- Duplicate alert prevention

### Intelligent Alert Management

The monitoring system maintains the previous server health state and sends notifications **only when the server status changes**.

This prevents duplicate alerts during scheduled monitoring while ensuring administrators receive notifications whenever the server enters or recovers from an unhealthy state.

State transitions include:

- HEALTHY → ATTENTION REQUIRED
- ATTENTION REQUIRED → HEALTHY
- HEALTHY → WARNING
- WARNING → HEALTHY
- Service Failure Detection
- Service Recovery Detection

  
### Log Rotation
* Automated log rotation
* Log retention management

---

## Technologies Used

- Linux (Rocky Linux / RHEL)
- Bash Scripting
- Python 3
- JSON
- HTML & CSS
- Gmail SMTP
- Cron
- Git
- GitHub

---

## Project Structure

```text
linux-server-health-monitor/

├── config.conf
├── config.env
├── README.md
├── .gitignore

├── logs/
│   ├── health_report.log
│   ├── alerts.log
│   └── server_state.txt

├── reports/
│   └── server_report.json

├── screenshots/

└── scripts/
    ├── monitor.sh
    ├── logger.sh
    ├── utils.sh
    └── send_alert.py
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
          Evaluate Resource Health
                      │
                      ▼
          Generate server_report.json
                      │
                      ▼
          Compare Previous State
                      │
         ┌────────────┴────────────┐
         │                         │
    No Change               Status Changed
         │                         │
         ▼                         ▼
 Skip Notification        Generate HTML Dashboard
                                   │
                                   ▼
                          Send Email Notification
                                   │
                                   ▼
                      Update server_state.txt
```

## Intelligent Alert Flow

```text
Cron Scheduler (Every 5 Minutes)

          │

          ▼

Collect Server Metrics

          │

          ▼

Determine Overall Health

          │

          ▼

Read Previous Status

          │

          ▼

Status Changed?

     ┌───────────────┐

   No │               │ Yes

      ▼               ▼

 Skip Email      Generate Alert

                     │

                     ▼

          Send HTML Email Report

                     │

                     ▼

        Update Previous State File
```

## Sample Output

The monitoring solution generates:

- Interactive terminal health dashboard
- JSON monitoring report
- Professional HTML email dashboard
- Historical monitoring logs
- Alert logs
- Intelligent state-based email notifications
- Recovery acknowledgement emails
- Service status summary
- Overall health assessment
---


## Architecture

```text
                Linux Server

                     │
                     ▼

            monitor.sh (Bash)

     ┌──────────────┼──────────────┐
     ▼              ▼              ▼

 Terminal       health_report.log   server_report.json

                                      │

                                      ▼

                          send_alert.py (Python)

                                      │

                                      ▼

                        HTML Email Dashboard

                                      │

                                      ▼

                           Gmail SMTP Server

                                      │

                                      ▼

                                 Administrator
```


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

### Email Alert(Critical) Content

![Email Content](screenshots/Email_contents.png)

![Email Content](screenshots/Email2.png) 

### Email Alert(OK) Content

![Email Content](screenshots/Email_Ok.png)

![Email Content](screenshots/email_ok2.png)




---

## Current Version

**Latest Release:** V10.0

### Completed Milestones

| Version | Feature |
|----------|----------------------------------------------|
| V1 | Basic Server Monitoring |
| V2 | Report Logging |
| V3 | Memory & Disk Monitoring |
| V4 | CPU Monitoring |
| V5 | Overall Health Summary |
| V6 | Cron Automation |
| V7 | Service Monitoring |
| V8 | Incident Logging |
| V9 | Gmail SMTP Alerts |
| V9.1 | Enhanced Email Content |
| V10 | Log Rotation |
| V10.1 | Modular Bash Architecture |
| V10.2 | JSON Report Generation |
| V10.3 | HTML Dashboard Email |
| **V10.4** | **State-Based Intelligent Alerting** |

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

### V10 - Log Rotation & Retention

- Added automated log rotation
- Prevents excessive log growth
- Maintains historical log archives
- Added rotation activity logging

### Version 10.4

- Implemented intelligent state-aware alerting
- Added server_state.txt for previous status tracking
- Prevented duplicate email notifications
- Added automatic recovery notifications
- Alert emails are triggered only on health state transitions
- Reduced notification noise during cron-based monitoring
- Improved monitoring workflow to match enterprise monitoring practices

---

## Skills Demonstrated

- Linux Administration
- Bash Scripting
- Python Automation
- JSON Data Processing
- HTML Email Generation
- Linux Service Management
- State-Based Alerting
- Incident Detection
- Recovery Notification
- System Monitoring
- Cron Automation
- SMTP Email Integration
- Log Rotation
- Production Logging
- Shell Script Modularization
- Git Version Control
---

## Future Enhancements

- Docker Container Support
- Multi-Server Monitoring
- AWS EC2 Deployment
- Configuration Dashboard
- Slack / Microsoft Teams Notifications
- REST API Integration
- Web Dashboard
- Grafana Visualization
- Prometheus Exporter
- Kubernetes Deployment
- Alert Escalation Policies
- Persistent Database for Alert History

---

## Project Metrics

- 4 Modular Scripts
- 10+ Monitoring Features
- 3 Critical Services Monitored
- JSON-Based Reporting
- HTML Email Dashboard
- Intelligent State-Based Alerting
- Automated Recovery Notifications
- Cron-Based Automation
- Gmail SMTP Integration
- Modular Linux Monitoring Architecture

  
## Author

**Bharath Chand Seshapu**

MCA Graduate | Linux Administrator Aspirant | RHCSA Learner | Cloud & DevOps Enthusiast

