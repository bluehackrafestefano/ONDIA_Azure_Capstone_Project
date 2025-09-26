# 🚀 Project-401: Grafana Service deployed on Azure VMSS connected to a Load Balancer, PostgreSQL Flexible DB, VNet Components, and Azure DNS deployed with Terraform using Azure Entra ID to manage identities.

## 🎯 Description
This project demonstrates how to deliver **Grafana as a Service** on Azure deployed with **Terraform**.  

This project is deploying:
- A dedicated **VM** running Grafana  
- A dedicated **PostgreSQL database**  
- Access through an **Azure Load Balancer**  
- Authentication via **Azure Entra ID** (OAuth2)  

Possible to extend to multiple customers and turn into a **Grafana as a Service** product.

---

## 🏗️ High-Level Architecture
- **Resource Group** → groups customer resources  
- **Virtual Network & Subnet** → isolated networking per deployment  
- **Azure Linux VM** → runs Grafana OSS  
- **Azure Database for PostgreSQL Flexible Server** → external DB for Grafana  
- **Azure Load Balancer** → front door for Grafana instances  
- **Azure Entra ID** → provides secure login for users  

---

## ✨ Key Features
- **Infrastructure as Code (IaC):** Terraform templates define the full environment  
- **Database Isolation:** Each customer has their own PostgreSQL database  
- **Scalable Design:** Easily extendable to multiple customers (VM + DB per tenant)  
- **Authentication:** Integrated with **Azure Entra ID** for enterprise SSO  
- **Extensibility:** Can evolve towards scale sets, Application Gateway, and modules for onboarding  

---

## 🔑 Multi-Customer Options
- **Per-Customer Resources:** Each customer has their own VM, DB, and Entra app  
- **Terraform Modules:** Encapsulate customer deployments for easy replication  
- **Automation:** Inject credentials and settings with `cloud-init` or Terraform templates  
- **Advanced:** Use a multi-tenant Entra app with centralized identity policies  

---

## 📚 References
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  
- [Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/)  
- [Grafana installation guide](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)  
- [Grafana OAuth2 Generic Authentication](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/oauth/)  
- [Microsoft Docs: Register an app with Microsoft identity platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)  
- [Microsoft Docs: Configure SSO with Grafana](https://learn.microsoft.com/en-us/azure/active-directory/saas-apps/grafana-tutorial)  

---

## ✅ Expected Outcomes
By using this project, students and practitioners will:  
- Learn to deploy **infrastructure as code** with Terraform on Azure  
- Deploy **Grafana OSS** backed by an external PostgreSQL database  
- Understand how to design a **multi-tenant SaaS system** on Azure  
- Enable **secure login** with Azure Entra ID  
- Explore scaling and automation patterns for **customer onboarding**  
