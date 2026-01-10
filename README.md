# ECS Project: Gatus on AWS ECS (Fargate) with Docker, Terraform & CI/CD
---
## Table of Contents
- [Overview](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#overview)
- [Live Endpoints](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#live-endpoints)
- [Architecture](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#architecture)
- [Tech Stack](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#tech-stack)
- [Project Structure](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#project-structure)
- [Terraform Modules](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#terraform-modules)
- [Key Infrastructure Decisions](https://github.com/MuminUddin/ECS-Project/blob/main/README.md#key-infrastructure-decisions)
- 
---
## Overview
This project deploys Gatus (a lightweight status/health dashboard) on AWS ECS using Fargate, exposed via an Application Load Balancer (ALB) with HTTPS using ACM and a custom domain in Route 53.

Infrastructure is provisioned with Terraform (modular), and deployments are automated using GitHub Actions:

- Run it locally from source
- Build Docker image with a **multi-stage Dockerfile**
- Run it as a **non-root user** in the container
- Push the image to **Amazon ECR** using the commit SHA
- `terraform fmt`, `validate`, `tflint`, `plan`, and `apply`
- Post-deploy /health check
- Separate manual workflow to destroy resources to control AWS costs
---
## Live Endpoints
- App: https://status.muminlabs.com
- Health: https://status.muminlabs.com/health → returns {"status":"ok"}
- Gatus UI: docs/screenshots/gatus-ui.png
- Health check: docs/screenshots/health-check.png
- GitHub Actions deploy success: docs/screenshots/deploy-workflow.png
- GitHub Actions destroy success: docs/screenshots/destroy-workflow.png
---
## Architecture
High level request flow:
1. User hits status.muminlabs.com
2. Route 53 Alias record routes traffic to the ALB
3. ALB terminates TLS (ACM certificate)
4. ALB forwards traffic to ECS tasks (Fargate) on port 8080
5. ECS tasks pull the container image from ECR
6. Tasks run in private subnets, using NAT Gateways for outbound access (image pulls, updates, etc.)
---
## Tech Stack
- **App:** [Gatus](https://github.com/TwiN/gatus)
- **Language:** Go
- **Container:** Docker (multi-stage build, non-root runtime user)
- **Registry:** Amazon ECR
- **Cloud:** AWS VPC, Public/Private Subnets, IGW, NAT GW, Route Tables, ECS (Fargate), ECR, ALB, ACM, Route 53, CloudWatch Logs, S3 backend
- **IaC:** Terraform
- **CI/CD:** GitHub Actions
---
## Project Structure

```text
.
├─ .github/
│  └─ workflows/
│     ├─ deploy.yml
│     └─ destroy.yml
├─ app/
│  └─ gatus/
│     └─ Dockerfile
├─ infra/
│  ├─ backend.tf
│  ├─ main.tf
│  ├─ outputs.tf
│  ├─ providers.tf
│  ├─ variables.tf
│  ├─ bootstrap/
│  │  └─ s3.tf
│  └─ modules/
│     ├─ acm/
│     ├─ alb/
│     ├─ ecr/
│     ├─ ecs/
│     ├─ security/
│     └─ vpc/
├─ .gitignore
└─ README.md
```
---
## Terraform Modules
- modules/vpc: VPC, subnets, route tables, IGW, NAT Gateways
- modules/security: security groups and SG rules (ALB + ECS tasks)
- modules/alb: ALB, target group, listeners, listener rules
- modules/acm: ACM certificate + DNS validation records + Route 53 records
- modules/ecr: ECR repository
- modules/ecs: ECS cluster, task definition, service, CloudWatch log group
---
## Key Infrastructure Decisions
### Networking
- ALB is placed in public subnets (internet facing)
- ECS tasks run in private subnets
- NAT Gateways provide outbound access for tasks (for example ECR pulls)

### Security Groups
#### ALB SG
- Inbound: 80 and 443 from 0.0.0.0/0
- Outbound: allowed

#### Task SG
- Inbound: 8080 only from the ALB SG
- Outbound: allowed

### HTTPS and Domain
- ACM certificate issued for status.muminlabs.com
- DNS validation done via Route 53 CNAME records
- Route 53 Alias A record points status to the ALB
- HTTP (80) redirects to HTTPS (443)

### Health Check
/health returns:
```json
{"status":"ok"}
```
---
## Remote State
- Terraform state uses an S3 backend (created via infra/bootstrap/s3.tf).
- The state bucket is intentionally not destroyed to avoid breaking remote state.
---
## CI/CD Workflows
Deploy (.github/workflows/deploy.yml)
Runs on push to main (and supports manual trigger). Pipeline stages:
1. Assume AWS role using OIDC (no static AWS keys)
2. Build Docker image from app/gatus
3. Tag image with commit SHA and push to ECR
4. Terraform checks: fmt, validate, tflint
5. Terraform plan/apply passing image_tag=${{ github.sha }}
6. Post-deploy health check: curl -sS --fail-with-body https://status.muminlabs.com/health

Destroy (.github/workflows/destroy.yml)
Manual workflow (workflow_dispatch) requiring confirmation.
- Runs terraform destroy to prevent ongoing AWS costs (NAT Gateways/ALB can be expensive)





