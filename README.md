# Secure 2-Tier Web Application Infrastructure on Azure

A production-style network architecture provisioned entirely with Terraform — a public-facing web tier and a fully isolated database tier, demonstrating least-privilege network design.
## Problem
Most beginner cloud projects put everything in one flat network with no real access control. This project demonstrates the core pattern used in real production environments: the thing exposed to the internet is never the thing holding the data.
## Architecture
- VNet (10.0.0.0/16) split into two subnets
- Public subnet (10.0.1.0/24): web tier VM running nginx, with a public IP
- Private subnet (10.0.2.0/24): database tier VM, no public IP at all
- Web tier NSG: SSH restricted to a single admin IP, HTTP open to all
- Database tier NSG: SSH only accepted from the web tier's subnet range
## Key Security Decisions
- SSH on the web tier is restricted to a single admin IP (/32), not open to the world. Leaving SSH open on 0.0.0.0/0 is a common finding in real security audits.
- The database VM has no public IP at all — it is architecturally unreachable from the internet, not just firewalled.
- The database NSG only accepts SSH from the web tier's subnet range — even inside the same VNet, access is scoped to only what's needed.
- All infrastructure is defined as code — no manual portal configuration, fully reproducible via terraform apply.
## What's Deployed
- Resource Group: container for all resources
- Virtual Network + 2 Subnets: network isolation boundary
- 2 Network Security Groups: enforce least-privilege access per tier
- Public IP (Standard SKU): web tier internet access
- 2 Network Interfaces: attach VMs to their respective subnets
- 2 Linux VMs (Ubuntu 22.04): web tier (nginx) and database tier

## How to Deploy

git clone https://github.com/asfandk98/azure-secure-2tier-infrastructure.git
cd azure-secure-2tier-infrastructure
echo admin_ip = "YOUR_IP/32" > terraform.tfvars
terraform init
terraform plan
terraform apply

## Verification Performed

1. Web server accessible: confirmed nginx serving a page at the public IP
2. Internal access allowed: SSH from web tier to database tier succeeds
3. External access blocked: direct SSH attempt to the database tier from outside the web subnet times out completely

## What I Would Add at Production Scale

- Azure Bastion instead of direct SSH exposure, even restricted by IP
- Application Gateway or Load Balancer in front of the web tier for high availability
- Azure Key Vault for secrets instead of local SSH keys
- Terraform remote state using an Azure Storage backend instead of local state
- CI/CD pipeline to automate plan and apply on pull requests

## Cost Note

All resources use free-tier-eligible sizes (Standard_B1s) where possible. This project is deployed and destroyed on demand, not left running, to avoid unnecessary cost during learning.
