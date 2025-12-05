# Day 10 — Conditions, Route Table, Secret, Loops

## 🔹 Ansible — When Condition

---
- name: Install tool based on OS
  hosts: all
  become: yes

  tasks:
    - name: Install htop
      yum:
        name: htop
        state: present
      when: ansible_facts['os_family'] == "RedHat"


## 🔹 Terraform — Route Table + Association

resource "aws_route_table" "PathnexRT" {
  vpc_id = aws_vpc.PathnexVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.PathnexIGW.id
  }

  tags = {
    Name = "Pathnex-RouteTable"
  }
}

resource "aws_route_table_association" "PathnexRTA" {
  subnet_id      = aws_subnet.PathnexSubnet.id
  route_table_id = aws_route_table.PathnexRT.id
}


## 🔹 Kubernetes — Secret

apiVersion: v1
kind: Secret
metadata:
  name: pathnex-secret
type: Opaque
data:
  password: cGF0aG5leDEyMw==   # "pathnex123" base64


## 🔹 Shell Script — For Loop 1–10

#!/bin/bash

for i in {1..10}; do
  echo "Number: $i"
done


# Caching Dependencies

## 🔹 Jenkins Pipeline — Cache Maven Dependencies
You will learn how to **reuse dependencies to speed up builds**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
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
                if [ -d ".m2" ]; then
                    echo "Using cached dependencies"
                else
                    mvn clean compile
                fi
                '''
            }
        }
    }
}

## 🔹 GitLab CI — Cache Dependencies
You will learn how to **cache dependencies in GitLab CI**.

stages:
  - build

build:
  stage: build
  image: maven:3.8.1-jdk-17
  cache:
    key: maven-cache
    paths:
      - .m2/repository
  script:
    - git clone https://github.com/Pathnex/sample-java-app.git
    - cd sample-java-app
    - mvn clean compile
