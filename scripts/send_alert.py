import os
import smtplib

from email.message import EmailMessage

config = {}

with open("/home/bchand/linux-server-health-monitor/config.env") as f:
    for line in f:
        line = line.strip()

        if not line or "=" not in line:
            continue

        
        key, value = line.strip().split("=", 1)
        config[key] = value

SENDER_EMAIL = config["SENDER_EMAIL"]
APP_PASSWORD = config["APP_PASSWORD"]
RECEIVER_EMAIL = config["RECEIVER_EMAIL"]


msg = EmailMessage()
msg["Subject"] = "Linux Server Health Monitor Alert"
msg["From"] = SENDER_EMAIL
msg["To"] = RECEIVER_EMAIL

msg.set_content(""" 
ALERT GENERATED 
A warning condition was detected on your linux server. 
Please check the monitoring logs. 
- Linux Server Health Monitor
""")

try:
    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
        smtp.login(SENDER_EMAIL, APP_PASSWORD)
        smtp.send_message(msg)

    print("Email sent successfully")


except Exception as e:
    print("Error:", e)
