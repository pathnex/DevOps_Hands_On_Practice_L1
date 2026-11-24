# Day 15 — Java, S3 Bucket, CronJob, File Reader

## 🔹 Ansible — Install Java & Set JAVA_HOME
- name: Install Java on Pathnex Server
  hosts: all
  become: yes

  tasks:
    - name: Install OpenJDK
      yum:
        name: java-11-openjdk
        state: present 
    - name: Find Java installation path
      command: readlink -f /usr/bin/java
      register: java_path
      changed_when: false

    - name: Set JAVA_HOME
      lineinfile:
        path: /etc/profile
        line: "export JAVA_HOME={{ java_path.stdout | regex_replace('/bin/java$', '') }}"

## 🔹 Terraform — Create S3 Bucket

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "PathnexBucket"{
    bucket = "pathnex-devops-bucket"
    tags = {
      Name = "PathnexBucket"
    }
}

## 🔹 Kubernetes — CronJob
apiVersion: batch/v1
kind: CronJOb
metadata:
  name: pathnex-cron
spec:
  schedule: "*/5 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            -name: job
            image: busybox
            command: ["sh", "-c", "echo Pathnex CronJob running"]
          restartPolicy: OnFailure


## 🔹 Shell Script — Read File Line-by-Line

#!/bin/bash

FILE="/etc/passwd"

while IFS=  read -r line; do
  echo "Line: $line"
done < "$FILE"

# Advanced Notifications

## 🔹 Jenkins Pipeline — Slack Notification
You will learn how to **send Slack notifications after build success or failure**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
        SLACK_CHANNEL = "#devops"
    }
    stages {
        stage('Checkout') {
          steps {
            git url: 'https://github.com/Pathnex/sample-java-app.git'
          }
        }
        stage('Build'){
          steps {
            sh 'mvn clean package'
          }
        }
    }
    post {
        success {
            slackSend(channel: "$SLACK_CHANNEL", message: "SUCCESS: $INSTITUTE_NAME Build #${env.BUILD_NUMBER}")
        }
        failure {
            slackSend(channel: "$SLACK_CHANNEL", message: "FAILURE: $INSTITUTE_NAME Build #${env.BUILD_NUMBER}")
        }
    }
}

## 🔹 GitLab CI — Slack Notification

You will learn how to **notify Slack in GitLab CI**.

stages:
  - build

variables:
  INSTITUTE_NAME: "Pathnex"

build:
  stage: build
  image: maven:3.8.1-jdk-17
  script:
    - git clone https://github.com/Pathnex/sample-java-app.git
    - cd sample-java-app
    - mvn clean package
    - curl -X POST -H 'Content-type: application/json' \ --data '{\"text\":\"Build success for $INSTITUTE_NAME\"}" \ "$SLACK_WEBHOOK"
