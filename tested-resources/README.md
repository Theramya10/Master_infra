markdown
# 🚀 Enterprise Azure Infrastructure as Code (IaC) Master Framework

![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4.svg?style=for-the-badge&logo=terraform)
![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Infrastructure as Code](https://img.shields.io/badge/Infrastructure-As%20Code-brightgreen?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge)

Welcome to the **Azure Master Infrastructure Framework**. This repository provides a highly scalable, modular, and production-ready Terraform architecture designed to standardize and accelerate Azure deployments across Dev, QA, and Production environments.

By utilizing a centralized module registry and parameterized environment templates, teams can deploy secure, compliant, and robust cloud infrastructure in minutes rather than days. 

---

## 💡 Value Proposition for Businesses & DevOps Teams

If you are looking for a reliable DevOps architect to streamline your cloud operations, this repository demonstrates my approach to enterprise-grade infrastructure:

*   **Zero-Friction Provisioning:** Abstracted complexity allows application teams to deploy environments simply by providing variables, eliminating the need to write complex core infrastructure code.
*   **DR-Ready State Management:** Remote backend configuration utilizing Azure Storage Accounts with dynamic keys per environment (`dev`, `prod`, etc.) ensures state security and isolation[cite: 1].
*   **Modular Architecture:** Granular, independently versioned modules for networking, security, and compute allow for high reusability and isolated blast radiuses[cite: 1].
*   **Built-in Security:** Default implementations of Azure Firewall, Bastion, Network Security Groups (NSGs), and Key Vault ensure secure-by-design deployments[cite: 1].

---

## 🏗️ Architecture & Core Modules

This master framework is composed of pre-tested, hardened Azure modules located in the `module` directory[cite: 1]. 

| Module | Resource / Service | Description |
| :--- | :--- | :--- |
| **`appget`** | Application Gateway | Layer 7 load balancing with Web Application Firewall (WAF) capabilities[cite: 1]. |
| **`bastion`** | Azure Bastion | Secure and seamless RDP/SSH connectivity to VMs directly from the Azure portal[cite: 1]. |
| **`FW`** | Azure Firewall | Managed, cloud-based network security service that protects VNet resources[cite: 1]. |
| **`KeyV`** | Azure Key Vault | Secure secret management, certificate storage, and encryption key safeguarding[cite: 1]. |
| **`nsg`** | Network Security Groups | Network traffic filtering across Azure subnets and network interfaces[cite: 1]. |
| **`peering`** | VNet Peering | Seamless routing and connectivity between regional and global Virtual Networks[cite: 1]. |
| **`rg`** | Resource Group | Logical lifecycle management containers for Azure resources[cite: 1]. |
| **`rt`** | Route Tables | Custom user-defined routing (UDR) for forced tunneling and strict traffic control[cite: 1]. |
| **`subnet`** | Subnets | Segmented networking for isolated resource deployment[cite: 1]. |
| **`vm`** | Virtual Machines | Scalable IaaS compute instances (Windows/Linux)[cite: 1]. |
| **`vnet`** | Virtual Network | The fundamental building block for your private network in Azure[cite: 1]. |

---

## 📂 Repository Structure

The framework enforces a strict separation between reusable modules and environment-specific instantiations (templates).

text
ADO_MASTER/                   # Root repository[cite: 1]
├── module/                   # Reusable, version-controlled Terraform modules[cite: 1]
│   ├── appget/              [cite: 1]
│   ├── bastion/             [cite: 1]
│   ├── FW/                  [cite: 1]
│   ├── KeyV/                [cite: 1]
│   ├── nsg/                 [cite: 1]
│   ├── peering/             [cite: 1]
│   ├── rg/                  [cite: 1]
│   ├── rt/                  [cite: 1]
│   ├── subnet/              [cite: 1]
│   ├── vm/                  [cite: 1]
│   └── vnet/                [cite: 1]
│
├── tested-resources/         # Environment templates that call the modules[cite: 1]
│   ├── dev/                  # Development environment deployment[cite: 1]
│   │   ├── main.tf           # Module calls and local configurations[cite: 1]
│   │   ├── providers.tf      # Azure provider and backend block[cite: 1]
│   │   ├── variables.tf      # Environment-specific variable definitions[cite: 1]
│   │   └── terraform.tfvars  # Variable values for Dev[cite: 1]
│   ├── qa/                   # QA environment deployment template (Coming Soon)
│   └── prod/                 # Production environment deployment template (Coming Soon)
│
└── README.md                 # Project documentation[cite: 1]



---

## ⚙️ How to Use (For Internal Teams)

To deploy an environment (e.g., `dev`), navigate to the corresponding folder in `tested-resources` and initialize Terraform. The configuration relies on an Azure backend for state management.

1. **Navigate to the target environment:**
bash
cd tested-resources/dev




2. **Review the Provider & Backend Configuration (`providers.tf`):**
Ensure your Azure Storage Account details match your subscription state backend.


hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "dev"                   # Replace with state RG[cite: 1]
    storage_account_name = "theramya10"            # Replace with Storage Account name[cite: 1]
    container_name       = "theramya10"            # Replace with container name[cite: 1]
    key                  = "terraform.tfstate-prod" # State file locking key[cite: 1]
  }
}




3. **Deploy:**
bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan





---

## 🤝 Let's Work Together

I am an experienced **Cloud Architect & DevOps Engineer** specializing in Azure, Terraform, CI/CD pipelines (Azure DevOps, GitHub Actions), and scalable infrastructure design.

If your organization is struggling with inconsistent deployments, manual infrastructure management, or security compliance, I can help you build automated, rock-solid foundations.

📫 **Open to Freelance & Contract Opportunities!**

* **Email:** theramya10@gmail.com
* **LinkedIn:** https://www.linkedin.com/in/theramya10/
* **Portfolio/Website:** theramya10.com

Feel free to star ⭐ this repository if you find this architecture useful!
