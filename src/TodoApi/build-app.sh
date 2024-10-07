#!/bin/bash

# imageName="todo-api"
# tag="beta2"
# registry="solarcontregistrydev.azurecr.io"

echo "Starting buiding container images"
echo "Image Name: $imageName"
echo "Tag: $tag"
echo "Registry: $registry"


echo "Login to Azure Container Registry"
accessToken=$(az acr login --name $registry --expose-token --output tsv --query accessToken)
docker login $registry --username 00000000-0000-0000-0000-000000000000 --password $accessToken

echo "Building Images with Tag '${imageName}:${tag}'"
docker build -t ${registry}/${imageName}:${tag} .

echo "Pushing to '$registry'"
docker push ${registry}/${imageName}:${tag}
