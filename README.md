# Ensuring-Quality-Releases

* [Overview](#overview)
* [Terraform](#terraform)
* [Azure DevOps](#azure-devops)
* [Postman](#postman)
* [JMeter](#jmeter)
* [Selenium](#selenium)
* [Azure Monitor](#azure-monitor)

## Overview
This project is part of the Udacity Cloud DevOps using Microsoft Azure Nanodegree Program.

This project is about creating disposable test environments and run a variety of automated tests with the click of a button in addition to monitoring and providing insight into the application's behavior and determining root causes by querying the application’s custom log files.

![overview](./screenshots/overview.png)

The following technology stack will be used:
- Azure DevOps for creating a CI/CD pipline to run Terraform and execute tests with Postman, JMeter & Selenium.
- Azure App Services to host the web application
- Azure Pipelines to provision, build, deploy and test the web application
- Terraform for creating and deploying Azure cloud infrastructure (IaC)
- Postman for integration testing
- JMeter for performance testing
- Selenium for functional UI testing
- Azure Monitor for observability purposes

In terms of a process flow, one can think of:
1. Development (VS Code)
2. Code Repository (GitHub)
3. Provisioning (Terraform)
4. Building (Azure Pipelines)
5. Deploying (Azure Pipelines)
6. Integration Testing (Postman)
7. Stress Testing (JMeter)
8. UI Testing (Selenium)
9. Observing (Azure Monitor & Azure Log Analytics)

The automated tests (Integration, UI and Stress) run on a self-hosted virtual machine (Linux).

<br/>

## Terraform
### Configuration of storage account and state backend

<br/>

Login to Azure CLI:
```
az login
```

Configure remote state storage account:
Execute the bash script:
```
sh azure-storage-account.sh
```

Storage account name, container name and access key will be used in the main.tf file. Key shall be defined as 'test.terraform.tfstate". "test" is pre-defined by Udacity throughout all terraform files.

Source: [Link](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

<br/>

### Creating a Service Principal for Terraform

Create Service Principal:
```
az ad sp create-for-rbac --name="Ensuring-Quality-Releases" --role="Contributor" 
```

appid (client_id), password (client_secret) and tenant will be used in the terraform.tfvars file.

Source: [Link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

<br/>

### Project Steps
Terraform will be used for creating the following resources:
- AppService
- Network
- Network Security Group
- Public IP
- Resource Group
- Linux VM

The terraform resource code for AppService, Network, Network Security Group, Public IP and Resource Group is already provided by Udacity. The terraform resource code for the Linux VM is provided by me. This includes changes in the following terraform files: input.tf, main.tf, terraform.tfvars, vm/input.tf & vm/vm.tf.

Locally, the following would apply:\
Executing terraform:
```
terraform init
```
``
Terraform has been successfully initialized!
``

```
terraform plan -out solution.plan
```
``
Plan: 10 to add, 0 to change, 0 to destroy.
Saved the plan to: solution.plan
``

```
terraform apply "solution.plan" 
```
``
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
``

<br/>

## Azure DevOps
- Install the [Terraform extension for Azure DevOps](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) if not already done. See "Organization settings" -> "Extensions".
- Create a new Azure DevOps project
- Create a new Service Connection
1. Project settings
2. Service connections
3. Create service connection
4. Azure Resource Manager
5. Service Principal
6. Service connection name: azurerm-sc
- Upload Secure Files
1. Pipelines
2. Library
3. Secure files
4. Upload azurecreds.conf
5. Upload SSH private key (no .pub ending)

Create SSH public private key pair for authentification to the Linux VM:
```
# Looking for id_rsa public private key pair
cd ~/.ssh/
```

```
# If not there, this is how a public private key pair can be created:
ssh-keygen -t rsa -b 4096 -f id_rsa
```
- Create Variable group
1. From the azurecreds.conf file: subscription_id, client_id, subscription_id and tenant_id
2. From the SSH public private key pair: public key (.pub ending)

```
# Get the value for the public ssh key
cat id_rsa.pub
```

- Create pipeline
1. GitHub YAML
2. Select specific repo
3. Select existing Azure Pipelines YAML file
4. Save pipeline

- Go back to Library and add newly created pipeline to pipeline permissions by clicking on specific secure file

With this pre-settings implemented, a new commit in the GitHub repository should automatically trigger a new pipeline run. In this case, terraform shall successfully provision a Virtual Machine in Azure.

Current error when provisioning terraform (terraform apply):
![error1](./screenshots/error1.png)

````
│ Error: creating Linux Virtual Machine "udacity-vm" (Resource Group "udacityrg"): compute.VirtualMachinesClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: Code="InvalidParameter" Message="Destination path for SSH public keys is currently limited to its default value /home/cz.official/.ssh/authorized_keys  due to a known issue in Linux provisioning agent." Target="linuxConfiguration.ssh.publicKeys.path"
````

When doing exactly that what the error message says:
![error2-1](./screenshots/error2-1.png)

![error2-2](./screenshots/error2-2.png)

<br/>

## Postman
## JMeter
## Selenium
## Azure Monitor