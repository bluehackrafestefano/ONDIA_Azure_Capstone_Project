# 📦 Terraform Infrastructure for Grafana as a Service

This folder contains the **Infrastructure as Code (IaC)** implementation for deploying the **Grafana as a Service** project on Azure.  
The Terraform configuration is structured into **modules** for better organization, reusability, and scalability.  

---

## 🏗️ Module Structure

```
terraform/
├── main.tf                # root config (calls modules)
├── variables.tf           # input variables
├── outputs.tf             # global outputs
├── modules/
│   ├── network/           # Networking stack
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── compute/           # Compute + application stack
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── observability/     # Logging, monitoring, diagnostics
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── database/          # Database stack
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

## 📦 Module Responsibilities

### 1. **network/**
Responsible for all networking resources:
- Resource Group (if tenant-specific)
- Virtual Network & Subnets (`app-subnet`, `db-subnet`, `bastion-subnet`)
- NAT Gateway + outbound association
- Bastion host for secure admin access

### 2. **compute/**
Deploys compute + application layer:
- VM Scale Set (Linux) with `cloud-init` to install Grafana
- Azure Load Balancer (frontend, backend, health probes, rules)
- Azure DNS zone & record (friendly domain for Grafana)
- Optional: NSGs for subnet/resource protection

### 3. **observability/**
Handles monitoring, logging, and observability stack:
- Azure Storage Account for log retention
- Log Analytics Workspace
- Diagnostic settings for VMSS, PostgreSQL, Load Balancer, and Bastion
- Azure Monitor:
  - Metrics collection
  - Autoscale rules
  - Alerts (e.g., CPU usage, SSH brute force attempts)

### 4. **database/**
Manages persistence layer:
- Azure Database for PostgreSQL Flexible Server
- VNet integration and private endpoint
- Database firewall rules
- Outputs credentials & connection string (best managed via Key Vault)

---

## 🚀 Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Preview the infrastructure plan:
   ```bash
   terraform plan -var-file="terraform.tfvars"
   ```

3. Apply the deployment:
   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

4. Destroy the infrastructure when no longer needed:
   ```bash
   terraform destroy -var-file="terraform.tfvars"
   ```

---

## 📚 Notes

- Each module has its own `variables.tf` and `outputs.tf` for flexibility.  
- Credentials (DB passwords, Entra secrets) should be stored in **Azure Key Vault** and passed into Terraform securely.  
- Observability stack (Log Analytics, Alerts, Dashboards) is optional but highly recommended for production.  
- Modules can be extended or replaced (e.g., replace VMSS with AKS in the `compute/` module).  

---
