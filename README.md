![alt text](docs/img.jpg)

# FSC-ArquitectureAzure-Covid-19
Repository where it's keeps the terraform code for the deploy of the needed Azure resources.

# Deploy

If you only want to deploy the plan 

````
bash deploy.sh
````

If you want to deploy the plan and the infrastructure
````
bash deploy.sh -d y
````

# Folders explanation

|FolderName|ResourcesDeployed|
|----------|-----------------|
|fsc-databricks-ws|DatabricksEnv & DatabricksCluster|
|fsc-keyVault|Azure KeyVault|
|fsc-sql-onpremise|Azure Sql Server & Azure Sql DB| (Deprecated)
|fsc-synapse-analitics|Azure Synapse Workspace & Azure Datalake Gen2 & SQL pool|
|fsc-terraform-azure-backend|Storage Account and Resource Group|


# Contact

```arturo.lorenzo@mdwpartners.com```