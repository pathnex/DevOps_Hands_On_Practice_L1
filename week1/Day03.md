# Day 03 — Users, SGs, Env Vars

## 🔹 Ansible — Create User

---
- name: Create Pathnex user
  hosts: all
  become: yes

  tasks:
    - name: Create user pathnex-admin
      user:
        name: pathnex-admin
        shell: /bin/bash


## 🔹 Terraform — Security Group (r6i.4xlarge EC2)

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "PathnexSG" {
  name        = "PathnexSG"
  description = "Pathnex SG for SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "PathnexEC2" {
  ami                    = "ami-0abcd1234abcd1234"
  instance_type          = "r6i.4xlarge"
  vpc_security_group_ids = [aws_security_group.PathnexSG.id]

  tags = {
    Name = "Pathnex-EC2"
  }
}


## 🔹 Kubernetes — Add Environment Variables

apiVersion: v1
kind: Pod
metadata:
  name: pathnex-env-pod
spec:
  containers:
    - name: app
      image: nginx
      env:
        - name: APP_ENV
          value: "production"


## 🔹 Shell Script — Check File Exists

#!/bin/bash
FILE="/tmp/pathnex.txt"

if [ -f "$FILE" ]; then
  echo "File exists"
else
  echo "File does not exist"
fi


# NodeJS Build
## 🔹 Jenkins Pipeline — NodeJS Build
You will learn how to **install dependencies, run tests, and build a NodeJS project**.

pipeline {
    agent any
    tools {
        nodejs 'NodeJS-16'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Pathnex/sample-node-app.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
    }
}

## 🔹 GitLab CI — NodeJS Build

stages:
  - install
  - test
  - build

node-install:
  stage: install
  image: node:16
  script:
    - git clone https://github.com/Pathnex/sample-node-app.git
    - cd sample-node-app
    - npm install

node-test:
  stage: test
  image: node:16
  script:
    - cd sample-node-app
    - npm test

node-build:
  stage: build
  image: node:16
  script:
    - cd sample-node-app
    - npm run build
