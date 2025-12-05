# Day 13 — DEBUG DAY

Fix the following broken files:

## 🔹 Ansible (broken)

- name "Broken"
 hosts: all
 tasks:
   - name: Install
     yum:
       name: nginx
       state present


## 🔹 Terraform (broken)

resouce "aws_instance" BadEC2 {
  ami = ami-123
instance_type="c5.large"
tags = {
 Name:"Broken"
}
}


## 🔹 Kubernetes (broken)

apiVersion apps/v1
kind Deployment
metadata:
name broken
spec:
 replicas 2
 selector:
   matchLabels:
     app broken
 template:
  metadata:
    labels:
      app broken
  spec:
    containers:
     - name app
       image nginx


# Matrix Builds

## 🔹 Jenkins Pipeline — Matrix Build
You will learn how to **run the same build on multiple environments**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
    }
    matrix {
        axes {
            axis {
                name 'JAVA_VERSION'
                values '8', '11', '17'
            }
        }
        stages {
            stage('Build') {
                steps {
                    sh "echo Building with Java $JAVA_VERSION"
                }
            }
        }
    }
}

## 🔹 GitLab CI — Matrix Jobs
You will learn how to **run jobs across multiple environments using matrix**.

stages:
  - build

build:
  stage: build
  image: maven:3.8.1-jdk-17
  parallel:
    matrix:
      - JAVA_VERSION: ['8', '11', '17']
  script:
    - echo "Building with Java $JAVA_VERSION"
