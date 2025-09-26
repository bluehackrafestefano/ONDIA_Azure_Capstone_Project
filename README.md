# 🚀 Project-401: Grafana Service deployed on Azure VMSS connected to a Load Balancer, PostgreSQL Flexible DB, VNet Components, Azure DNS, NAT Gateway, Bastion, Storage Account, and Azure Monitor — deployed with Terraform using Azure Entra ID to manage identities.

## 🎯 Description
This project demonstrates how to deliver **Grafana as a Service** on Azure deployed with **Terraform**.  

This project is deploying:
- **VM Scale Set (VMSS)** running Grafana  
- A dedicated **PostgreSQL Flexible Server** for persistence  
- Access through an **Azure Load Balancer** and **Azure DNS**  
- **Azure NAT Gateway** for outbound Internet traffic  
- **Azure Bastion Host** for secure admin access (SSH/RDP)  
- **Azure Storage Account** for log storage  
- **Azure Monitor** for metrics, alerts, autoscale, and log analytics  
- Authentication via **Azure Entra ID** (OAuth2)  

Possible to extend to multiple customers and turn into a **Grafana as a Service** product.

---

## 🏗️ High-Level Architecture
![Project Overview](Azure_Project_Grafana_Server.png)
- **Resource Group** → groups customer resources  
- **Virtual Network (VNet) & Subnets** → network isolation for DB, VMSS, and Bastion  
- **Azure VMSS (Linux)** → hosts scalable Grafana OSS instances  
- **Azure Database for PostgreSQL Flexible Server** → external DB for Grafana dashboards and configuration  
- **Azure Load Balancer** → distributes traffic to Grafana VMSS instances  
- **Azure NAT Gateway** → provides outbound Internet access for VMs  
- **Azure Bastion** → secure admin access (SSH/RDP) without exposing public IPs  
- **Azure Storage Account** → central log storage for Grafana and infrastructure logs  
- **Azure Monitor** → observability stack for metrics, alerts, autoscaling, and log analytics  
- **Azure Entra ID** → provides secure login and SSO for users  
- **Azure DNS** → friendly domain name resolution for end-users  

---

## ✨ Key Features
- **Infrastructure as Code (IaC):** Terraform templates define the full environment  
- **Scalability:** Grafana runs on **VMSS** with autoscaling via Azure Monitor  
- **Database Isolation:** Each customer has their own PostgreSQL Flexible DB  
- **Authentication:** Integrated with **Azure Entra ID** for enterprise SSO  
- **Secure Access:** Bastion provides hardened administrative access  
- **Monitoring & Logging:** Metrics, logs, and alerts collected with Azure Monitor + Log Analytics  
- **Extensibility:** Can evolve towards App Gateway with WAF, containerized Grafana on AKS, or multi-region deployments  

---

## ✅ Expected Outcomes
By using this project, students and practitioners will:  
- Learn to deploy **infrastructure as code** with Terraform on Azure  
- Deploy **Grafana OSS** backed by a managed PostgreSQL Flexible DB  
- Implement **secure and scalable infrastructure** with VMSS + Load Balancer  
- Gain experience integrating **Azure NAT Gateway, Bastion, and Storage Accounts**  
- Learn **observability practices** using Azure Monitor (metrics, logs, alerts, autoscale)  
- Enable **secure login** with Azure Entra ID  
- Understand how to design and scale a **multi-tenant SaaS system** on Azure  
- Explore automation patterns for **customer onboarding and scaling**  

---

