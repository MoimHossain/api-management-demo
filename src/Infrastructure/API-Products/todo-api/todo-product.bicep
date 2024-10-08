param apimServiceName string
param backendHostKeyName string
param serviceUrl string
param productName string 
param productDisplayName string
param productDescription string
param apiName string 
param versionSetId string
param apiRevision string
param apiRevisionDescription string
param apiDescription string
param apiVersion string
param apiVersionDescription string
param terms string

var apiInstanceName = '${apiName}-${apiVersion}'

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource todoApiProduct 'Microsoft.ApiManagement/service/products@2023-03-01-preview' = {
  name: productName
  parent: apimService
  properties: {
    displayName: productDisplayName
    description: productDescription
    terms: terms
    subscriptionRequired: false
    // approvalRequired: false
    // subscriptionsLimit: 1
    state: 'published'    
  }
}



module todoWebApi 'apis/api.bicep' = {
  name: apiName
  params: {
    apimServiceName: apimServiceName
    backendHostKeyName: backendHostKeyName    
    apiName: apiInstanceName    
    serviceUrl: serviceUrl
    apiRevision: apiRevision
    apiRevisionDescription: apiRevisionDescription
    isCurrent: true    
    description: apiDescription
    displayName: apiDescription
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: versionSetId
  }
}



resource productLink 'Microsoft.ApiManagement/service/products/apis@2023-03-01-preview' = {
  name: '${apimServiceName}/${productName}/${apiInstanceName}'
  dependsOn: [
    todoWebApi
    todoApiProduct
  ]
}

