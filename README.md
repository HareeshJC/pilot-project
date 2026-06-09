<p align="center">
  <a href="" rel="noopener">
  <img width=200px height=200px src="https://i.imgur.com/6wj0hh6.jpg" alt="Project logo"></a>
</p>

<h3 align="center">Pilot Project - Cloud-Native Service Platform on Azure</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)
[![Terraform](https://img.shields.io/badge/terraform-~%3E1.13.3-623CE4?logo=terraform)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/azure-cloud-0078D4?logo=microsoft-azure)](https://azure.microsoft.com/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions)](https://github.com/features/actions)
[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)

</div>

---

<p align="center"> 
Platform Engineer assessment project demonstrating enterprise-grade SRE and DevOps practices on Azure. Implements a cloud-native service platform with containerized APIs, asynchronous messaging, Infrastructure-as-Code deployments, and comprehensive automation using GitHub Actions and Terraform.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Assessment Requirements Checklist](#assessment-requirements-checklist)
- [Cost Analysis](#cost-analysis)
- [Prerequisites](#prerequisites)
- [GitHub Configuration](#github-configuration)
  - [GitHub Secrets](#github-secrets)
  - [GitHub Variables](#github-variables)
- [Container Apps Configuration](#container-apps-configuration)
  - [Required Environment Variables](#required-environment-variables)
  - [Deployment Prerequisites](#deployment-prerequisites)
  - [appsettings.json Best Practices](#appsettingsjson-best-practices)
- [CI/CD Pipelines](#cicd-pipelines)
  - [Application Deployment Pipeline](#application-deployment-pipeline)
  - [Infrastructure Deployment Pipeline](#infrastructure-deployment-pipeline)
  - [Workflow Orchestration & Dependencies](#workflow-orchestration--dependencies)
- [Getting Started](#getting-started)
- [API Specifications](#api-specifications)
- [Infrastructure & IaC](#infrastructure--iac)
- [Observability & Monitoring](#observability--monitoring)
- [Security Implementation](#security-implementation)
- [Scaling & Resilience](#scaling--resilience)
- [Deployment](#deployment)
- [Design Decisions](#design-decisions)
- [Troubleshooting](#troubleshooting)
- [Known Limitations](#known-limitations)
- [Optional Enhancements](#optional-enhancements)
- [Contributing](#contributing)
- [Authors](#authors)

## 🧐 About <a name = "about"></a>

This project implements a **Platform Engineer hands-on assessment** for SRE/DevOps roles, showcasing enterprise-grade infrastructure and application patterns on Azure. It demonstrates proficiency in:

- **Infrastructure as Code (IaC)** using Terraform with modular, reusable designs
- **CI/CD Automation** with GitHub Actions for build, test, and deployment (both apps and infrastructure)
- **Cloud-Native Architecture** leveraging Azure Container Apps, Service Bus, and Application Insights
- **Observability** implementing health checks, monitoring, alerting, and distributed tracing
- **Security Best Practices** with managed identities, Azure Key Vault, and secret management
- **Resilience Patterns** including retry logic, message dead-lettering, and auto-scaling strategies
- **Workflow Orchestration** coordinating complex multi-stage infrastructure deployments

The platform demonstrates production-ready patterns for containerized microservices deployment with asynchronous message processing, comprehensive monitoring, and fully automated CI/CD pipelines.

## 🏗️ Architecture Overview <a name="architecture-overview"></a>

### High-Level Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                    GitHub Repository & Actions                             │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │         Source Code & Infrastructure Code                            │  │
│  │  (src/, 01_landing_zone/, 02_shared/, 03_integrations/,              │  │
│  │   04_modules/, 05_project/)                                          │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                │                                           |
│                  ┌─────────────┼─────────────┐                             |
│                  ▼             ▼             ▼                             |
│          App CI/CD        Infra CI/CD    Other Workflows                   |
│    (build-and-deploy) (dv01-landing-shared,                                |
│                        dv01-pilot-integrations)                            |
└────────────────────────────────────────────────────────────────────────────┘
         │                    │
         │                    ▼
         │           ┌──────────────────────────────────┐
         │           │  Terraform Workflows             │
         │           │  (template-terraform.yml)        │
         │           │  (terraform-deploy.yml)          │
         │           └──────────────────────────────────┘
         │              │         │         │         │
         ▼              ▼         ▼         ▼         ▼
    ┌──────────┐  ┌──────┐  ┌──────┐  ┌───────┐  ┌───────┐
    │   ACR    │  │ VNet │  │ Key  │  │ App   │  │Service│
    │(Images)  │  │      │  │Vault │  │Insights  │ Bus   │
    └──────────┘  └──────┘  └──────┘  └───────┘  └───────┘
         │
         ▼
    ┌──────────────────────────────┐
    │ Container Apps Environment   │
    │  ┌──────┐      ┌──────────┐  │
    │  │ API  │◄────►│  Worker  │  │
    │  └──────┘      └──────────┘  │
    └──────────────────────────────┘
```

### Deployment Flow
```
1. APPLICATION DEPLOYMENT (Legacy Workflow)
   └─ build-and-deploy.yml
      ├─ build-and-test
      ├─ build-api-image → ACR
      ├─ build-worker-image → ACR
      ├─ deploy-api → Azure Container Apps
      ├─ deploy-worker → Azure Container Apps
      └─ post-deployment-verification

2. APPLICATION DEPLOYMENT (Reusable Workflow Architecture)
   ├─ api-build-deploy.yml
   │  └─ reusable-containerapp-build-deploy.yml
   │     ├─ Build API
   │     ├─ Run API Tests
   │     ├─ Build Docker Image
   │     ├─ Push Image to ACR
   │     ├─ Deploy API Container App
   │     └─ Verify Deployment
   │
   └─ worker-build-deploy.yml
      └─ reusable-containerapp-build-deploy.yml
         ├─ Build Worker
         ├─ Run Worker Tests
         ├─ Build Docker Image
         ├─ Push Image to ACR
         ├─ Deploy Worker Container App
         └─ Verify Deployment

3. INFRASTRUCTURE DEPLOYMENT (Multi-layered)
   ├─ dv01-landing-shared.yml
   │  ├─ deploy_DV01_landingzone (template-terraform.yml)
   │  │  └─ terraform-deploy.yml (plan/apply)
   │  └─ deploy_DV01_sharedzone (template-terraform.yml)
   │     └─ terraform-deploy.yml (plan/apply)
   │
   └─ dv01-pilot-integrations.yml
      ├─ deploy_pilot_common_resources (template-terraform.yml)
      │  └─ terraform-deploy.yml (plan/apply)
      ├─ deploy_system_alerts (template-terraform.yml)
      │  └─ terraform-deploy.yml (plan/apply)
      ├─ deploy_pilot_interface_pa (template-terraform.yml)
      │  └─ terraform-deploy.yml (plan/apply)
      └─ deploy_pilot_interface_ca (template-terraform.yml)
         └─ terraform-deploy.yml (plan/apply)
```

## 🏗️ Project Structure <a name = "project-structure"></a>

```
pilot-project/
├── 01_landing_zone/                    # Landing Zone Infrastructure (VNet, Identity)
│   ├── config_backend.tf              # Terraform backend & provider config
│   ├── main.tf                         # Virtual networks, subnets, identities
│   ├── variables.tf                    # Input variables
│   ├── output.tf                       # VNet, subnet, identity outputs
│   └── variables/DV01/
│       ├── dv01.auto.tfvars           # Environment-specific values
│       └── config.backend             # Backend configuration
│
├── 02_shared/                          # Shared Services (Key Vault, App Insights, ACR, Service Bus)
│   ├── config_backend.tf              # Terraform backend & provider config
│   ├── main.tf                         # Shared resource definitions
│   ├── local.tf                        # Local variable definitions
│   ├── output.tf                       # Shared service outputs
│   └── variables/DV01/
│       ├── dv01.auto.tfvars           # Shared environment config
│       └── config.backend             # Backend configuration
│
├── 03_integrations/                    # Integration Layer (Container Apps, Worker Apps)
│   ├── config_backend.tf              # Terraform backend & provider config
│   ├── main.tf                         # Container Apps & Worker definitions
│   ├── local.tf                        # Local variables for integrations
│   └── variables/DV01/
│       ├── dv01.auto.tfvars           # Application environment config
│       └── config.backend             # Remote state backend config
│
├── 04_modules/                         # Reusable Terraform Modules
│   ├── container_app/                 # Container App module with probes
│   ├── container_app_environment/     # Container App Environment setup
│   ├── container_registry/            # Azure Container Registry
│   ├── app_insights/                  # Application Insights & monitoring
│   ├── keyvault/                      # Key Vault for secrets
│   ├── servicebus_namespace/          # Service Bus & queues
│   ├── private_dns_zone/              # Private DNS zones
│   ├── virtual_network/               # VNets & subnets
│   └── [other modules]/
│
├── 05_project/                         # Project-Specific Configuration
│   └── pilot_project/
│       ├── common_resources/          # Shared pilot resources (tfvars)
│       ├── pilot_interface/           # API and Worker apps
│       │   ├── pa/                   # API (Producer) configuration
│       │   └── ca/                   # Worker (Consumer) configuration
│       └── system_alerts/            # Alert definitions for API
│
├── src/                                # Application Source Code
│   ├── api/                           # REST API Service (.NET 8)
│   │   ├── Program.cs                 # Application entry point
│   │   ├── Controllers/               # API Endpoints
│   │   ├── Services/                  # Business Logic
│   │   ├── Models/                    # Data Models
│   │   ├── api.csproj                 # Project file
│   │   └── appsettings.json           # Configuration (env vars only)
│   │
│   ├── worker/                        # Background Worker Service (.NET 8)
│   │   ├── Program.cs                 # Worker entry point
│   │   ├── WorkerService.cs           # Message processing & retry logic
│   │   ├── Models/                    # Message models
│   │   ├── worker.csproj              # Project file
│   │   └── appsettings.json           # Configuration (env vars only)
│   │
│   ├── Dockerfile                      # Multi-stage API container image
│   ├── Dockerfile.worker              # Multi-stage Worker container image
│   └── .dockerignore                  # Docker build exclusions
│
├── .github/workflows/                 # GitHub Actions CI/CD
│   ├── build-and-deploy.yml          # **MAIN** App build & deploy (Build → Test → Push → Deploy)
│   ├── api-build-deploy.yml          # (Alternative) API-only deployment
│   ├── worker-build-deploy.yml       # (Alternative) Worker-only deployment
│   │
│   ├── dv01-landing-shared.yml       # **INFRASTRUCTURE** Landing zone & shared services deployment
│   ├── dv01-pilot-integrations.yml   # **INFRASTRUCTURE** Container Apps deployment orchestration
│   │
│   ├── template-terraform.yml        # **TEMPLATE** Reusable wrapper for Terraform workflows
│   ├── terraform-deploy.yml          # **REUSABLE** Terraform plan/apply/destroy logic
│   │
│   └── smart-commit-message-check.yml # Commit validation
│
├── .tflint.hcl                         # Terraform linting rules
├── .gitignore                          # Git ignore patterns
└── README.md                           # This file
```

## ✅ Assessment Requirements Checklist <a name = "assessment-requirements-checklist"></a>

- [x] **Infrastructure as Code** - Complete Terraform modules for landing zone, shared services, and integrations
- [x] **CI/CD Pipeline** - GitHub Actions workflows for automated build, test, and deployment (apps & infra)
- [x] **Cloud-Native Architecture** - Azure Container Apps with Service Bus messaging
- [x] **Containerization** - Multi-stage Dockerfile for API and Worker services
- [x] **Resilience & Retry Logic** - Exponential backoff retry mechanism with dead-letter queue
- [x] **Observability** - Application Insights integration, structured logging, and health checks
- [x] **Security** - Managed identities, Key Vault integration, RBAC, non-root containers
- [x] **Health Checks** - Liveness and readiness probes for Container Apps
- [x] **Asynchronous Processing** - Service Bus queue integration
- [x] **Environment Configuration** - Container app environment variables (no hardcoded secrets)
- [x] **Container Image Versioning** - Multiple tags (latest, sha, timestamp) in ACR
- [x] **Deployment Verification** - Post-deployment status checks and revision monitoring
- [x] **Infrastructure Orchestration** - Multi-stage Terraform deployments with dependencies
- [x] **Reusable Workflows** - Template pattern for consistent Terraform deployments
- [x] **Workflow Coordination** - Parallel & sequential job execution with proper dependencies

## 💰 Cost Analysis <a name = "cost-analysis"></a>

This section provides a detailed cost analysis for the Infrastructure and Application resources deployed in the DV01 (Development) environment in South India (southindia).

### Cost Estimation Overview

**Estimated Monthly Cost Range: $500 - $1,200 USD**
*(Based on assumed configurations and usage patterns)*

### Infrastructure Layer Costs (Landing Zone & Shared Services)

#### 1. **Virtual Network (VNet) & Networking**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Virtual Network | 1 VNet (10.8.0.0/16) | **Free** |
| Subnets | 1 Subnet (10.8.1.0/25) | **Free** |
| Network Security Groups (NSGs) | 1 NSG | **Free** |
| Private Endpoints | 3 endpoints (KV, ACR, Service Bus) | ~$0.50 each = **$1.50** |
| Virtual Network Peering | 1 peering link (bidirectional) | **Free** (intra-region) |
| **Networking Subtotal** | | **~$1.50** |

#### 2. **Storage & State Management**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Storage Account (Terraform State) | LRS, ~100 GB/month | **~$5-10** |
| **Storage Subtotal** | | **~$5-10** |

#### 3. **Managed Identity & IAM**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| User-Assigned Managed Identity | 1 identity | **Free** |
| RBAC Role Assignments | Multiple roles (no extra cost) | **Free** |
| **Identity Subtotal** | | **Free** |

#### 4. **Monitoring & Logging**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Log Analytics Workspace | 5 GB/day ingestion, 31-day retention | **~$30-50** |
| Application Insights | Dependency tracking, traces | **Included with LAW** |
| **Monitoring Subtotal** | | **~$30-50** |

#### 5. **Container Registry (ACR)**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Azure Container Registry | Standard SKU, ~10 GB storage | **~$10** |
| Registry Operations | Push/pull operations (free tier included) | **Free** |
| Private Endpoint (ACR) | 1 private endpoint | **~$0.50** |
| **ACR Subtotal** | | **~$10.50** |

#### 6. **Key Vault**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Azure Key Vault | Standard tier, 10-15 secrets | **~$0.34** |
| Secret Operations | Get/List operations (free tier: 10K/month) | **Free** |
| Private Endpoint (KV) | 1 private endpoint | **~$0.50** |
| **Key Vault Subtotal** | | **~$0.84** |

#### 7. **Service Bus Messaging**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Service Bus Namespace | Standard tier, 1 messaging unit | **~$10.50** |
| Service Bus Queue | 1 queue (work-queue), DLQ enabled | **Free (included)** |
| Private Endpoint (Service Bus) | 1 private endpoint | **~$0.50** |
| Message Operations | Assume 10K messages/month | **~$0.01** |
| **Service Bus Subtotal** | | **~$11.01** |

#### 8. **Azure DNS (Private DNS Zones)**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Private DNS Zone (servicebus) | 1 zone | **~$0.50** |
| Private DNS Zone (vaultcore) | 1 zone | **~$0.50** |
| Private DNS Zone (azurecr.io) | 1 zone | **~$0.50** |
| DNS Queries | Estimate 50K queries/month | **~$0.50** |
| **Private DNS Subtotal** | | **~$2.00** |

**Landing Zone & Shared Services Total: ~$61 - $81/month**

---

### Application Layer Costs (Container Apps & Workloads)

#### 1. **Container Apps Environment**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Container App Environment | 1 environment (zone-redundant capable) | **Free** |
| Infrastructure Subnet | Included in VNet | **Free** |
| **Environment Setup** | | **Free** |

#### 2. **Container App - API (Producer)**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| vCPU | 0.5 vCPU (min), 2 vCPU (max) | **~$20/month (0.5 vCPU baseline)** |
| Memory | 1 GB (min), 4 GB (max) | **~$3.50/month (1 GB baseline)** |
| Replicas | Min 2, Max 10 | Scales with demand |
| Execution Time | 730 hours/month × 0.5 vCPU | Included above |
| **API Container App** | | **~$23.50 baseline** |

#### 3. **Container App - Worker (Consumer)**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| vCPU | 0.5 vCPU (min), 2 vCPU (max) | **~$20/month (0.5 vCPU baseline)** |
| Memory | 1 GB (min), 4 GB (max) | **~$3.50/month (1 GB baseline)** |
| Replicas | Min 2, Max 10 | Scales with demand |
| Execution Time | 730 hours/month × 0.5 vCPU | Included above |
| **Worker Container App** | | **~$23.50 baseline** |

#### 4. **Load Balancing & Public Access**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Public IP (if exposed) | 1 IP address | **~$2.73/month** |
| **Load Balancing** | | **~$2.73** |

#### 5. **Health Checks & Probes**
| Resource | Configuration | Monthly Cost |
|----------|---------------|--------------|
| Liveness Probe | GET /health/live (built-in) | **Free** |
| Readiness Probe | GET /health/ready (built-in) | **Free** |
| **Health Checks** | | **Free** |

**Container Apps Total: ~$51.73 - $150+/month** *(depending on scale & traffic)*

---

### Cost Optimization Strategies

#### ✅ Current Optimizations Applied:
1. **Consumption-Based Pricing** - Pay only for vCPU/memory consumed
2. **Auto-Scaling** - Min 2 replicas, scales up to 10 based on demand
3. **Managed Services** - No VM overhead or operational management
4. **Private Endpoints** - Secure connectivity without public endpoints for sensitive services
5. **Shared Infrastructure** - One App Insights, one Key Vault for both API and Worker
6. **Standard Service Bus Tier** - Suitable for pilot/development workloads

#### 🎯 Potential Cost Reduction Measures:
1. **Reduce Logging Retention** - Currently 31 days; reduce to 7-15 days
   - **Potential Savings: $15-25/month**

2. **Consolidate Replicas** - Reduce min replicas from 2 to 1 in development
   - **Potential Savings: $11.75-23.50/month** *(not recommended for HA)*

3. **Use Shared DNS Zones** - Consolidate private DNS zones
   - **Potential Savings: $0.50-1.00/month**

4. **Move to Container Registry Basic SKU** - If image count is low
   - **Potential Savings: $5/month**

5. **Implement Request Throttling** - Reduce outbound NAT gateway costs
   - **Potential Savings: Varies**

---

### 📊 Cost Breakdown Summary

| Category | Estimated Monthly Cost |
|----------|------------------------|
| Networking & Connectivity | ~$1.50 - $5.00 |
| Monitoring & Logging | ~$30.00 - $50.00 |
| Storage & State | ~$5.00 - $10.00 |
| Container Registry | ~$10.50 |
| Key Vault | ~$0.84 |
| Service Bus | ~$11.01 |
| Private DNS | ~$2.00 |
| **Infrastructure Subtotal** | **~$61.00 - $81.00** |
| **Container Apps (Baseline)** | **~$51.73 - $100.00+** |
| **TOTAL (Development)** | **~$112.73 - $181.00+** |

> **Note:** Costs scale significantly with production traffic, data ingestion, and replicas. Premium tier and zone-redundancy would increase costs by 30-50%.

---

### Cost Monitoring & Alerts

#### Recommended Actions:
1. **Enable Azure Cost Management** - Set up budgets and alerts
2. **Review Monthly Bills** - Track actual vs. estimated costs
3. **Use Azure Advisor** - Get recommendations for cost optimization
4. **Implement Tagging** - Tag resources for cost center allocation
   - Example: `CostCenter: Development`, `Project: iPaaS`

#### Cost Management Steps:
```bash
# Enable cost alerts in Azure Portal
# 1. Navigate to Cost Management → Budgets
# 2. Create budget with threshold alerts (e.g., $200/month)
# 3. Set notification email on 80% and 100% threshold

# Track costs by resource group
az costmanagement query --scope /subscriptions/{subscription-id} \
  --timeframe MonthToDate
```

---

## 📋 Prerequisites <a name = "prerequisites"></a>

### Tools & SDKs

- **Terraform** >= 1.5.0
- **.NET SDK** 8.0 or higher
- **Azure CLI** (az) - Latest version
- **GitHub Repository** - With Actions enabled
- **Git** - For version control
- **TFLint** - For Terraform linting (optional, used in workflows)

### Azure Resources (Pre-requisites)

1. **Azure Subscription** - With appropriate permissions
2. **Azure Container Registry (ACR)** - For storing container images
3. **Container App Environment** - Pre-created for hosting applications
4. **Service Bus Namespace & Queue** - For async messaging
5. **Azure Key Vault** - For secret management
6. **Application Insights** - For monitoring and observability
7. **Storage Account** - For Terraform remote state
8. **Resource Groups** - For organizing resources
9. **Virtual Network** - For network isolation

### IAM & Service Principals

Ensure you have or create:
- **Service Principal** (for GitHub Actions OIDC authentication)
- **Managed Identity** (attached to Container Apps for accessing Azure services)
- **Federated Credentials** (for OIDC token exchange)
- Appropriate RBAC roles:
  - Contributor (for deploying resources)
  - AcrPush (for pushing images to ACR)
  - AcrPull (for Container Apps to pull images)
  - Key Vault Secrets User (for accessing secrets)
  - Storage Blob Data Owner (for Terraform state access)

---

## 🔐 GitHub Configuration <a name = "github-configuration"></a>

### GitHub Secrets <a name = "github-secrets"></a>

**Required Repository Secrets** for deployment and authentication:

| Secret Name | Required | Description | Example | Used In |
|-------------|----------|-------------|---------|---------|
| `AZURE_CLIENT_ID` | ✅ Yes | Service Principal Client ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | All workflows |
| `AZURE_TENANT_ID` | ✅ Yes | Azure AD Tenant ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | All workflows |
| `AZURE_SUBSCRIPTION_ID` | ✅ Yes | Azure Subscription ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | App deploy workflows |
| `EA_AZURE_AD_CLIENT_ID` | ✅ Yes | Service Principal Client ID (Terraform) | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Terraform workflows |
| `EA_AZURE_AD_TENANT_ID` | ✅ Yes | Azure AD Tenant ID (Terraform) | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Terraform workflows |
| `EA_AZURE_AD_OBJECT_ID` | ❌ No | Service Principal Object ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Terraform workflows |
| `AZURE_DV01_SUBSCRIPTION_ID` | ✅ Yes | Development Subscription ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Terraform (DV01) |
| `AZURE_STATE_SUBSCRIPTION_ID` | ✅ Yes | State Storage Subscription ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | Terraform backend |
| `REGISTRY_LOGIN_SERVER` | ✅ Yes | ACR URL | `myregistry.azurecr.io` | App build & deploy |
| `REGISTRY_USERNAME` | ✅ Yes | ACR username | `<username>` or `<spn-id>` | Docker login |
| `REGISTRY_PASSWORD` | ✅ Yes | ACR password | `<password>` or `<spn-secret>` | Docker login |
| `RESOURCE_GROUP` | ✅ Yes | Azure resource group name | `rg-pilot-dv01` | App deploy workflows |
| `ENVIRONMENT` | ❌ No | Deployment environment | `dev` | App deploy workflows |
| `API_CONTAINER_APP_NAME` | ❌ No | API Container App name | `ca-api-si-dv01` | App deploy workflows |
| `WORKER_CONTAINER_APP_NAME` | ❌ No | Worker Container App name | `ca-worker-si-dv01` | App deploy workflows |

**Setup Instructions:**

```bash
# 1. Create Service Principal
az ad sp create-for-rbac --name "github-actions-sp" \
  --role "Contributor" \
  --scopes "/subscriptions/SUBSCRIPTION_ID"

# 2. Add repository secrets in GitHub
# Navigate to: Repository → Settings → Secrets and variables → Actions
# Add each secret with corresponding value

# 3. Grant ACR push access
az role assignment create \
  --role "AcrPush" \
  --assignee "SERVICE_PRINCIPAL_ID" \
  --scope "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RG_NAME/providers/Microsoft.ContainerRegistry/registries/ACR_NAME"

# 4. Configure OIDC (optional but recommended)
az ad app federated-credential create \
  --id SERVICE_PRINCIPAL_ID \
  --parameters '{"name":"github-oidc","issuer":"https://token.actions.githubusercontent.com","subject":"repo:OWNER/REPO:ref:refs/heads/main","audiences":["api://AzureADTokenExchange"]}'
```

### GitHub Variables <a name = "github-variables"></a>

**Repository Variables** for environment configuration:

| Variable Name | Required | Description | Example | Used In |
|---------------|----------|-------------|---------|---------|
| `REMOTE_STATE_BACKEND_STORAGE_ACCOUNT_NAME` | ✅ Yes | Storage account for Terraform state | `tfstatestorage` | Terraform workflows |
| `REMOTE_STATE_BACKEND_RESOURCE_GROUP_NAME` | ✅ Yes | Resource group for state storage | `rg-terraform-state` | Terraform workflows |

**Setup Instructions:**

```bash
# Navigate to: Repository → Settings → Secrets and variables → Variables
# Add each variable with corresponding value
```

---

## 🐳 Container Apps Configuration <a name = "container-apps-configuration"></a>

### Required Environment Variables <a name = "required-environment-variables"></a>

**Container Apps require proper environment variable configuration for the applications to function correctly.** These variables are set at deployment time and available to the application at runtime.

#### API Container App Environment Variables

| Variable | Required | Type | Description | Example |
|----------|----------|------|-------------|---------|
| `SERVICE_BUS_CONNECTION_STRING` | ✅ Yes | Secret | Service Bus connection string | `Endpoint=sb://servicebus.servicebus.windows.net/;...` |
| `APPINSIGHTS_INSTRUMENTATION_KEY` | ✅ Yes | Secret | Application Insights instrumentation key | `12345678-1234-1234-1234-123456789012` |
| `ServiceBus__QueueName` | ❌ No | String | Service Bus queue name | `work-queue` |
| `ServiceBus__MaxDeliveryCount` | ❌ No | Number | Max delivery attempts | `3` |
| `ASPNETCORE_ENVIRONMENT` | ❌ No | String | .NET environment | `Production` |

#### Worker Container App Environment Variables

| Variable | Required | Type | Description | Example |
|----------|----------|------|-------------|---------|
| `SERVICE_BUS_CONNECTION_STRING` | ✅ Yes | Secret | Service Bus connection string | `Endpoint=sb://servicebus.servicebus.windows.net/;...` |
| `APPINSIGHTS_INSTRUMENTATION_KEY` | ✅ Yes | Secret | Application Insights instrumentation key | `12345678-1234-1234-1234-123456789012` |
| `ServiceBus__QueueName` | ❌ No | String | Queue name to listen on | `work-queue` |
| `ServiceBus__MaxDeliveryCount` | ❌ No | Number | Max retries before dead-lettering | `3` |
| `ServiceBus__MaxConcurrentCalls` | ❌ No | Number | Parallel message processing | `10` |
| `Worker__ProcessingTimeoutMs` | ❌ No | Number | Processing timeout in ms | `30000` |
| `ASPNETCORE_ENVIRONMENT` | ❌ No | String | .NET environment | `Production` |

### Deployment Prerequisites <a name = "deployment-prerequisites"></a>

Before deploying to Container Apps, ensure:

1. **Container App Environment exists** in your resource group
2. **Container Registry is accessible** and contains images
3. **Service Bus queue is created** with proper configuration
4. **Application Insights is provisioned** for monitoring
5. **Managed Identity is configured** on Container Apps
6. **Key Vault is accessible** via managed identity
7. **Network connectivity** is properly configured

### appsettings.json Best Practices <a name = "appsettingsjson-best-practices"></a>

**✅ CORRECT - Using Environment Variables:**

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "ConnectionStrings": {
    "ServiceBusConnection": "${SERVICE_BUS_CONNECTION_STRING}"
  },
  "ServiceBus": {
    "QueueName": "work-queue",
    "MaxDeliveryCount": 3
  },
  "ApplicationInsights": {
    "InstrumentationKey": "${APPINSIGHTS_INSTRUMENTATION_KEY}"
  }
}
```

**✅ Correct .NET Configuration Binding (Program.cs):**

```csharp
var builder = WebApplication.CreateBuilder(args);
var configuration = builder.Configuration;

// Environment variables override appsettings.json values
var serviceBusConnection = configuration.GetConnectionString("ServiceBusConnection");
var instrumentationKey = configuration.GetValue<string>("ApplicationInsights:InstrumentationKey");

// Register services
builder.Services.AddApplicationInsightsTelemetry(instrumentationKey);
```

---

## 🔄 CI/CD Pipelines <a name = "cicd-pipelines"></a>

### Application Deployment Pipeline <a name = "application-deployment-pipeline"></a>

**Main Workflow: `.github/workflows/build-and-deploy.yml`**

This is the **primary workflow** for deploying the .NET 8 API and Worker services to Azure Container Apps.

**Triggers:**
- Push to main branch with changes in `src/**`
- Manual dispatch (`workflow_dispatch`)
- Pull requests (build & test only, no deployment)

**Workflow Jobs:**

```
build-and-test
  ├─ Checkout code
  ├─ Setup .NET 8
  ├─ Restore & build API
  ├─ Test API (non-blocking)
  ├─ Restore & build Worker
  ├─ Test Worker (non-blocking)
  └─ Generate build metadata (outputs)
       │
       ├──────────────────┬──────────────────┐
       ▼                  ▼                  ▼
   build-api-image   build-worker-image   (parallel)
       │                 │
       ├─ Docker Build   ├─ Docker Build
       ├─ ACR Push       ├─ ACR Push
       ├─ Tag Image      ├─ Tag Image
       └─ Summary        └─ Summary
            │                  │
            └────────┬─────────┘
                     ▼
                  (parallel)
            ┌────────┴────────┐
            ▼                 ▼
        deploy-api       deploy-worker
            │                │
            ├─ Azure Login   ├─ Azure Login
            ├─ Check Exists  ├─ Check Exists
            ├─ Update Image  ├─ Update Image
            ├─ Wait Deploy   ├─ Wait Deploy
            ├─ Verify Revs   ├─ Verify Revs
            └─ Report        └─ Report
                     │
                     ▼
              post-deployment
                     │
                ├─ Verify Status
                └─ Report
```

**Key Features:**
- ✅ Unified build and deploy for both services
- ✅ Container App existence checks (non-blocking)
- ✅ Deployment wait with 5-minute timeout
- ✅ Revision verification and reporting
- ✅ Multi-tag image strategy (latest, sha, timestamp)
- ✅ GH workflow summary output

### Infrastructure Deployment Pipeline <a name = "infrastructure-deployment-pipeline"></a>

**Workflows:**
- `dv01-landing-shared.yml` - Landing zone & shared services
- `dv01-pilot-integrations.yml` - Container Apps & application layer
- `template-terraform.yml` - Template wrapper
- `terraform-deploy.yml` - Reusable Terraform implementation

**Deployment Phases:**

#### Phase 1: Landing Zone & Shared Services (`dv01-landing-shared.yml`)

```
deploy_DV01_landingzone
  └─ template-terraform.yml
     └─ terraform-deploy.yml
        ├─ Terraform Plan (01_landing_zone)
        └─ Terraform Apply (if changes detected)

deploy_DV01_sharedzone  (can run in parallel)
  └─ template-terraform.yml
     └─ terraform-deploy.yml
        ├─ Terraform Plan (02_shared)
        └─ Terraform Apply (if changes detected)
```

**Resources Created:**
- Resource Groups & Private DNS Zones
- Virtual Networks & Subnets
- Network Security Groups
- Managed Identities
- Container Registry
- Key Vault
- Service Bus Namespace & Queue
- Log Analytics Workspace & Application Insights

#### Phase 2: Application Layer (`dv01-pilot-integrations.yml`)

```
deploy_pilot_common_resources
  └─ template-terraform.yml
     └─ terraform-deploy.yml
        └─ Terraform (05_project/pilot_project/common_resources)

deploy_system_alerts  (depends on common_resources)
  └─ template-terraform.yml
     └─ terraform-deploy.yml
        └─ Terraform (05_project/pilot_project/system_alerts)

deploy_pilot_interface_pa  (depends on common_resources, system_alerts)
  └─ template-terraform.yml
     └─ terraform-deploy.yml
        └─ Terraform (05_project/pilot_project/pilot_interface/pa)

deploy_pilot_interface_ca  (depends on pa)
  └─ template-terraform.yml
     └─ terraform-deploy.yml
        └─ Terraform (05_project/pilot_project/pilot_interface/ca)
```

**Resources Created:**
- Container App Environment
- Container Apps (API & Worker)
- Container App Scaling Rules
- Probe Configuration (liveness & readiness)

### Workflow Orchestration & Dependencies <a name = "workflow-orchestration--dependencies"></a>

#### Reusable Workflow Pattern

**`template-terraform.yml`** - Wrapper template that accepts inputs and calls the reusable workflow:

```yaml
# Accepts inputs from caller
# Passes them to terraform-deploy.yml via workflow_call
# Handles permissions delegation
```

**`terraform-deploy.yml`** - Reusable workflow implementing the actual Terraform logic:

```yaml
# Receives inputs from template
# Performs token replacement (environment variables)
# Executes terraform init, plan, validate, apply/destroy
# Manages artifacts and reporting
```

**Caller Workflows** - Orchestrate the deployment sequence:

```yaml
# dv01-landing-shared.yml
job: deploy_DV01_landingzone
  calls: template-terraform.yml
  with: [directory, variables, environment, etc.]
  
# dv01-pilot-integrations.yml
job: deploy_pilot_common_resources
  calls: template-terraform.yml
  
job: deploy_pilot_interface_pa
  needs: deploy_pilot_common_resources
  calls: template-terraform.yml
  
job: deploy_pilot_interface_ca
  needs: deploy_pilot_interface_pa
  calls: template-terraform.yml
```

#### Key Workflow Features

**Token Replacement:**
```yaml
# Replaces placeholders in Terraform files
__#environment_abbr#__ → dv
__#environment_instance#__ → 01
__#location#__ → southindia
# And 20+ other tokens
```

**Plan/Apply Orchestration:**
```
terraform-plan
  ├─ Detects changes (exitcode == 2)
  ├─ Exports plan JSON
  └─ Uploads artifacts

terraform-apply (if plan detected changes)
  ├─ Downloads plan artifact
  ├─ Applies changes
  └─ Reports results
```

**Concurrency & Safety:**
```yaml
concurrency:
  group: terraform-{{ environment }}-{{ instance }}
  cancel-in-progress: false  # Prevent conflicting runs
```

**OIDC Authentication:**
```yaml
env:
  ARM_USE_OIDC: true  # No secrets stored
  ARM_TENANT_ID: ${{ secrets.tenant_id }}
  ARM_CLIENT_ID: ${{ secrets.client_id }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.subscription_id }}
```

---

## 🚀 Getting Started <a name = "getting-started"></a>

### 1. Clone Repository

```bash
git clone https://github.com/HareeshJC/pilot-project.git
cd pilot-project
```

### 2. Set Up Local Development Environment

```bash
# Install Terraform
brew install terraform  # macOS
# or
choco install terraform  # Windows

# Verify installations
terraform version
dotnet --version
az --version
```

### 3. Azure Authentication

```bash
az login
az account set --subscription "SUBSCRIPTION_ID"
az account show
```

### 4. Local Development

```bash
# Build applications
cd src
dotnet restore
dotnet build --configuration Release

# Run tests
dotnet test --configuration Release

# Build containers
docker build -f Dockerfile -t api:latest .
docker build -f Dockerfile.worker -t worker:latest .
```

### 5. Deploy Infrastructure (Manual)

```bash
# Initialize Terraform
cd 01_landing_zone
terraform init -backend-config="path/to/backend.tfvars"

# Plan & Apply
terraform plan -var-file="variables/DV01/dv01.auto.tfvars"
terraform apply -var-file="variables/DV01/dv01.auto.tfvars"

# Repeat for other layers
cd ../02_shared
# ... same pattern
```

---

## 📡 API Specifications <a name = "api-specifications"></a>

### Health Check Endpoints

#### Liveness Probe: `GET /health/live`

- **Purpose**: Indicates if the service is running
- **Response (200 OK)**:
  ```json
  {
    "status": "healthy",
    "service": "api",
    "timestamp": "2024-01-15T10:30:45Z"
  }
  ```

#### Readiness Probe: `GET /health/ready`

- **Purpose**: Indicates if the service is ready to handle traffic
- **Response (200 OK)**:
  ```json
  {
    "status": "ready",
    "dependencies": {
      "service_bus": "connected",
      "key_vault": "connected"
    },
    "timestamp": "2024-01-15T10:30:45Z"
  }
  ```

### Work API Endpoints

#### Submit Work Item: `POST /api/work`

```json
{
  "title": "Process User Data",
  "data": {
    "userId": "user-123",
    "action": "export"
  }
}
```

**Response (202 Accepted):**
```json
{
  "workId": "d4f6e8a0-9c2b-4e5f-a1d3-7f8b6c2e1a4d",
  "status": "queued",
  "createdAt": "2024-01-15T10:30:45Z",
  "message": "Work item queued for processing"
}
```

#### Retrieve Work Items: `GET /api/work?status=completed&limit=50`

**Response (200 OK):**
```json
{
  "items": [
    {
      "workId": "d4f6e8a0-9c2b-4e5f-a1d3-7f8b6c2e1a4d",
      "status": "completed",
      "title": "Process User Data",
      "createdAt": "2024-01-15T10:30:45Z",
      "completedAt": "2024-01-15T10:32:15Z",
      "result": { "processed": true, "count": 150 }
    }
  ],
  "count": 1,
  "timestamp": "2024-01-15T10:30:45Z"
}
```

---

## 🏗️ Infrastructure & IaC <a name = "infrastructure--iac"></a>

### Terraform Module Structure

```
04_modules/
├── container_app/              # Container App definitions with probes
├── container_app_environment/  # Shared environment for Container Apps
├── container_registry/         # Azure Container Registry
├── app_insights/               # Application Insights monitoring
├── keyvault/                   # Azure Key Vault
├── servicebus_namespace/       # Service Bus with queues
├── servicebus_queue/           # Individual queue definitions
├── servicebus_queue_sas_key/   # SAS keys for queues
├── virtual_network/            # VNet, subnets, NSGs
├── resource_group/             # Resource group management
├── network_security_group/     # NSG rules
├── managed_identity/           # Managed Identity setup
└── [additional modules]/
```

### State Management

**Remote State Location:**
```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-state"
    storage_account_name  = "tfstatestorage"
    container_name        = "statestorage"
    key                   = "dv01/pilot-dv01.tfstate"
    subscription_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }
}
```

### Module Dependencies

```
01_landing_zone
├─ VNet
├─ Subnets
└─ Managed Identity
    │
    ▼
02_shared
├─ Container Registry
├─ Key Vault
├─ Service Bus
├─ Application Insights
└─ NSGs
    │
    ▼
03_integrations
└─ Container Apps (API & Worker)

05_project
├─ Common Resources
├─ System Alerts
├─ API Container App Config
└─ Worker Container App Config
```

---

## 📊 Observability & Monitoring <a name = "observability--monitoring"></a>

### Application Insights Integration

- Structured logging from .NET applications
- Automatic correlation between API and Worker
- Service Bus dependency tracking
- Performance metrics and exception monitoring

### Health Check Strategy

**Liveness Probe** (Every 10 seconds):
```
GET /health/live
├─ Timeout: 3 seconds
├─ Start Period: 5 seconds
└─ Failure Threshold: 3 retries
```

**Readiness Probe** (Before routing traffic):
```
GET /health/ready
├─ Checks: Service Bus connectivity
├─ Checks: Key Vault connectivity
└─ Checks: Dependencies status
```

---

## 🔒 Security Implementation <a name = "security-implementation"></a>

### Secret Management

**✅ Best Practices:**

1. **No Hardcoded Secrets** - All sensitive values in environment variables
2. **Key Vault Integration** - Service principals access secrets via managed identities
3. **OIDC Authentication** - GitHub Actions use keyless OIDC
4. **Container Security** - Non-root user, read-only filesystem

### Network Security

- Private Endpoints for Service Bus and Key Vault
- VNet integration for resource isolation
- Network Security Groups for traffic control
- Service Endpoints for Azure services

### RBAC & Access Control

- Container Apps: `AcrPull` role on Container Registry
- Managed Identity: `Key Vault Secrets User` role
- GitHub Actions SP: Environment-scoped Contributor role

---

## 📈 Scaling & Resilience <a name = "scaling--resilience"></a>

### Auto-Scaling Configuration

- **Min Replicas**: 2 (high availability)
- **Max Replicas**: 10 (load scaling)
- **CPU Threshold**: 70%
- **Memory Threshold**: 80%

### Retry & Backoff Strategy

```csharp
// Exponential backoff: 2^attempt * 100ms
// Attempt 0: 100ms
// Attempt 1: 200ms
// Attempt 2: 400ms
// Attempt 3: 800ms
// Attempt 4: 1600ms
// Attempt 5: 3200ms
```

### Dead-Letter Queue

- Messages exceeding max delivery count moved to DLQ
- Alerts triggered for operations team
- Manual replay capability available

---

## 🚀 Deployment <a name = "deployment"></a>

### Automated Deployment

**For Application Code:**
1. Push changes to main branch (src/*)
2. `build-and-deploy.yml` automatically triggered
3. Builds, tests, and deploys to Container Apps

**For Infrastructure:**
1. Push changes to main branch (Terraform files)
2. `dv01-landing-shared.yml` or `dv01-pilot-integrations.yml` triggered
3. Terraform plan → apply with proper dependencies

### Manual Deployment

```bash
# Build containers
docker build -f Dockerfile -t api:latest src/
docker build -f Dockerfile.worker -t worker:latest src/

# Push to ACR
az acr login --name myregistry
docker tag api:latest myregistry.azurecr.io/api:v1.0.0
docker push myregistry.azurecr.io/api:v1.0.0

# Deploy to Container Apps
az containerapp update \
  --name "ca-api-dv01" \
  --resource-group "rg-pilot-dv01" \
  --image "myregistry.azurecr.io/api:v1.0.0"
```

---

## 💡 Design Decisions <a name = "design-decisions"></a>

### 1. GitHub Actions for CI/CD
**Why**: Native GitHub integration, simple YAML configuration, excellent for this assessment project.

### 2. Azure Container Apps
**Why**: Managed Kubernetes alternative, simpler than AKS, built-in auto-scaling, pay-per-use pricing.

### 3. Service Bus for Async Processing
**Why**: Enterprise-grade message broker, DLQ support, Application Insights integration, managed service.

### 4. Terraform for Infrastructure
**Why**: IaC best practices, modular design, state management, version control support.

### 5. Reusable Workflow Pattern
**Why**: Reduces duplication, consistent deployments, easier maintenance and scaling.

### 6. Multi-Layer Infrastructure Deployment
**Why**: Separates concerns (networking, shared services, applications), enables independent scaling and updates.

### 7. .NET 8 with Minimal APIs
**Why**: Modern, performant, containerization-friendly, strong Azure integration.

---

## 🔧 Troubleshooting <a name = "troubleshooting"></a>

### Workflow Failures

**Terraform Plan Fails:**
```bash
# Check token replacement
grep "__#" *.tf *.tfvars

# Verify backend config
terraform backend validate

# Check authentication
az account show
```

**Container App Deployment Timeout:**
```bash
# Check provisioning state
az containerapp show --name "ca-api-dv01" --resource-group "rg-pilot-dv01" \
  --query 'properties.provisioningState'

# View recent errors
az containerapp logs show --name "ca-api-dv01" --resource-group "rg-pilot-dv01" --tail 50
```

**Image Not Found:**
```bash
# Verify image exists
az acr repository list --name myregistry

# Check ACR permissions
az role assignment list --assignee <sp-id> --scope <acr-scope>
```

### Dependency Issues

**Module Not Found:**
```bash
# Ensure modules are in 04_modules/
ls -la 04_modules/

# Check Terraform source paths
grep "source =" *.tf | grep modules
```

**State Lock:**
```bash
# Force unlock if necessary (use with caution)
terraform force-unlock LOCK_ID
```

---

## 📌 Known Limitations <a name = "known-limitations"></a>

1. **Single Region** - Current setup deploys to single Azure region
2. **Shared Agent** - Workflows use `self-hosted` agent (can be changed to `ubuntu-latest`)
3. **Manual Environment Variables** - Not all variables auto-populated from Terraform
4. **No Blue/Green** - Uses revision-based traffic management instead
5. **Limited Dashboard** - Basic Application Insights setup

---

## 🚀 Optional Enhancements <a name = "optional-enhancements"></a>

1. **Multi-Region Deployment** - Add secondary region with failover
2. **Advanced Monitoring** - Custom Application Insights dashboards
3. **API Management** - Add Azure API Management layer
4. **Database Layer** - Integrate SQL Database or Cosmos DB
5. **GitOps** - Implement Flux or ArgoCD for declarative deployments
6. **Secrets Rotation** - Automated Key Vault secret rotation
7. **Compliance** - Azure Policy for governance and compliance
8. **Disaster Recovery** - Backup and recovery procedures

---

## 📖 Contributing <a name = "contributing"></a>

1. Create a feature branch from `main`
2. Make your changes with clear commit messages
3. Test locally before pushing
4. Submit a pull request with description
5. Await review and CI/CD checks

---

## ✍️ Authors <a name = "authors"></a>

- **Hareesh Chilmikollad** - Platform Engineer
- GitHub: [@HareeshJC](https://github.com/HareeshJC)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Last Updated:** June 2026
**Version:** 2.0.0
**Status:** TBC
