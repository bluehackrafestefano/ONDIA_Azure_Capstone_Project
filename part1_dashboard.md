# GitLab as a Service on Azure — Manual Steps (1–6)

Below are **step-by-step manual instructions** in the Azure Portal for the first six steps of the lab. Do these manually first so students understand the resources Terraform will create later.

---

## Step 1 — Create a Resource Group
1. Sign in to the **Azure Portal** (https://portal.azure.com).  
2. Search for **Resource groups** and click it.  
3. Click **+ Create**.  
4. Select your **Subscription**, enter a **Resource group name** (e.g. `gitlab-rg`), choose a **Region** (e.g. `West Europe`).  
5. (Optional) Add Tags.  
6. Click **Review + create** → **Create**.  

---

## Step 2 — Create a Virtual Network & Subnet
1. In the portal, go to the **gitlab-rg** resource group.  
2. Click **+ Add** → search **Virtual Network** → Click **Create**.  
3. Fill in:  
   - **Name:** `gitlab-vnet`  
   - **Region:** same region as RG  
   - **Address space:** `10.0.0.0/16`  
4. Under **IP Addresses** → **Subnets** → add a subnet:  
   - **Subnet name:** `gitlab-subnet`  
   - **Subnet address range:** `10.0.1.0/24`  
5. Click **Review + create** → **Create**.  

---

## Step 3 — Create a Public IP
1. In the resource group, click **+ Add** → search **Public IP address** → **Create**.  
2. Configure:  
   - **Name:** `gitlab-pip`  
   - **SKU:** `Standard`  
   - **Assignment:** `Static`  
   - (Optional) **DNS name label:** `gitlab-demo-<unique>`  
3. Click **Review + create** → **Create**.  

---

## Step 4 — Create a Linux VM (Ubuntu) and install GitLab
1. In the resource group, click **+ Add** → search **Virtual Machine** → **Create**.  
2. Basics:  
   - **Subscription / Resource group:** `gitlab-rg`  
   - **Virtual machine name:** `gitlab-vm`  
   - **Region:** same as RG  
   - **Image:** `Ubuntu Server 20.04 LTS`  
   - **Size:** `Standard_B2s` (demo)  
   - **Authentication type:** `SSH public key` → paste your public key or upload a key file  
   - **Username:** `azureuser` (or your preferred admin user)  
3. Networking tab:  
   - **Virtual network:** `gitlab-vnet`  
   - **Subnet:** `gitlab-subnet`  
   - **Public IP:** select the existing `gitlab-pip` (so the VM gets the public IP you created)  
   - **Network security group (Inbound ports):** Allow at least `SSH (22)` and `HTTP (80)` (add `HTTPS (443)` if you plan to enable SSL)  
4. Review + Create → Create. Wait until deployment completes.  

**SSH to the VM (from your workstation):**  
```bash
ssh azureuser@<VM_PUBLIC_IP> -i ~/.ssh/id_rsa
```

**Install GitLab CE on the VM (run on the VM as a user with sudo):**  
```bash
# update & install curl (if needed)
sudo apt-get update && sudo apt-get install -y curl

# add GitLab repo and install (demo, uses HTTP external URL)
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
# set EXTERNAL_URL to the VM IP for now, then install
sudo EXTERNAL_URL="http://$(curl -s http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2021-02-01&format=text)" apt-get install -y gitlab-ce

# alternatively, if you want to use the public IP:
# sudo EXTERNAL_URL="http://<VM_PUBLIC_IP>" apt-get install -y gitlab-ce
```

> After installation, GitLab runs on port 80. Retrieve the initial root password (if present) with:  
```bash
sudo cat /etc/gitlab/initial_root_password || echo "Check /etc/gitlab or follow install output for the root password"
```

---

## Step 5 — Create an Azure Database for PostgreSQL (Flexible Server)
1. In the resource group, click **+ Add** → search **Azure Database for PostgreSQL flexible server** → **Create**.  
2. Basics tab:  
   - **Subscription / Resource group:** `gitlab-rg`  
   - **Server name:** `gitlab-db` (must be globally unique)  
   - **Region:** same as RG  
   - **Workload type / Version:** PostgreSQL `13` (recommended for GitLab compatibility)  
3. Compute + storage: choose a small tier for demo (e.g. `Burstable B1ms`) and a modest storage (e.g. 32 GB).  
4. Authentication: set **Administrator username** (e.g. `pgadmin`) and a **strong password**. Keep these values safe.  
5. Networking: choose how the VM will connect:  
   - **Option A (simple):** Public access for now — allow access from selected IP ranges or **Allow Azure services and resources to access this server** (easy for demo).  
   - **Option B (more secure):** Configure VNet integration (requires delegated subnet). For the classroom demo, Option A is faster.  
6. Review + Create → Create. Wait for deployment.  

**Allow VM to connect (if using firewall rules):**  
- In the PostgreSQL server, go to **Connection security** → add the GitLab VM public IP or the VNet/subnet as allowed client IP.  

**Create GitLab DB and user (from the VM):**  
1. Install a PostgreSQL client on the VM:  
```bash
sudo apt-get update && sudo apt-get install -y postgresql-client
```

2. Connect and create the DB (replace placeholders):  
```bash
psql "host=<PG_HOSTNAME> port=5432 user=<pgadmin> password=<your_password> sslmode=require" -c "CREATE DATABASE gitlabhq_production;"
psql "host=<PG_HOSTNAME> port=5432 user=<pgadmin> password=<your_password> sslmode=require" -c "CREATE USER gitlabuser WITH PASSWORD 'gitlabpass'; GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production TO gitlabuser;"
```

> Note: for production, use secure credentials, SSL enforcement, and a private network.

---

## Step 6 — Create a Public Load Balancer and Add the VM to the Backend Pool
1. In the resource group, click **+ Add** → search **Load Balancer** → **Create**.  
2. Basics:  
   - **Name:** `gitlab-lb`  
   - **Region:** same region as RG  
   - **Type:** `Public`  
   - **SKU:** `Standard`  
   - **Frontend IP configuration:** choose the existing `gitlab-pip` public IP (created in Step 3).  
3. Create the LB, then:  
   - Under the LB, go to **Backend pools** → **Add** → create a backend pool (e.g. `gitlab-backend`) and **Add** the VM NIC(s) of `gitlab-vm`.  
   - Under **Health probes** → **Add** → create a probe:  
     - **Protocol:** `HTTP` or `TCP` (HTTP on `/` is fine)  
     - **Port:** `80`  
     - **Interval/Unhealthy threshold:** defaults ok for demo.  
   - Under **Load balancing rules** → **Add** → create a rule:  
     - **Name:** `http-rule`  
     - **Frontend IP:** the frontend configured earlier  
     - **Frontend port:** `80`  
     - **Backend port:** `80`  
     - **Backend pool:** `gitlab-backend`  
     - **Health probe:** select the probe you created  
4. Ensure the VM's Network Security Group allows inbound traffic from the Load Balancer and from Internet on port 80 (and SSH from your IP). Standard LB uses the public IP and forwards traffic; NSG must allow it.  

**Verify:**  
- Open a browser and navigate to `http://<LOAD_BALANCER_PUBLIC_IP>` (or the DNS label if you set one). You should see the GitLab web UI (initial setup / sign-in).  
- If you used the VM public IP earlier and changed to the LB, confirm GitLab `EXTERNAL_URL` matches the LB IP or DNS; otherwise reconfigure GitLab (`sudo gitlab-ctl reconfigure`) with the LB hostname/IP as `external_url`.

---

### Quick Tips & Notes
- Use **strong passwords** for the PostgreSQL admin and GitLab DB user (don’t use `Password123!` in production).  
- For demo simplicity we allowed public DB access; for production use VNet or private endpoints.  
- If GitLab web UI doesn’t load, check: VM status, NSG inbound rules, LB backend health probe, and GitLab service `sudo gitlab-ctl status`.  
- Keep region/locations consistent across resources to avoid cross-region networking issues.

---

You now have the manual steps (1–6) completed. Want me to produce these same exact values as a Terraform snippet (so students can compare fields side-by-side)?  
