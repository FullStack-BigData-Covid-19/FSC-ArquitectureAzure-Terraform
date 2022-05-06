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

|FolderName|ResourcesDeployed|OrderExecution|
|----------|-----------------|--------------|
|fsc-init-tfstate-account|Tfstate Storage Account and TfState Resource Group|1|
|fsc-datalake|Datalake GEN2, 3 ETL containers & Main Resource Group|2|
|fsc-synapse-analitics|Azure Synapse Workspace & SQL pool|3|
|fsc-databricks-ws|DatabricksEnv & DatabricksCluster|4|
|fsc-keyVault|Azure KeyVault|5|



# Contact

```arturo.lorenzo@mdwpartners.com```