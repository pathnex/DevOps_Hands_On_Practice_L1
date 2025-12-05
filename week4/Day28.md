# Day 28 — Debug Day

Fix these intentionally broken files:

## 🔹 Ansible — Broken

- name Install nginx
 hosts all
 tasks:
  - name missing
    yum:
      name nginx
      state present


## 🔹 Terraform — Broken

resource "aws_s3" "BadBucket" {
bucket = pathnex-bucket
acl public-read
}


## 🔹 Kubernetes — Broken

apiVersion v1
kind Pod
metadata:
 name brokenpod
spec:
 containers:
  -name app
   image nginx


# Rollback Strategies

## 🔹 Jenkins Pipeline — Automatic Rollback
You will learn how to **rollback automatically if deployment fails**.

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
        TEAM = "DevOps"
        ENV = "prod"
    }
    stages {
        stage('Deploy') {
            steps {
                script {
                    try {
                        sh 'echo "Deploying $INSTITUTE_NAME app in $ENV for $TEAM"'
                        sh 'exit 1' // simulate failure
                    } catch (Exception e) {
                        echo "Deployment failed. Rolling back $INSTITUTE_NAME app in $ENV"
                    }
                }
            }
        }
    }
}

## 🔹 GitLab CI — Rollback Strategy
You will learn how to **simulate rollback in GitLab CI with tags**.

stages:
  - deploy

variables:
  INSTITUTE_NAME: "Pathnex"
  TEAM = "DevOps"
  ENV = "prod"

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Deploying $INSTITUTE_NAME app in $ENV for $TEAM"
    - exit 1
  after_script:
    - echo "Deployment failed. Rolling back $INSTITUTE_NAME app in $ENV"
