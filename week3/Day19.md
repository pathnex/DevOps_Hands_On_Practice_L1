# Day 19 — Git Deploy, RDS Skeleton, Rolling Strategy, Ping Check

## 🔹 Ansible — Deploy App Using Git

---
- name: Deploy app from Git for Pathnex
  hosts: all
  become: yes

  tasks:
    - name: Install git
      yum:
        name: git
        state: present

    - name: Clone repository
      git:
        repo: "https://github.com/pathnex/app.git"
        dest: "/opt/pathnex-app"
        update: yes
        force: yes

## 🔹 Terraform — RDS Skeleton (MySQL)

resource "aws_db_instance" "pathnex_rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               =  var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = false
}


variable "db_password" {
  type      = string
  sensitive = true
}

## 🔹 Kubernetes — Deployment Rolling Update (Detailed)

apiVersion: apps/v1
kind: Deployment
metadata:
  name: pathnex-rollout
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  selector:
    matchLabels:
      app: rollout
  template:
    metadata:
      labels:
        app: rollout
    spec:
      containers:
        - name: app
          image: nginx



## 🔹 Shell Script — Check Internet Connectivity

#!/bin/bash

if ping -c 2 -W 2 google.com >/dev/null 2>&1; then
    echo "Internet is available"
else
    echo "No internet connection"
fi

# Approvals

## 🔹 Jenkins Pipeline — Manual Approval
You will learn how to **pause pipeline until manual approval**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Deploy') {
            steps {
                input message: "Approve deployment for $INSTITUTE_NAME?"
                sh 'echo "Deployment approved and executed!"'
            }
        }
    }
}

## 🔹 GitLab CI — Manual Approval Job
You will learn how to **use manual jobs in GitLab CI for approvals**.

stages:
  - deploy

variables:
  INSTITUTE_NAME: "Pathnex"

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Ready to deploy $INSTITUTE_NAME"
  when: manual
