# Day 26 — Packages + Services, R53 Record, InitContainer, Status Script

## 🔹 Ansible — Install + Start Multiple Services
- name: Insatll and enable services
  hosts: all
  become: yes
  tasks:
    - name: Install services 
      yum:
        name:
          - httpd
          - firewalld
        state: present
    - name: Enable and start services
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      loop:
        - httpd
        - firewalld

## 🔹 Terraform — Route53 Record

resource "aws_route53_record" "PathnexRecord" {
  zone_id = "Z1234567890"
  name    = "app.pathnex.com"
  type    = "A"
  ttl     = 300
  records = [aws_eip.PathnexEIP.public_ip]
}

## 🔹 Kubernetes — Init Container

apiVersion: v1
kind: Pod
metadata:
  name: pathnex-init
spec:
  initContainers:
    - name: setup
      image: busybox
      command: ["sh", "-c", "echo Initializing; sleep 10"]
  containers:
    - name: main
      image: nginx


## 🔹 Shell Script — System Status

#!/bin/bash
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime)"
echo "IP: $(hostname -I)"

# GitLab Dynamic Environments

## 🔹 Jenkins Pipeline — Deploy to Dynamic Environment
You will learn how to **simulate deployment to dynamic environments with tags**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
        TEAM = "DevOps"
    }
    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Deployment Environment')
    }
    stages {
        stage('Deploy') {
            steps {
                sh 'echo "Deploying $INSTITUTE_NAME app to $ENVIRONMENT for $TEAM team"'
            }
        }
    }
}

## 🔹 GitLab CI — Dynamic Environment Deployment
You will learn how to **use GitLab dynamic environment names with realistic tags**.

stages:
  - deploy

variables:
  INSTITUTE_NAME: "Pathnex"
  TEAM: "DevOps"

deploy:
  stage: deploy
  image: alpine:latest

  environment:
    name: $CI_COMMIT_REF_SLUG
    url: "http://$CI_COMMIT_REF_SLUG.pathnex.com"

  script:
    - echo "Deploying $INSTITUTE_NAME app to $CI_COMMIT_REF_SLUG for $TEAM team"
