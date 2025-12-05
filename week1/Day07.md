# Day 07 — SPEED TYPING

Rewrite ALL FOUR from scratch:

1. Ansible: Install nginx
2. Terraform: EC2 (choose any Pathnex instance)
3. Kubernetes: Deployment 2 replicas
4. Shell: Print date + uptime

Set a timer: **20 minutes**


# Parameterized Builds

## 🔹 Jenkins Pipeline — Parameterized
You will learn how to **create parameterized builds in Jenkins**.

pipeline {
    agent any
    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Deployment Environment')
    }
    environment {
        INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Deploying to $ENVIRONMENT by $INSTITUTE_NAME"'
            }
        }
    }
}

## 🔹 GitLab CI — Parameterized via Variables
You will learn how to **use variables to parameterize GitLab jobs**.

stages:
  - deploy

variables:
  INSTITUTE_NAME: "Pathnex"
  ENVIRONMENT: "dev"

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Deploying to $ENVIRONMENT by $INSTITUTE_NAME"
