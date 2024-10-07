targetScope = 'resourceGroup'

param imageName string
param tagName string
param containerRegistryName string 
param location string = resourceGroup().location
param acaEnvName string 
param uamiName string
param appInsightName string
param containerPort int = 8080

resource acaEnvironment 'Microsoft.App/managedEnvironments@2022-03-01'  existing = {   name: acaEnvName }
resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = { name: uamiName }
resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = { name: appInsightName }

module frontendApp 'modules/http-app.bicep' = {
  name: imageName
  params: {    
    location: location
    containerAppName: imageName
    environmentName: acaEnvironment.name    
    revisionMode: 'Multiple'    
    hasIdentity: true
    userAssignedIdentityName: uami.name
    containerImage: '${containerRegistryName}.azurecr.io/${imageName}:${tagName}'
    containerRegistry: '${containerRegistryName}.azurecr.io'
    isPrivateRegistry: true
    containerRegistryUsername: ''
    registryPassword: ''    
    useManagedIdentityForImagePull: true
    containerPort: containerPort
    enableIngress: true
    isExternalIngress: true // external ingress for a vent app is still a private IP
    minReplicas: 1
    env: [
      {
        name: 'APPINSIGHT_CONN_STR'
        value: appInsights.properties.ConnectionString
      }
      {
        name: 'AZDO_TENANT_ID'
        value: uami.properties.tenantId
      }
      {
        name: 'AZDO_MANAGED_IDENTITY_ID'
        value: uami.properties.clientId
      }
      {
        name: 'AZDO_USE_MANAGED_IDENTITY'
        value: 'YES'	
      }
      {
        name: 'SOFTWARE_VERSION'
        value: tagName	
      }
    ]
  }
}

output fqdn string = frontendApp.outputs.fqdn
output revisionFqdn string = frontendApp.outputs.revisionFqdn
