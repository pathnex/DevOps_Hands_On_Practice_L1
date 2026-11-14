# Day 14 — MINI PROJECT

Complete these steps:

## 1️⃣ Terraform — Create EC2 (any instance type)

- VPC
- Subnet
- Internet gateway
- Route table
- EC2 (c5.xlarge / r5.2xlarge / r6i.4xlarge / c6i.8xlarge / c6a.12xlarge)

## 2️⃣ Ansible — Install Nginx & Deploy HTML File
- name: Install Nginx
  hosts: all
  become: yes
  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present

    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Deploy HTML
      copy:
        src: index.html
        dest: /usr/share/nginx/html/index.html

## 3️⃣ Kubernetes — Create Deployment + Service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080

## 4️⃣ Shell — Print CPU, Memory, Disk
#!/bin/bash
echo "CPU Information"
lscpu

echo "Memory Information"
free -h

echo "Disk Information"
df -h

# Scheduled Pipelines

## 🔹 Jenkins Pipeline — Scheduled Build
You will learn how to **schedule a Jenkins pipeline using cron**.

pipeline{
    agent any
    environment{
        INSTITUTE_NAME = "Pathnex"
    }
    triggers {
        cron('H 2 * * *) // every day at 2 AM
    }
    stages {
        stage('Checkout'){
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
        stage('Build'){
            steps {
                sh 'mvn clean package'
            }
        }
    }
}

## 🔹 GitLab CI — Scheduled Pipeline
You will learn how to **scedule GitLab CI pipelines via cron**.

stages:
    - build

build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean package
