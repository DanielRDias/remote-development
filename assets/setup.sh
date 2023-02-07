#!/bin/bash

echo "@@@ Start setup.sh @@@"

# Update
yum update -y

## Install CW agent, set proxy and configure logs to send
yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
systemctl enable amazon-cloudwatch-agent

cat << EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
    "debug": false
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
            "log_group_name": "remote-dev-${application}-${username}",
            "log_stream_name": "amazon-cloudwatch-agent.log",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "remote-dev-${application}-${username}",
            "log_stream_name": "cloud-init-output.log",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "remote-dev-${application}-${username}",
            "log_stream_name": "messages",
            "timezone": "UTC"
          }
        ]
      }
    },
    "log_stream_name": "{instance_id}",
    "force_flush_interval" : 15
  }
}
EOF

systemctl start amazon-cloudwatch-agent

echo "@@@ End setup.sh @@@"
