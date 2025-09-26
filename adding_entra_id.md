# Adding Azure Entra ID Login for GitLab Customers

This guide explains how to integrate **Azure Entra ID (formerly Azure AD)** with GitLab so customers can log in using their Microsoft accounts instead of local GitLab accounts.

---

## 🔑 Idea
- GitLab = **Service Provider (SP)**  
- Azure Entra ID = **Identity Provider (IdP)**  
- Authentication via **OAuth 2.0** (simpler than SAML for this setup).  

---

## 🛠️ Steps in Azure Portal (Entra ID)

### Step 1 — Register GitLab as an App
1. Go to **Azure Portal** → **Azure Active Directory** (Entra ID).  
2. Select **App registrations** → **+ New registration**.  
3. Enter:  
   - **Name:** `GitLab-CustomerA`  
   - **Supported account types:** *Accounts in this organizational directory only (single tenant)*  
   - **Redirect URI:**  
     ```
     http://<GITLAB_EXTERNAL_URL>/users/auth/azure_oauth2/callback
     ```
     Example: `http://gitlab-custa.example.com/users/auth/azure_oauth2/callback`  
4. Click **Register**.  

---

### Step 2 — Create a Client Secret
1. Inside the new app → **Certificates & secrets** → **New client secret**.  
2. Copy the generated **Value** → you will need it in GitLab config.  

---

### Step 3 — Add API Permissions
1. Go to **API permissions** → **+ Add permission**.  
2. Choose **Microsoft Graph** → **Delegated permissions**.  
3. Add:  
   - `openid`  
   - `profile`  
   - `email`  
4. Click **Grant admin consent**.  

---

### Step 4 — Collect App Details
You will need these for GitLab:  
- **Client ID** (Application ID)  
- **Client Secret** (from Step 2)  
- **Tenant ID** (Directory ID, found in **Overview**)  

---

## 🛠️ Steps in GitLab

### Step 5 — Configure OmniAuth
Edit the GitLab configuration file `/etc/gitlab/gitlab.rb` and add the following block (replace placeholders):  

```ruby
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['azure_oauth2']
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_providers'] = [
  {
    "name" => "azure_oauth2",
    "label" => "Azure Entra ID",
    "args" => {
      "client_id" => "<APPLICATION_CLIENT_ID>",
      "client_secret" => "<CLIENT_SECRET>",
      "tenant_id" => "<TENANT_ID>"
    }
  }
]
```

Apply the changes by reconfiguring GitLab:  

```bash
sudo gitlab-ctl reconfigure
```

---

### Step 6 — Test Login
- Open the GitLab instance in a browser.  
- On the login page, click **“Sign in with Azure Entra ID”**.  
- Authenticate with your Azure account.  

---

## 🎯 Multi-Customer Considerations
- **Per-customer apps:** Register one Entra app per GitLab instance (Customer A, Customer B, etc.).  
- **Automation:** Terraform can inject each customer’s `client_id`, `client_secret`, and `tenant_id` into `/etc/gitlab/gitlab.rb` via `cloud-init`.  
- **Advanced option:** Use a **multi-tenant Azure app** and manage access via Conditional Access or Azure AD Groups if you want to centralize login.  

---

## 📚 References
- [GitLab OAuth2 Generic Provider](https://docs.gitlab.com/ee/integration/oauth2_generic.html)  
- [Microsoft Docs: Register an app with Microsoft identity platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)  
- [Microsoft Docs: Configure SSO with GitLab](https://learn.microsoft.com/en-us/azure/active-directory/saas-apps/gitlab-tutorial)  

---
