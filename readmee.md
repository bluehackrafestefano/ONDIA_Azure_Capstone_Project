# GitLab as a Service on Azure (Terraform Project)

## 🚀 Quickstart
1. Initialize Terraform:  
   ```bash
   terraform init
   ```

2. Preview the plan:  
   ```bash
   terraform plan -var "pg_password=YourSecurePassword123"
   ```

3. Apply:  
   ```bash
   terraform apply -var "pg_password=YourSecurePassword123"
   ```

4. Once done, get the GitLab VM IP:  
   ```bash
   terraform output gitlab_vm_public_ip
   ```

Open `http://<VM_IP>` in your browser.  

---

## ✅ Expected Outcome
- One GitLab VM running with an external PostgreSQL DB  
- Accessible via Azure Load Balancer  
- Infrastructure codified in Terraform  

---

## 📚 References
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  
- [Azure Database for PostgreSQL Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/)  
- [GitLab CE installation guide](https://about.gitlab.com/install/#ubuntu)  
