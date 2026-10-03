# Linux Server Health Monitor

A production-style Linux server monitoring solution built with **Bash, Python, Docker, Docker Compose, and AWS EC2**.

The system continuously monitors Linux server health, services, resources, logs, and operational state. It generates structured reports, sends HTML email alerts when health status changes, and runs automatically every five minutes through Docker Compose and Cron.

The containerized deployment is designed to monitor the **underlying Linux host**, not just the container itself.

---

## Features

### System Monitoring

- CPU utilization monitoring
- Memory utilization monitoring
- Disk utilization monitoring
- System uptime tracking
- Hostname detection
- Operating system detection
- Kernel information
- IP address detection
- Logged-in user monitoring
- Top memory-consuming processes

### Service Monitoring

- SSH service monitoring
- Cron service monitoring
- NetworkManager detection
- Service failure detection
- Service recovery detection
- Automatic detection of unavailable services
- Cross-distribution service compatibility

### Reporting & Logging

- Terminal health dashboard
- Structured health logs
- JSON health reports
- HTML email reports
- Alert logging
- Runtime state tracking
- Historical log retention
- Automated log rotation

### Intelligent Alerting

- State-based email notifications
- Duplicate alert suppression
- Recovery notifications
- Gmail SMTP integration
- Configurable monitoring thresholds
- Email failure handling

### Containerized Deployment

- Docker-based deployment
- Docker Compose orchestration
- Host PID namespace access
- Host network namespace
- Host filesystem monitoring
- Host systemd service monitoring
- Persistent log and report storage
- Automated container cleanup

### Automation

- Five-minute monitoring schedule
- Docker Compose Cron integration
- Automated installation
- Docker and Docker Compose validation
- Dynamic project path resolution
- AWS EC2 deployment

---

## Architecture

```text
                         AWS EC2
                    Amazon Linux 2023
                           │
                           ▼
                  Cron Scheduler
                   Every 5 Minutes
                           │
                           ▼
                 Docker Compose
                           │
                           ▼
              ┌────────────────────────┐
              │   Monitor Container    │
              │                        │
              │     monitor.sh         │
              │          │             │
              │     ┌────┴────┐        │
              │     │         │        │
              │   Bash      Python     │
              │ Monitoring  Alerts     │
              └──────┬─────────┬───────┘
                     │         │
                     │         ▼
                     │     Gmail SMTP
                     │
              Host-Level Access
                     │
        ┌────────────┼───────────────┐
        │            │               │
        ▼            ▼               ▼
      CPU /       Processes       Services
      Memory      Network         systemd
      Disk        OS Info         sshd
                                 crond
                           NetworkManager
        │
        ▼
   Persistent Data
        │
   ┌────┴─────┐
   ▼          ▼
 logs/      reports/
   │          │
   ▼          ▼
Health Logs  JSON Report
```

### Host Monitoring from Docker

The container is configured to access the host through:

| Configuration | Purpose |
|---|---|
| `pid: host` | Monitor host processes |
| `network_mode: host` | Access host networking |
| `/run:/run:ro` | Inspect host systemd |
| `/:/host:ro` | Access host filesystem information |
| `./logs:/app/logs` | Persist monitoring logs |
| `./reports:/app/reports` | Persist generated reports |
| `./config/config.env:/app/config/config.env:ro` | Provide email configuration |

This allows the containerized monitor to inspect the EC2 host rather than reporting only container-level information.

---

## Monitoring Workflow

```text
Cron Scheduler
      │
      ▼
Docker Compose
      │
      ▼
Start Monitor Container
      │
      ▼
Load Configuration
      │
      ▼
Collect Host Information
      │
      ▼
Monitor CPU / Memory / Disk
      │
      ▼
Check Configured Services
      │
      ▼
Generate JSON Report
      │
      ▼
Compare Previous State
      │
      ├───────────────┐
      │               │
      ▼               ▼
No State Change   State Changed
      │               │
      ▼               ▼
 Skip Email       Send Email
      │               │
      └───────┬───────┘
              ▼
        Update Logs
              │
              ▼
      Remove Container
```

---

## Intelligent Alerting

The monitor stores the previous overall health state in:

```text
logs/server_state.txt
```

An email is sent only when the overall state changes.

### Alert State Flow

```text
HEALTHY
    │
    │ threshold exceeded
    ▼
ATTENTION REQUIRED
    │
    │ same state
    ▼
No additional email
```

When the issue is resolved:

```text
ATTENTION REQUIRED
    │
    │ health restored
    ▼
HEALTHY
    │
    ▼
Recovery email
```

### Example

| Previous State | Current State | Email |
|---|---|---|
| HEALTHY | HEALTHY | No |
| HEALTHY | ATTENTION REQUIRED | Yes |
| ATTENTION REQUIRED | ATTENTION REQUIRED | No |
| ATTENTION REQUIRED | HEALTHY | Yes |

