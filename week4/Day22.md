# Day 22 — Handlers, Security Group, DaemonSet, Disk Monitor

## 🔹 Ansible — Use Handler on Config Change
- name: Configure Nginx for Pathnex
  hosts: all
  become: yes

  tasks:
    - name: Install Nginx
      package:
        name: nginx
        state: present

    - name: Copy Nginx config
      copy:
        dest: /etc/nginx/conf.d/pathnex.conf
        content: |
          server {
            listen 8080;
            server_name localhost;

            location / {
              return 200 "Pathnex Nginx is running";
            }
          }
      notify: Restart nginx

  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted


## 🔹 Terraform — Security Group
resource "aws_security_group" "pathnex_sg" {
  name   = "pathnex-sg"
  vpc_id = aws_vpc.PathnexVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Pathnex-SG"
  }
}


## 🔹 Kubernetes — DaemonSet
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: pathnex-daemon
spec:
  selector:
    matchLabels:
      app: ds
  template:
    metadata:
      labels:
        app: ds
    spec:
      containers:
        - name: monitor
          image: busybox:1.36
          command:
            - sh
            - -c
            - while true; do echo Pathnex Node Monitor; sleep 20; done


## 🔹 Shell Script — Monitor Disk Usage
#!/bin/bash

USAGE=$(df -P / | tail -1 | awk '{print $5}' | tr -d '%')

echo "Disk Usage: ${USAGE}%"

if [ "$USAGE" -ge 80 ]; then
    echo "WARNING: Disk usage is above 80%"
else
    echo "Disk usage is normal"
fi

# Advanced Triggers
## 🔹 Jenkins Pipeline — Trigger on Git Tag
You will learn how to **trigger builds on Git tags** with realistic tags.

pipeline {
    agent any

    environment {
        INSTITUTE_NAME = "Pathnex"
        TEAM = "DevOps"
        ENV = "prod"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            when {
                buildingTag()
            }

            steps {
                sh 'echo "Building $INSTITUTE_NAME app for $TEAM team in $ENV environment"'
            }
        }
    }
}

## 🔹 GitLab CI — Trigger on Tag
stages:
  - build

variables:
  INSTITUTE_NAME: "Pathnex"
  TEAM: "DevOps"
  ENV: "prod"

build:
  stage: build

  image: maven:3.8.1-jdk-17

  script:
    - echo "Building $INSTITUTE_NAME app for $TEAM team in $ENV environment"
    - mvn clean package

  rules:
    - if: '$CI_COMMIT_TAG'
