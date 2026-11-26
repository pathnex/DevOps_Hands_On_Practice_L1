# Day 24 — Templates, ALB Listener, PV/PVC, Menu System

## 🔹 Ansible — Deploy Config Using Template

---
- name: Deploy Pathnex template
  hosts: all
  become: yes

  tasks:
    - name: Create config
      template:
        src: pathnex.conf.j2
        dest: /etc/pathnex.conf


## 🔹 Terraform — ALB Listener

resource "aws_lb_listener" "PathnexListener" {
  load_balancer_arn = aws_lb.PathnexALB.arn
  port              = 80  
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Pathnex ALB Running"
      status_code  = "200"
    }
  }
}


## 🔹 Kubernetes — PV + PVC

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pathnex-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  hostPath:
    path: /data/pathnex
    type: DirectoryOrCreate

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pathnex-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  resources:
    requests:
      storage: 500Mi


## 🔹 Shell Script — Menu Driven Program

#!/bin/bash

echo "1) Show date"
echo "2) Show uptime"
echo "3) Show users"

read -p "Choose option: " opt

case $opt in
  1) date ;;
  2) uptime ;;
  3) who ;;
  *) echo "Invalid choice" ;;
esac


# Automated Testing Pipeline

## 🔹 Jenkins Pipeline — Run Unit & Integration Tests
You will learn how to **run multiple test suites and tag reports**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
        TEAM = "QA"
        ENV = "dev"
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
        stage('Unit Test') {
            steps {
                sh 'mvn test -Dgroup=unit'
            }
        }
        stage('Integration Test') {
            steps {
                sh 'mvn verify -Dgroup=integration'
            }
        }
        stage('Report') {
            steps {
                sh 'echo "Tests completed for $INSTITUTE_NAME by $TEAM in $ENV environment"'
            }
        }
    }
}

## 🔹 GitLab CI — Run Tests
You will learn how to **run unit and integration tests in GitLab CI**.

stages:
  - unit
  - integration

variables:
  INSTITUTE_NAME: "Pathnex"
  TEAM: "QA"
  ENV: "dev"

unit-test:
  stage: unit
  image: maven:3.8.1-jdk-17
  script:
    - mvn test -Dgroup=unit
    - echo "Unit tests completed for $INSTITUTE_NAME by $TEAM in $ENV"

integration-test:
  stage: integration
  image: maven:3.8.1-jdk-17
  script:
    - mvn verify -Dgroup=integration
    - echo "Integration tests completed for $INSTITUTE_NAME by $TEAM in $ENV"
