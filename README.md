# ECS Project – Gatus Uptime Monitoring

This repository contains my ECS project for the CoderCo bootcamp.

The goal is to take a real open-source app (Gatus – an uptime/health monitoring dashboard), and:

- Run it locally from source
- Containerise it with a **multi-stage Dockerfile**
- Run it as a **non-root user** in the container
- Push the image to **Amazon ECR**
- Later: deploy on **ECS Fargate** behind an **Application Load Balancer**, add HTTPS and a custom domain, rebuild everything with **Terraform**, and wire in **CI/CD**.

---

## Tech Stack (current)

- **App:** [Gatus](https://github.com/TwiN/gatus)
- **Language:** Go
- **Container:** Docker (multi-stage build, non-root runtime user)
- **Registry:** Amazon ECR
- **Cloud:** AWS (ECR now; ECS/ALB/VPC/Route 53/ACM later)
- **IaC:** Terraform (planned)
- **CI/CD:** GitHub Actions (planned)

---

## Project Structure

```text
.
├─ app/
│  └─ gatus/              # Gatus source code used for this project
│     ├─ config/          # Gatus configuration (endpoints, checks)
│     ├─ Dockerfile       # Multi-stage Dockerfile I wrote for ECS
│     ├─ README.md        # Upstream Gatus README (kept for reference)
│     └─ ...              # Other upstream Gatus files
├─ infra/                 # Terraform IaC (to be added)
├─ .gitignore
└─ README.md              # This project README
```
---
