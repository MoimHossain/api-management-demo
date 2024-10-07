#!/bin/bash


echo "Update API script started..."
echo "============================"
echo "resource group name: $resourceGroupName"
echo "location: $location"
echo "app name: $APP_NAME"
echo "app environment: $APP_ENV"
echo "image name: $imageName"
echo "Primary Mode: $primaryMode"

# az config set extension.use_dynamic_install=yes_without_prompt
# az extension add -n containerapp

primaryModeLower=$(echo "$primaryMode" | tr '[:upper:]' '[:lower:]')

# Check if the result is empty or not
if [[ "$primaryModeLower" == "yes" || "$primaryModeLower" == "1" || "$primaryModeLower" == "true" ]]; then
    echo "Updating the Primary API..."
    export activeNameWithoutQuotes=''
    export API_NAME="todo-api-ga"
    export API_VERSION="public-v1"
    export KEY_BACKEND_HOST="PRIMARY_BACKEND_HOST"
else
    echo "Updating the Preview API..."
    activeRevisionNameWithQuotes=$(az containerapp revision list -n $imageName -g $resourceGroupName --query '[0].name')
    echo 'Active revision name: ' $activeRevisionNameWithQuotes
    activeNameWithoutQuotes=$(echo $activeRevisionNameWithQuotes | tr -d "\"")        
    export activeNameWithoutQuotes=$activeNameWithoutQuotes
    export API_NAME="todo-api-preview"
    export API_VERSION="preview-v1"
    export KEY_BACKEND_HOST="PREVIEW_BACKEND_HOST"
    echo "Environment variable set for active revision: $activeNameWithoutQuotes"
fi


echo "Deploying products Bicep file..."
az deployment group create --resource-group $resourceGroupName --template-file 'src/Infrastructure/API-Products/main.bicep'  --parameters 'src/Infrastructure/API-Products/main.bicepparam'