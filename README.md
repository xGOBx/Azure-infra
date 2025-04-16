# Azure Resources Deployment Workflow

This GitHub Actions workflow automates the deployment of Azure resources using Bicep templates. It creates a resource group and deploys various Azure services as defined in your Bicep template.

## What This Workflow Does

1. Triggers on:
   * Pull requests to `AzureDeployResources` branch
   * Manual runs (workflow_dispatch)

2. Main Functions:
   * Creates an Azure resource group
   * Deploys resources defined in a Bicep template
   * Validates that expected resource types were successfully provisioned
   * Handles both default configurations and custom inputs for manual runs

3. Validation Process:
   * Waits for resources to fully provision
   * Checks that all expected resource types exist in the resource group
   * Performs both exact and partial matching for resource validation

## Required Secrets

You need to configure these secrets in your GitHub repository environment:

| Secret | Description | Type |
|--------|-------------|------|
| AZURE_CREDENTIALS_DEPLOY | Azure service principal credentials for authentication | JSON object containing Azure credentials |
| DB_ADMIN_PASSWORD | Password for the SQL database administrator | String |

## Setting Up the Secrets

### 1. AZURE_CREDENTIALS_DEPLOY

This should be a JSON object containing Azure service principal credentials. Generate it using Azure CLI:
 - Note : you may need to make this command one line in order for it to run properly

```bash
az ad sp create-for-rbac --name "github-action-resouces-deployment" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group-name} \
  --sdk-auth
```

The output will look like:

```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  "activeDirectoryEndpointUrl": "...",
  "resourceManagerEndpointUrl": "...",
  "activeDirectoryGraphResourceId": "...",
  "sqlManagementEndpointUrl": "...",
  "galleryEndpointUrl": "...",
  "managementEndpointUrl": "..."
}
```

### 2. DB_ADMIN_PASSWORD

This is the password you want to set for your SQL database administrator account. Make sure it meets Azure SQL password requirements:
* At least 8 characters
* Contains uppercase letters, lowercase letters, numbers, and special characters

## Usage

### Automated Deployment

When you push to or create a pull request against the `AzureDeployResourcesTest` branch, the workflow uses these default settings:
* Resource Group: `RealTest`
* Location: `canadacentral`
* Bicep File: `./deploy/template.bicep`

### Manual Deployment

You can manually trigger the workflow from the GitHub Actions tab with custom parameters:
* Resource Group Name (defaults to `AzureDeployTest`)
* Azure Region (defaults to `eastus`)
* Path to the Bicep template (defaults to `./deploy/template.bicep`)

## Expected Resources

The workflow validates that these resource types are successfully deployed:
* Microsoft.Communication/communicationServices
* Microsoft.Communication/emailServices
* Microsoft.Sql/servers
* Microsoft.Storage/storageAccounts
* Microsoft.Web/serverfarms
* Microsoft.Web/sites

## Environment Configuration

Make sure to set up the `AzureDeploy` environment in your GitHub repository before running this workflow.