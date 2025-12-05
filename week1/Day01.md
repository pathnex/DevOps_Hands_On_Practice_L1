# Day 01 — Basics

## 🔹 Ansible Task — Install Nginx on Pathnex Server

Rewrite this YAML manually:

---
- name: Install Nginx on Pathnex server
  hosts: all
  become: yes

  tasks:
    - name: Install nginx
      yum:
        name: nginx
        state: present


## 🔹 Terraform Task — Create EC2 (c5.xlarge)

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "PathnexEC2" {
  ami           = "ami-0abcd1234abcd1234"
  instance_type = "c5.xlarge"

  tags = {
    Name = "Pathnex-EC2"
  }
}


## 🔹 Kubernetes Task — Create Nginx Pod

apiVersion: v1
kind: Pod
metadata:
  name: pathnex-pod
spec:
  containers:
    - name: web
      image: nginx:latest
      ports:
        - containerPort: 80


## 🔹 Shell Script — Print Date & Hostname

#!/bin/bash
echo "Date: $(date)"
echo "Hostname: $(hostname)"


# Git Integration
## 🔹 Jenkins Pipeline — Checkout Git
You will learn how to **checkout a Git repository** and list files.

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
        stage('List Files') {
            steps {
                sh 'ls -la'
            }
        }
    }
}

## 🔹 GitLab CI — Checkout Git
You will learn how to **checkout a Git repository in GitLab CI**.

stages:
  - checkout

git-checkout:
  stage: checkout
  script:
    - git clone https://github.com/Pathnex/sample-java-app.git
    - cd sample-java-app
    - ls -la
