#!/bin/bash


# export resourceGroupName=$resourceGroupName
# export location=$location
# export APP_NAME=$APP_NAME
# export APP_ENV=$APP_ENV
# export containerRegistryName=$containerRegistryName
# export tagNameE=$tag
# export imageName=$imageName
# export uamiName=$uamiName
# export appInsightName=$appInsightName

echo "Starting script...$tag and image name $imageName"

echo "Resource Group Name: $resourceGroupName"
echo "Location: $location"
echo "App Name: $APP_NAME"
echo "App Environment: $APP_ENV"
echo "Container Registry Name: $containerRegistryName"
echo "Tag Name: $tagNameE"
echo "Image Name: $imageName"


# az config set extension.use_dynamic_install=yes_without_prompt
# az extension add -n containerapp


# Determine if the container app exists

listedApps=$(az containerapp list -g $resourceGroupName --query "[?name=='$imageName']")

# Check if the result is empty or not
if [ "$listedApps" = "[]" ]; then    
    echo "Container app '$imageName' does not exist."
    export activeNameWithoutQuotes=''
else
    echo "Container app '$imageName' exists."
    activeRevisionNameWithQuotes=$(az containerapp revision list -n $imageName -g $resourceGroupName --query '[0].name')
    echo 'Active revision name: ' $activeRevisionNameWithQuotes
    activeNameWithoutQuotes=$(echo $activeRevisionNameWithQuotes | tr -d "\"")        
    export activeNameWithoutQuotes=$activeNameWithoutQuotes

    echo "Environment variable set for active revision: $activeNameWithoutQuotes"
fi




echo "Starting deploying the app provisioning..."


echo "Deploying app Bicep file..."
az deployment group create --resource-group $resourceGroupName --template-file 'src/Infrastructure/Containers/app.bicep' --parameters 'src/Infrastructure/Containers/app.bicepparam'