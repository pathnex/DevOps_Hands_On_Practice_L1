# Day 30 — SPEED TYPING (LEVEL 3)

Rewrite all FOUR from scratch in **12 minutes**:

### Ansible:
- Create user "pathnex-admin"
- Add SSH key
- Set shell to /bin/bash

### Terraform:
- Create EC2 with tag:
     Project = "Pathnex-Training"

### Kubernetes:
- Deployment (2 replicas)
- Expose via ClusterIP

### Shell:
- Menu with:
  1) IP
  2) Disk
  3) Memory

## 5️⃣ Jenkins Pipeline
You will learn to **automate all tasks in a Jenkins Pipeline** under real-world stages:

- Create **Declarative Pipeline** with stages:
- Infrastructure – Terraform EC2 with tag Project = "Pathnex-Training"
- App Deployment – Ansible user creation, SSH setup, Kubernetes deployment
- Monitoring Checks – Shell menu to display:
- IP
- Disk
- Memory

- Use environment variables for all stages:
- INSTITUTE_NAME = "Pathnex"
- TEAM = "DevOps"
- ENV = "prod"
- PROJECT = "Pathnex-Training"

## 6️⃣ GitLab CI
You will learn to **combine all tasks in a GitLab CI pipeline**:

- Create `.gitlab-ci.yml` with stages:
- infrastructure – Terraform EC2 with Project tag
- app_deployment – Ansible + Kubernetes deployment
- monitoring_checks – Shell menu checks for:
- IP
- Disk
- Memory

- Define variables:
- INSTITUTE_NAME = "Pathnex"
- TEAM = "DevOps"
- ENV = "prod"
- PROJECT = "Pathnex-Training"