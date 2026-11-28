# Day 23 — Tags, EIP, HPA, Kill Process

## 🔹 Ansible — Add Tags to Users
- name: Create users with comments
  hosts: all
  become: yes

  tasks:
    - name: Create Pathnex user
      user:
        name: devuser
        comment: "Pathnex Developer User"
      tags:
        - users


## 🔹 Terraform — Elastic IP

resource "aws_eip" "PathnexEIP" {
  domain   = "vpc"
  instance = aws_instance.PathnexEC2.id

  tags = {
    Name = "Pathnex-EIP"
  }
}


## 🔹 Kubernetes — Horizontal Pod Autoscaler (HPA)
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: pathnex-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: pathnex-deploy
  minReplicas: 2
  maxReplicas: 6
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50


## 🔹 Shell Script — Kill High CPU Process

#!/bin/bash
PROCESS=$(ps -eo pid,comm,%cpu --sort=-%cpu | awk 'NR==2')

PID=$(echo "$PROCESS" | awk '{print $1}')
NAME=$(echo "$PROCESS" | awk '{print $2}')
CPU=$(echo "$PROCESS" | awk '{print $3}')

echo "Process: $NAME"
echo "PID: $PID"
echo "CPU Usage: $CPU%"

if awk -v cpu="$CPU" 'BEGIN {exit !(cpu >= 80)}'; then
    echo "WARNING: High CPU usage detected"
    kill -TERM "$PID"
    echo "Termination signal sent"
else
    echo "CPU usage is normal"
fi

# Docker Integration

## 🔹 Jenkins Pipeline — Build Docker Image
You will learn how to **build and tag Docker images** with proper labels.
pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
        TEAM = "DevOps"
        ENV = "staging"
        PROJECT = "WebApp"
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t pathnex/webapp:${ENV}-${BUILD_NUMBER} \
                    --label "INSTITUTE_NAME=$INSTITUTE_NAME" \
                    --label "TEAM=$TEAM" \
                    --label "ENV=$ENV" \
                    --label "PROJECT=$PROJECT" .
                '''
            }
        }
    }
}

## 🔹 GitLab CI — Build Docker Image
You will learn how to **build Docker images in GitLab CI**.

stages:
  - docker-build
variables:
  INSTITUTE_NAME: "Pathnex"
  TEAM: "DevOps"
  ENV: "staging"
  PROJECT: "WebApp"
  DOCKER_HOST: "tcp://docker:2375"
  DOCKER_TLS_CERTDIR: ""
docker-build:
  stage: docker-build
  image: docker:cli
  services:
    - name: docker:dind
      alias: docker
  script:
    - |
      docker build \
        -t pathnex/webapp:${ENV}-${CI_PIPELINE_ID} \
        --label "INSTITUTE_NAME=$INSTITUTE_NAME" \
        --label "TEAM=$TEAM" \
        --label "ENV=$ENV" \
        --label "PROJECT=$PROJECT" .