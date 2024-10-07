#!/bin/bash

# export resourceGroupName="api-management-demo"
# export location="westeurope"
# export APP_NAME="solar"
# export APP_ENV="dev"

echo "Starting Infrastructure provisioning..."

echo "Resource Group Name: $resourceGroupName"
echo "Location: $location"
echo "App Name: $APP_NAME"
echo "App Environment: $APP_ENV"

# az keyvault list-deleted
# az keyvault purge -n solarxkeyvaultdev

echo "Creating resource group..."
az group create --name $resourceGroupName --location $location

echo "Deploying main Bicep file..."
#az deployment group create --confirm-with-what-if --resource-group $resourceGroupName --template-file main.bicep  --parameters main.bicepparam

az deployment group create --resource-group $resourceGroupName --template-file main.bicep  --parameters main.bicepparam