# Azure Infrastructure Deployment with Terraform

This repository contains an Infrastructure as Code (IaC) solution using Terraform to deploy a secure Azure cloud infrastructure. for virtual machine infrastructure (resource group, VNet with public and private subnets, NSGs, jump box, private VMs), storage configuration (storage account with encryption, file share mounted via SMB, lifecycle policies), and optional user management (Azure Entra ID users, SSH key generation).

The setup uses modular Terraform code with modules for networking, compute, storage, and user management.

## Prerequisites

Before running the deployment, ensure you have the following:

1. **Azure Account**:
   - Azure account with an active subscription.
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
   - Generate an SSH key pair: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure-vm-key -N ""`.
   - Update `environments/dev/terraform.tfvars` with your SSH public key if not using `file("~/.ssh/id_rsa.pub")` in `main.tf`.

5. **Update tfvars**:
   - Edit `environments/dev/terraform.tfvars`:
     - Set `allowed_ssh_ips` to your public IP: Run `curl ifconfig.me` to get it, then set `allowed_ssh_ips = ["<your_ip>/32"]`.
     - Set `users` with your verified Entra ID domain (e.g., `testuser@<yourtenant>.onmicrosoft.com`).

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

3. **View Outputs**:
   - Run `terraform output` to see values like `resource_group_name`, `user_ssh_public_keys`, `user_passwords` (sensitive, use `terraform output user_passwords` for specific ones).

4. **Verify Deployment**:
   - **SSH to Jump Box**: Get IP from `terraform output jumpbox_public_ip` (add to `outputs.tf` if missing).
     ```bash
     ssh -i ~/.ssh/azure-vm-key azureuser@<jumpbox_ip>
     ```
   - **SSH to Private VMs**: From jump box:
     ```bash
     ssh azureuser@<private_vm_ip>  # Get IPs from `terraform output vm_private_ips`
     ```
   - **Check File Share**: On VMs:
     ```bash
     df -h | grep myshare
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


## Notes
- **Costs**: Stays within Azure free tier (750 hours B1s VMs/month, 5GB storage). Monitor billing in the Azure portal.
- **Security**: Use restricted IPs in `allowed_ssh_ips`. SSH keys are 
- **Troubleshooting**: If errors occur, run `terraform validate`. Check logs or share error output for help.


- **TO DO**: 
   - use Azure Key Vault for secrets (passwords, keys).
   - split resources into separate resource groups
   - finish parametising modules, so that prd/staging envionments can have unique config
   - fix deprecating references
   - create pipeline to deploy these resources