This prevents the system from sending the same alert every five minutes while an issue remains unresolved.

---

## Project Structure

```text
linux-server-health-monitor/
│
├── config/
│   ├── config.conf
│   └── config.env
│
├── logs/
│   ├── health_report.log
│   ├── alerts.log
│   └── server_state.txt
│
├── reports/
│   └── server_report.json
│
├── screenshots/
│
├── scripts/
│   ├── monitor.sh
│   ├── logger.sh
│   ├── utils.sh
│   └── send_alert.py
│
├── Dockerfile
├── compose.yaml
├── install.sh
├── .gitignore
└── README.md
```

### Important Files

| File | Purpose |
|---|---|
| `monitor.sh` | Main monitoring engine |
| `utils.sh` | System information and metric collection |
| `logger.sh` | Logging and terminal formatting |
| `send_alert.py` | HTML email generation and SMTP delivery |
| `config.conf` | Monitoring thresholds and services |
| `config.env` | Email credentials |
| `Dockerfile` | Container image definition |
| `compose.yaml` | Docker Compose configuration |
| `install.sh` | Automated installation and Cron configuration |

> `config/config.env`, runtime logs, runtime state, and generated reports are excluded from version control where applicable.

---

## Technologies Used

| Technology | Purpose |
|---|---|
| Linux | Operating system monitoring |
| Bash | Monitoring and automation |
| Python 3 | Email alert processing |
| Docker | Containerization |
| Docker Compose | Container orchestration |
| AWS EC2 | Cloud deployment |
| Cron | Scheduled execution |
| JSON | Health report generation |
| HTML/CSS | Email dashboard |
| Gmail SMTP | Email notifications |
| Git | Version control |
| GitHub | Source code hosting |

---

## Supported Platforms

The monitoring logic has been tested with:

- Rocky Linux 9
- Amazon Linux 2023

The project uses dynamic path resolution and automatically handles services that are unavailable on a particular distribution.

For example, if `NetworkManager` is not installed, the monitor reports:

```text
NetworkManager    NOT INSTALLED
```

instead of treating the missing service as a monitoring failure.

---

## Prerequisites

Before installation, ensure the system has:

- Linux
- Bash
- Python 3
- Docker
- Docker Compose
- Cron

The installer automatically validates these dependencies.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/seshapubharath/linux-server-health-monitor.git
cd linux-server-health-monitor
```

Make the installer executable:

```bash
chmod +x install.sh
```

Run the installer:

```bash
./install.sh
```

The installer validates:

- Linux
- Bash
- Python
- Docker
- Docker Compose
- Cron
- Required project files

It also:

- Creates required directories
- Creates required log files
- Creates the email configuration template if required
- Applies executable permissions
- Configures the Docker Compose Cron job
- Verifies the installation

---

## Configuration

### Monitoring Configuration

Edit:

```text
config/config.conf
```

The configuration contains monitoring thresholds and the services to monitor.

Typical configuration values include:

```text
CPU_THRESHOLD
MEMORY_THRESHOLD
DISK_THRESHOLD
SERVICES
```

### Email Configuration

Create or edit:

```text
config/config.env
```

Example:

```env
SENDER_EMAIL=
APP_PASSWORD=
RECEIVER_EMAIL=
```

The file contains sensitive email credentials and must not be committed to Git.

The Docker Compose configuration mounts it into the container as read-only configuration.

---

## Docker Usage

### Build the Image

```bash
docker compose build
```

### Validate Compose Configuration

```bash
docker compose config
```

### Run the Monitor Manually

```bash
docker compose run --rm monitor
```

The monitor will:

1. Start a temporary container.
2. Access the host monitoring namespaces.
3. Collect CPU, memory, disk, process, network, OS, and service information.
4. Generate the health report.
5. Compare the previous health state.
6. Send an email if the state changed.
7. Write logs and reports to the host-mounted directories.
8. Remove the temporary container.

---

## Automated Monitoring

The installer configures Cron to run the Dockerized monitor every five minutes.

The resulting Cron job follows this structure:

```cron
*/5 * * * * cd /path/to/linux-server-health-monitor && /usr/bin/docker compose run --rm monitor >/dev/null 2>&1
```

The actual project path is determined dynamically by `install.sh`.

To view the configured Cron job:

```bash
crontab -l
```

---

## Logs & Reports

### Health Log

```text
logs/health_report.log
```

Contains detailed monitoring output.

### Alert Log

```text
logs/alerts.log
```

Contains alert-related events.

### Server State

```text
logs/server_state.txt
```

Stores the previous overall health state.

### JSON Report

```text
reports/server_report.json
```

Contains structured server health information.

Example:

```json
{
  "hostname": "server-hostname",
  "os": "Amazon Linux 2023",
  "kernel": "6.x.x",
  "ip": "172.x.x.x",
  "overall_status": "HEALTHY",
  "resources": {
    "cpu": {
      "usage": 2,
      "status": "HEALTHY"
    },
    "memory": {
      "usage": 60,
      "status": "HEALTHY"
    },
    "disk": {
      "usage": 52,
      "status": "HEALTHY"
    }
  }
}
```

---

## Log Rotation

The monitor automatically rotates logs to prevent unlimited log growth.

The system maintains the active monitoring log along with historical rotated logs.

This helps prevent monitoring logs from continuously consuming disk space.

---

## Sample Output

```text
======================================================================
                    LINUX SERVER HEALTH MONITOR
