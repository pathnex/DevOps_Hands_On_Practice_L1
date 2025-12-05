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
  default = "c6a.12xlarge"
}

# main.tf
resource "aws_instance" "PathnexServer" {
  ami           = "ami-0abcd1234abcd1234"
  instance_type = var.instance_type
}

# output
output "pathnex_ip" {
  value = aws_instance.PathnexServer.public_ip
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

tar -czf /backup/pathnex-logs-$(date +%F).tar.gz /var/log/
echo "Logs archived."


# Rollback Simulation

## 🔹 Jenkins Pipeline — Rollback on Failure
You will learn how to **simulate rollback if deployment fails**.

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
                        sh 'exit 1' // simulate failure
                    } catch (Exception e) {
                        echo "Deployment failed. Rolling back $INSTITUTE_NAME application..."
                    }
                }
            }
        }
    }
}

## 🔹 GitLab CI — Rollback Simulation
You will learn how to **simulate rollback using after_script**.

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
    - echo "Deployment failed. Rolling back $INSTITUTE_NAME application..."
