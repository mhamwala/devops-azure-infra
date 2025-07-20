# Azure Infrastructure Deployment with Terraform

This repository contains an Infrastructure as Code (IaC) solution using Terraform to deploy a secure Azure cloud infrastructure. for virtual machine infrastructure (resource group, VNet with public and private subnets, NSGs, jump box, private VMs), storage configuration (storage account with encryption, file share mounted via SMB, lifecycle policies), and optional user management (Azure Entra ID users, SSH key generation).

The setup uses modular Terraform code with modules for networking, compute, storage, and user management.

## Prerequisites

Before running the deployment, ensure you have the following:

1. **Azure Account**:
   - A free Azure account with an active subscription. Sign up at [azure.microsoft.com/free](https://azure.microsoft.com/free) if you don't have one (includes $200 credit for 30 days and free services like 750 hours of B1s VMs/month).
   - Azure CLI installed and authenticated: Install from [docs.microsoft.com/cli/azure/install-azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli), then run `az login`.
   - Verified domain in Azure Entra ID for user creation (use your default `<yourtenant>.onmicrosoft.com` or verify a custom domain in the Azure portal under Entra ID > Custom domain names).

2. **Terraform Installation**:
   - Terraform v1.5.0 or later. Install via Homebrew (macOS): `brew install terraform`, or download from [terraform.io/downloads](https://www.terraform.io/downloads.html).
   - Verify: `terraform -version`.

3. **Local Tools**:
   - Git for cloning the repo: Install via Homebrew (macOS): `brew install git`.
   - SSH client (built-in on macOS/Linux).
   - Optional: VS Code for editing files: `brew install --cask visual-studio-code`.

4. **SSH Key**:
   - Generate an SSH key pair if you don't have one: Run `ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""` (creates public key at `~/.ssh/id_rsa.pub` and private at `~/.ssh/id_rsa`).
   - This key is used for VM access. If using a different key, update the path in `main.tf` (e.g., `file("~/.ssh/your_key.pub")`) or set the public key string in tfvars.

5. **Update tfvars**: (After git clone)
   - Edit `environments/dev/terraform.tfvars`:
     - Set `allowed_ssh_ips` to your public IP: Run `curl ifconfig.me` to get it, then set `allowed_ssh_ips = ["<your_ip>/32"]`.
     - Set `users` with your verified Entra ID domain (e.g., `user1@<yourtenant>.onmicrosoft.com`). The domain must be verified in Azure; use the default onmicrosoft.com if no custom domain is verified.
     - `ssh_public_key`: Set to your SSH public key string or keep as default if using `file("~/.ssh/id_rsa.pub")` in `main.tf`.

## Directory Structure

The project is organized as follows:
```
.
├── README.md                     # This file
├── environments                  # Environment-specific tfvars files
│   ├── dev
│   │   └── terraform.tfvars      # Dev environment variables
│   └── prd
│       └── terraform.tfvars      # Prod environment variables (empty by default)
├── main.tf                       # Root Terraform configuration (resource group, module calls)
├── modules                       # Modular components
│   ├── compute                   # VM creation
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── networking                # VNet, subnets, NSGs
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── storage                   # Storage account, file share, lifecycle policies
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── user_management           # Entra ID users, SSH keys, sudo config
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf                    # Global outputs (e.g., resource group name, user passwords)
├── terraform.tf                  # Terraform and provider configuration
├── terraform.tfstate             # State file (git ignored)
├── terraform.tfstate.backup      # Backup state (git ignored)
└── variables.tf                  # Root variables and defaults
```

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone <your-repo-url>
   cd devops-azure-infra
   ```

2. **Configure Variables**:
   - Open `environments/dev/terraform.tfvars` and update:
     - `allowed_ssh_ips`: Your public IP for SSH access (e.g., `["203.0.113.10/32"]`).
     - `users`: Set `user_principal_name` with your verified Entra ID domain (e.g., `user1@<yourtenant>.onmicrosoft.com`).
     - `ssh_public_key`: Set to your SSH public key string or keep as default if using `file("~/.ssh/id_rsa.pub")` in `main.tf`.

3. **Initialize Terraform**:
   - Download providers and modules:
     ```bash
     terraform init
     ```

## Run Commands

1. **Plan the Deployment**:
   - Preview changes:
     ```bash
     terraform plan -var-file=environments/dev/terraform.tfvars
     ```
     - Expected: Shows resources to create (resource group, VNet, subnets, NSGs, jump box, private VMs, storage account, file share, Entra ID users, SSH keys).
   - Note: Before planning, ensure you have your Azure subscription ID, you will be prompted to enter it before the plan and apply (or run `az account set --subscription <id>` in Azure CLI).

2. **Apply the Deployment**:
   - Create the infrastructure:
     ```bash
     terraform apply -var-file=environments/dev/terraform.tfvars
     ```
     - Confirm with `yes`. This will create:
       - Resource Group: `devops-azure-exercise-dev-rg`.
       - Networking: VNet, public/private subnets, NSGs allowing SSH.
       - Compute: Jump box in public subnet, two private VMs in private subnet.
       - Storage: Storage account with encryption, file share mounted on VMs via SMB, lifecycle policies (archive after 7 days, delete after 365 days).
       - Users: Entra ID users with generated passwords and SSH keys; sudo restrictions configured on VMs.
     - Duration: ~5-10 minutes.

3. **View Outputs**:
   - Run `terraform output` to see values like `resource_group_name`, `user_ssh_public_keys`, `user_passwords` (sensitive, use `terraform output user_passwords` for specific ones).

4. **Verify Deployment**:
   - **SSH to Jump Box**: Get IP from `terraform output jumpbox_public_ip` (add to `outputs.tf` if missing).
     ```bash
     ssh -A -i ~/.ssh/id_rsa azureuser@<jumpbox_ip>
     ```
   - **SSH to Private VMs**: From jump box:
     ```bash
     ssh azureuser@<private_vm_ip>  # Get IPs from `terraform output vm_private_ips`
     ```
   - **Check File Share**: On VMs:
     ```bash
     df -h | grep vmshare
     ```
   - Azure Portal: Log in to portal.azure.com, check resource group for created resources.

     <img width="1121" height="289" alt="Screenshot 2025-07-19 at 14 49 35" src="https://github.com/user-attachments/assets/6ea27604-5a6c-4578-898b-1711d7e1ae2b" />

     <img width="779" height="945" alt="Screenshot 2025-07-19 at 14 47 30" src="https://github.com/user-attachments/assets/cd160b19-dff3-4805-8058-7e8b7ff65fd9" />

## Cleanup

To avoid charges, destroy the infrastructure:
```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```
- Confirm with `yes`. This deletes all resources.

## Troubleshooting
- **Intermittent Network Errors** (e.g., "HTTP response was nil; connection may have been reset" during resource creation):
  - This is usually a temporary connectivity issue with the Azure API. Simply re-run the apply command:
    ```bash
    terraform apply -var-file=environments/dev/terraform.tfvars
    ```
  - If it persists, check your internet connection, switch networks, or run with reduced parallelism: `terraform apply -var-file=environments/dev/terraform.tfvars --parallelism=1`.
- **SSH Connection Issues**: Ensure your public IP matches `allowed_ssh_ips` in tfvars. Use `curl ifconfig.me` to check and update tfvars if changed, then re-apply.
- **Mount Errors for File Share**: If `df -h | grep vmshare` is empty, manually mount (see script in modules/compute/mount_share.sh.tpl) or check dmesg for CIFS errors.
- **Other Errors**: Run `terraform validate` for syntax issues. For runtime errors, check Azure portal logs.

## Notes
- **Costs**: Stays within Azure free tier (750 hours B1s VMs/month, 5GB storage). Monitor billing in the Azure portal.
- **Security**: Use restricted IPs in `allowed_ssh_ips`. SSH keys are generated per user; store private keys securely (do not commit to Git).
- **Troubleshooting**: If errors occur, run `terraform validate`. Check logs or share error output for help.

- **TO DO**: 
   - write shell script to set allowed ssh_keys and update the domain id.
   - use Azure Key Vault for secrets (passwords, keys).
   - split resources into separate resource groups
   - add prd/staging envionments can copy dev tfvars and use unique config (scaled up to meet prd demends)
   - create pipeline to deploy these resources
```