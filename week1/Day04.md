# Day 04 — More Packages, Key Pair, Service

## 🔹 Ansible — Install Multiple Packages

---
- name: Install packages for Pathnex
  hosts: all
  become: yes

  tasks:
    - name: Install tools
      yum:
        name:
          - git
          - wget
        state: present


## 🔹 Terraform — EC2 with Key Pair (c6i.8xlarge)

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "PathnexKey" {
  key_name   = "PathnexKey"
  public_key = "ssh-rsa AAAA...."
}

resource "aws_instance" "PathnexEC2" {
  ami           = "ami-0abcd1234abcd1234"
  instance_type = "c6i.8xlarge"
  key_name      = aws_key_pair.PathnexKey.key_name

  tags = {
    Name = "Pathnex-EC2"
  }
}


## 🔹 Kubernetes — Create ClusterIP Service

apiVersion: v1
kind: Service
metadata:
  name: pathnex-service
spec:
  selector:
    app: pathnex-app
  ports:
    - port: 80
      targetPort: 80


# Parallel Builds
## 🔹 Jenkins Pipeline — Parallel Build & Test
You will learn how to **run build and test in parallel**.

pipeline {
    agent any
    stages {
        stage('Parallel Tasks') {
            parallel {
                stage('Build') {
                    steps {
                        sh 'mvn clean compile'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'mvn test'
                    }
                }
            }
        }
    }
}

## 🔹 GitLab CI — Parallel Jobs
You will learn how to **run parallel jobs in GitLab CI**.

stages:
  - build-test

maven-build:
  stage: build-test
  image: maven:3.8.1-jdk-17
  script:
    - git clone https://github.com/Pathnex/sample-java-app.git
    - cd sample-java-app
    - mvn clean compile
  parallel: 1

maven-test:
  stage: build-test
  image: maven:3.8.1-jdk-17
  script:
    - cd sample-java-app
    - mvn test
  parallel: 1
