# ECS Project – Gatus Uptime Monitoring

This repository contains my ECS project from the CoderCo bootcamp.

The goal is to take a real open source app (Gatus, an uptime and health monitoring dashboard), run it locally from source, then:

- Containerise it with a multi stage Dockerfile
- Push the image to Amazon ECR
- Deploy it on ECS Fargate behind an Application Load Balancer (ALB)
- Add HTTPS with a custom domain using Route 53 and ACM
- Rebuild the ClickOps setup using Terraform
- Automate builds and deploys with GitHub Actions

---

## Architecture at a glance

Target end state:

1. Gatus runs in a container on **ECS Fargate**
2. The container image is stored in **Amazon ECR**
3. Traffic flows:  
   Client → **ALB** → ECS service → Gatus on port 8080  
4. DNS is handled by **Route 53**
5. TLS is handled by **AWS Certificate Manager**
6. ECS stack is recreated using **Terraform**
7. **GitHub Actions** builds images, pushes to ECR and triggers Terraform

---

## Tech stack

- **App:** [Gatus](https://github.com/TwiN/gatus) (Go based uptime and status dashboard)
- **Language:** Go
- **Container:** Docker, multi stage build, non root runtime user
- **Registry:** Amazon ECR
- **Compute:** AWS ECS Fargate (to be hooked up)
- **Networking:** VPC, subnets, security groups, ALB, Route 53 (planned in infra)
- **TLS:** AWS Certificate Manager (planned)
- **IaC:** Terraform (planned in `infra/`)
- **CI/CD:** GitHub Actions (planned)

---

## Repository structure

```text
.
├─ app/
│  └─ gatus/               # Gatus source code used as the application
│     ├─ config/           # Gatus configuration (endpoints, checks)
│     ├─ Dockerfile        # Multi stage Dockerfile written for this project
│     ├─ README.md         # Upstream Gatus README (kept for reference)
│     └─ ...               # Other upstream Gatus files
├─ infra/                  # Terraform infrastructure code (to be added)
├─ .gitignore
└─ README.md               # This project level README
