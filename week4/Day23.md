# Day 23 — Tags, EIP, HPA, Kill Process

## 🔹 Ansible — Add Tags to Users

---
- name: Create users with comments
  hosts: all
  become: yes

  tasks:
    - name: Create Pathnex user
      user:
        name: devuser
        comment: "Pathnex Developer User"


## 🔹 Terraform — Elastic IP

resource "aws_eip" "PathnexEIP" {
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

PID=$(ps aux --sort=-%cpu | awk 'NR==2{print $2}')

echo "Killing process: $PID"
kill -9 $PID

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

docker-build:
  stage: docker-build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t pathnex/webapp:${ENV}-${CI_PIPELINE_ID} \
      --label "INSTITUTE_NAME=$INSTITUTE_NAME" \
      --label "TEAM=$TEAM" \
      --label "ENV=$ENV" \
      --label "PROJECT=$PROJECT" .
