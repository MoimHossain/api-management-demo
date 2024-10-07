#!/bin/bash

# export resourceGroupName="api-management-demo"
# export location="westeurope"
# export APP_NAME="solar"
# export APP_ENV="dev"
# export TAG_NAME="beta2"

echo "Starting deploying the app provisioning..."

echo "Resource Group Name: $resourceGroupName"
echo "Location: $location"
echo "App Name: $APP_NAME"
echo "App Environment: $APP_ENV"
echo "Tag Name: $TAG_NAME"


echo "Deploying app Bicep file..."
az deployment group create --resource-group $resourceGroupName --template-file 'app.bicep'  --parameters app.bicepparam