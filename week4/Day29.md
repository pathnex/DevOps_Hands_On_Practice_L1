# Day 29 — Real-World Mini Project

Complete the following:

## 1️⃣ Terraform
- Create EC2 (choose: c5.xlarge / r5.2xlarge / r6i.4xlarge / c6i.8xlarge / c6a.12xlarge)
- Security group
- Key pair
- EBS volume
- Output IP

## 2️⃣ Ansible
- Install nginx
- Deploy "Welcome to Pathnex" HTML page
- Start & enable service

## 3️⃣ Kubernetes
- Create Deployment with PVC
- Expose via NodePort

## 4️⃣ Shell Script
- Print 5 system checks:
  - CPU
  - Memory
  - Disk
  - IP
  - Top process

# Day 29 — Real-World Mini Project

Complete the following:

## 1️⃣ Terraform
- Create EC2 (choose: c5.xlarge / r5.2xlarge / r6i.4xlarge / c6i.8xlarge / c6a.12xlarge)
- Security group
- Key pair
- EBS volume
- Output IP

## 2️⃣ Ansible
- Install nginx
- Deploy "Welcome to Pathnex" HTML page
- Start & enable service

## 3️⃣ Kubernetes
- Create Deployment with PVC
- Expose via NodePort

## 4️⃣ Shell Script
- Print 5 system checks:
  - CPU
  - Memory
  - Disk
  - IP
  - Top process

## 5️⃣ Jenkins Pipeline
You will learn to **combine all tasks into a realistic Jenkins Pipeline** with proper stages and tags.

- Create **Declarative Pipeline** with stages:
- Infrastructure – apply Terraform to create EC2, Security Group, Key Pair, and EBS volume
- App Deployment – run Ansible playbooks and deploy Kubernetes resources
- Monitoring Checks – execute shell scripts to check:
- CPU
- Memory
- Disk
- IP
- Top process

- Use environment variables for all stages:
- INSTITUTE_NAME = "Pathnex"
- TEAM = "DevOps"
- ENV = "prod"
- PROJECT = "Pathnex-Training"

## 6️⃣ GitLab CI
You will learn to **combine all tasks in a realistic GitLab CI pipeline**.

- Create `.gitlab-ci.yml` with stages:
- infrastructure – Terraform apply for EC2, SG, Key Pair, EBS
- app_deployment – Ansible and Kubernetes deployment
- monitoring_checks – Shell scripts to check:
- CPU
- Memory
- Disk
- IP
- Top process

- Define variables:
- INSTITUTE_NAME = "Pathnex"
- TEAM = "DevOps"
- ENV = "prod"
- PROJECT = "Pathnex-Training"