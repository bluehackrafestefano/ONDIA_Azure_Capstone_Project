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

