# Day 25 — Lineinfile, Key Pair, Multi-Container, File Count

## 🔹 Ansible — Modify Existing Line

- name: Update SSH config for Pathnex
  hosts: all
  become: yes
  tasks:
    - name: Disable root login
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: "^PermitRootLogin"
        line: "PermitRootLogin no"

## 🔹 Terraform — EC2 Key Pair Output

resource "aws_key_pair" "PathnexKey" {
  key_name   = "PathnexKey"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

output "Pathnex_Key_Name" {
  value = aws_key_pair.PathnexKey.key_name
}

## 🔹 Kubernetes — Multi-Container Pod (Sidecar Logging)

apiVersion: v1
kind: Pod
metadata:
  name: pathnex-sidecar
spec:
  containers:
    - name: app
      image: nginx
    - name: log-writer
      image: busybox
      command: ["sh", "-c", "while true; do echo log entry; sleep 5; done"]


## 🔹 Shell Script — Count Files in Directory

#!/bin/bash

DIR="/var/log"

COUNT=$(find "$DIR" -maxdepth 1 -type f | wc -l)

echo "Total files in $DIR: $COUNT"


# Advanced Caching

## 🔹 Jenkins Pipeline — Cache Dependencies
You will learn how to **cache Maven dependencies with realistic labels**.

pipeline {
    agent any
    
    environment {
        INSTITUTE_NAME = "Pathnex"
        TEAM = "DevOps"
        ENV = "staging"
        MAVEN_OPTS = "-Dmaven.repo.local=$WORKSPACE/.m2/repository"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    mvn clean compile
                    echo "Build completed for $INSTITUTE_NAME in $ENV by $TEAM"
                '''
            }
        }
    }
}

## 🔹 GitLab CI — Cache Dependencies
You will learn how to **cache dependencies in GitLab CI with tags**.

stages:
  - build

variables:
  INSTITUTE_NAME: "Pathnex"
  TEAM: "DevOps"
  ENV: "staging"
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository"

build:
  stage: build
  image: maven:3.8.1-jdk-17

  cache:
    key: "${ENV}-maven-cache"
    paths:
      - .m2/repository

  script:
    - mvn clean compile
    - echo "Cached dependencies for $INSTITUTE_NAME in $ENV by $TEAM"
