# Day 20 — DEBUG DAY

Fix these intentionally broken files:

## 🔹 Ansible — Broken

- name: Install stuff
  hosts: all
  tasks:
   - name: Install httpd
    yum:
      name: httpd
      state: present


## 🔹 Terraform — Broken

resource "aws_instance" "bad" {
 ami = "ami-123"
 instance_type = "c6i.8xlarge"
}


## 🔹 Kubernetes — Broken

apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: broken
  template:
    metadata:
      labels:
        app: broken
    spec:
      containers:
        - name: app
          image: nginx


# Secrets & Credentials

## 🔹 Jenkins Pipeline — Using Credentials
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

        stage('Use Secret') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'PATHNEX_API_KEY',
                        variable: 'API_KEY'
                    )
                ]) {
                    sh 'echo "API key is available for $INSTITUTE_NAME"'
                }
            }
        }
    }
}

## 🔹 GitLab CI — Using CI/CD Variables
stages:
  - build

variables:
  INSTITUTE_NAME: "Pathnex"

build:
  stage: build
  image: alpine:latest

  script:
    - echo "Using secret for $INSTITUTE_NAME"
    - |
      if [ -n "$API_KEY" ]; then
        echo "API key is available"
      else
        echo "API key is missing"
        exit 1
      fi