======================================================================

Hostname : ip-172-31-x-x
OS       : Amazon Linux 2023
Kernel   : 6.x.x
IP       : 172.x.x.x

======================================================================
                           SERVICES
======================================================================

SERVICE                   STATUS
sshd                      RUNNING
crond                     RUNNING
NetworkManager            NOT INSTALLED

======================================================================
                   RESOURCE SUMMARY
======================================================================

RESOURCE             USAGE           STATUS
CPU                  2%              HEALTHY
Memory               60%             HEALTHY
Disk                 52%             HEALTHY

======================================================================

Overall Status : HEALTHY

No status change. Email notification skipped.
```

---

## Email Alerts

When the overall server status changes, the monitor generates an HTML email containing:

- Server information
- Overall health status
- CPU status
- Memory status
- Disk status
- Service status
- Relevant recommendations
- Timestamp

Example transition:

```text
HEALTHY
   ↓
Memory threshold exceeded
   ↓
ATTENTION REQUIRED
   ↓
HTML alert email
```

When the condition is resolved:

```text
ATTENTION REQUIRED
   ↓
Memory returns below threshold
   ↓
HEALTHY
   ↓
Recovery email
```

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

### Service Warning

![Service Warning](screenshots/services_warning.png)

### Service Failure Alert

![Service Failure Alert](screenshots/Crond_Alerts.png)

### Email Sent Successfully

![Email Sent Successfully](screenshots/Email_sent_successfully.png)

### Email Alert Received

![Email Alert](screenshots/Email_Received.png)

### Email Alert Content

![Email Content](screenshots/Email_contents.png)

### Email Alert Example

![Email Content](screenshots/Email2.png)

### Recovery Email

![Email Content](screenshots/Email_Ok.png)

![Email Content](screenshots/email_ok2.png)

### AWS EC2 Deployment

![AWS EC2](screenshots/AWS_DEPLOYEMENT.png)

---

## Version History

| Version | Feature |
|---|---|
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
| V10.4 | State-Based Intelligent Alerting |
| V10.5 | AWS EC2 Deployment |
| V10.5.1 | Cross-Platform Service Detection & Deployment Stabilization |
| V10.6.0 | Docker Containerization, Docker Compose & Host-Level Monitoring |

---

## Release History

### V10.5.1

- Improved AWS deployment
- Replaced hardcoded paths with dynamic `BASE_DIR`
- Improved cross-platform compatibility
- Added automatic detection of unavailable services
- Improved installer reliability
- Refactored project for production deployment

### V10.6.0

- Added Docker containerization
- Added Docker Compose deployment
- Added host-level monitoring from within the container
- Added host PID namespace access
- Added host network access
- Added host filesystem monitoring
- Added host `/run` access for systemd service monitoring
- Updated Cron automation to use Docker Compose
- Added Docker validation to installer
- Added Docker Compose validation to installer
- Added `Dockerfile`
- Added `compose.yaml`
- Preserved persistent logs and reports through volume mounts
- Improved deployment portability
- Added containerized EC2 monitoring workflow

---

## Skills Demonstrated

- Linux System Administration
- Bash Scripting
- Python Automation
- Infrastructure Monitoring
- Docker
- Docker Compose
- Containerized Linux Monitoring
- AWS EC2
- Cron Automation
- Systemd Service Monitoring
- JSON Reporting
- State Management
- SMTP Email Integration
- Cross-Platform Scripting
- Git & GitHub
- Production Deployment Automation

---

## Future Enhancements

- GitHub Actions CI/CD
- Multi-server monitoring
- Slack / Microsoft Teams notifications
- Web dashboard
- REST API integration
- Prometheus exporter
- Grafana dashboard
- AWS CloudWatch integration

---

## Project Metrics

- 4 Modular Scripts
- 10+ Monitoring Features
- 3 Configured Service Checks
- JSON-Based Reporting
- HTML Email Dashboard
- Intelligent State-Based Alerting
- Automated Recovery Notifications
- Docker Containerized Deployment
- Docker Compose Automation
- Cron-Based Monitoring
- Gmail SMTP Integration
- AWS EC2 Deployment
- Modular Linux Monitoring Architecture

---

## Author

**Bharath Chand Seshapu**

MCA Graduate | Linux Administrator Aspirant | RHCSA Learner | Cloud & DevOps Enthusiast

---

## Repository

[GitHub Repository](https://github.com/seshapubharath/linux-server-health-monitor)
