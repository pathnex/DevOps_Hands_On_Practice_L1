# Day 18 — Facts, Variables, Affinity, Log Archiving

## 🔹 Ansible — Use Ansible Facts

---
- name: Show system facts for Pathnex
  hosts: all

  tasks:
    - name: Print OS info
      debug:
        var: ansible_facts['os_family']

    - name: Print IP address
      debug:
        var: ansible_facts['default_ipv4']['address']


## 🔹 Terraform — Variables, Outputs, tfvars

# variables.tf
variable "instance_type" {
  default = "t3.micro"
}

# main.tf
resource "aws_instance" "pathnex_server" {
  ami           = ""ami-0912f71e06545ad88"
  instance_type = var.instance_type
}

# outputs.tf
output "pathnex_ip" {
  value = aws_instance.pathnex_server.public_ip
}


## 🔹 Kubernetes — Node Affinity

apiVersion: v1
kind: Pod
metadata:
  name: pathnex-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: disktype
                operator: In
                values:
                  - ssd
  containers:
    - name: web
      image: nginx


## 🔹 Shell Script — Archive Log Files

#!/bin/bash

set -e

mkdir -p /backup

tar -czf /backup/pathnex-logs-$(date +%F).tar.gz /var/log/

echo "Logs archived successfully."

# Rollback Simulation

## 🔹 Jenkins Pipeline — Rollback on Failure
pipeline {
    agent any

    environment {
        INSTITUTE_NAME = "Pathnex"
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    try {
                        sh 'echo "Deploying $INSTITUTE_NAME application..."'
                        sh 'exit 1'
                    } catch (Exception e) {
                        echo "Deployment failed. Rolling back ${env.INSTITUTE_NAME} application..."
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
    }
}

## 🔹 GitLab CI — Rollback Simulation
stages:
  - deploy

variables:
  INSTITUTE_NAME: "Pathnex"

deploy:
  stage: deploy
  image: alpine:latest

  script:
    - echo "Deploying $INSTITUTE_NAME application..."
    - exit 1

  after_script:
    - |
      if [ "$CI_JOB_STATUS" = "failed" ]; then
        echo "Deployment failed. Rolling back $INSTITUTE_NAME application..."
      fi