## 📚 References
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  
- [Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/)  
- [Grafana installation guide](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)  
- [Grafana OAuth2 Generic Authentication](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/oauth/)  
- [Microsoft Docs: Register an app with Microsoft identity platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)  
- [Microsoft Docs: Configure SSO with Grafana](https://learn.microsoft.com/en-us/azure/active-directory/saas-apps/grafana-tutorial)  
- [Azure Bastion Documentation](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)  
- [Azure NAT Gateway Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/nat-gateway/nat-overview)  
- [Azure Monitor Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)  

---

## 🧱 Project Setup: Network & Foundational Components

Before deploying VMs, databases, and Grafana, we first build the networking foundation. These are the steps to create the network components:

### 1. Create Resource Group
- Choose a **resource group** to contain all project resources (VNet, subnets, NSGs, NAT, Bastion, etc.).
- Use meaningful naming (e.g. `rg-grafana-prod`) to reflect purpose and lifecycle.  
- Reference: [Azure N-Tier Linux VM Architecture](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/linux-vm)

### 2. Provision Virtual Network (VNet)
- Create an Azure **Virtual Network** for the project (e.g. `vnet-grafana`).
- Define an appropriate address space (e.g. `10.0.0.0/16`).
- This VNet will host subnets such as application, database, bastion, etc.

### 3. Define Subnets
Segment the VNet into subnets for different tiers:

| Subnet Name     | Purpose                                  |
|-----------------|------------------------------------------|
| **app-subnet**  | Hosts Grafana VMSS and related services  |
| **db-subnet**   | Contains the PostgreSQL Flexible Server  |
| **bastion-subnet** | Hosts Azure Bastion for secure admin access |
| **infra-subnet** (optional) | NAT Gateway, jump boxes, or shared services |

Ensure each subnet’s prefix is non-overlapping and sized appropriately.

### 4. Network Security Groups (NSGs)
- Create **NSGs** to control inbound/outbound traffic per subnet or VM NIC.
- Default NSG rules block inbound from Internet—so add rules to allow necessary ports:
  - Grafana HTTP(s) → TCP 3000, 443
  - SSH (TCP 22) → Bastion/admin access only
- Attach NSGs at **subnet level** or **NIC level** depending on granularity needed.

### 5. Public IPs and DNS
- Provision **Public IP addresses** for resources that need external access (e.g. Load Balancer frontend, NAT Gateway).
- Reserve **static IPs** when stable DNS records are required.
- Assign a **fully qualified domain name (FQDN)** to public IPs and integrate with **Azure DNS** or an external DNS provider.

### 6. NAT Gateway (Outbound Internet)
- Deploy an **Azure NAT Gateway** to allow outbound Internet connectivity for VMs in private subnets without assigning them public IPs.
- Associate the NAT Gateway with your subnets (e.g. app-subnet, db-subnet).
- Ensures only initiated connections go out, blocking unsolicited inbound traffic by default.

### 7. Bastion Host (Secure Admin Access)
- Deploy **Azure Bastion** in the **bastion-subnet**.
- Bastion enables secure SSH/RDP to VMs in the VNet over TLS without public IPs on the VMs.
- Improves security posture by minimizing exposed endpoints.

### 8. Diagnostics & Logging Infrastructure
- Provision a **Storage Account** (e.g. `stgdiaglogs`) to store boot diagnostics and VM logs.
- Enable diagnostic settings to send metrics, logs, and activity logs into:
  - **Log Analytics**
  - **Storage**
  - **Azure Monitor**
- Ensures observability and simplifies troubleshooting.

---

## 🖥️ Project Setup: Compute & Application Components

Once networking is in place, we deploy compute, databases, and application services.

### 1. Deploy Azure VM Scale Set (VMSS)
- Create a **Linux-based VMSS** to host Grafana instances.
- Use a custom `cloud-init` or provisioning script to install Grafana (see `cloud-init.yaml`).
- Configure **autoscaling** rules via **Azure Monitor** (scale out on CPU/memory, scale in during low load).
- Place VMSS in **app-subnet**.

### 2. Attach Load Balancer
- Provision an **Azure Load Balancer**.
- Configure:
  - **Frontend IP** (public, with DNS label if needed).
  - **Backend pool** (VMSS instances).
  - **Health probes** (port 3000 for Grafana).
  - **Load-balancing rules** for HTTP/HTTPS traffic.
- Ensures high availability and seamless access to Grafana.

### 3. Provision PostgreSQL Flexible Server
- Deploy **Azure Database for PostgreSQL Flexible Server** in **db-subnet**.
- Enable **VNet integration** to restrict access to internal VNets only.
- Configure **firewall rules** and **admin credentials**.
- Grafana will use this DB for dashboards, users, and data sources.

### 4. Configure Grafana Installation
- Use `cloud-init` to:
  - Install Grafana OSS from the official APT repo.
  - Enable and start `grafana-server` service.
- Optionally, pre-provision:
  - **Data sources** (PostgreSQL, Azure Monitor).
  - **Dashboards** via `/etc/grafana/provisioning/`.

### 5. Integrate with Azure Entra ID
- Register **Grafana app** in Entra ID.
- Configure OAuth2 settings in Grafana (`grafana.ini`).
- Grant necessary permissions (profile, openid, email).
- Enables **SSO** for enterprise users.

### 6. Storage Integration
- Connect VMSS diagnostic logs and Grafana logs to **Azure Storage Account**.
- Optionally send logs to **Log Analytics** for centralized monitoring.

### 7. Monitoring & Autoscale
- Enable **Azure Monitor** for VMSS, PostgreSQL, and Grafana metrics.
- Configure **alerts** (e.g., CPU > 70%).
- Define **autoscale rules** (e.g., scale out when CPU > 70%, scale in when < 30%).
- Create **dashboards** for end-to-end observability.

### 8. Azure DNS Integration
- Create a DNS zone (e.g. `grafana.example.com`).
- Map Load Balancer’s public IP to a friendly domain.
- Users access Grafana securely via FQDN.

---
