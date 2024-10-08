
param apimServiceName string
param productName string
param apiName string
param backendHostKeyName string
param serviceUrl string
param apiVersion string
param apiVersionSetId string
param apiVersionDescription string
param apiRevision string
param apiRevisionDescription string
param description string
param displayName string
param apiPath string = ''

param isCurrent bool = true
param apiType string = 'http'

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource Api 'Microsoft.ApiManagement/service/apis@2023-03-01-preview' = {
  parent: service
  name: '${apiName}-${apiVersion}'  
  properties: {
    apiRevision: apiRevision
    apiRevisionDescription: apiRevisionDescription
    isCurrent: isCurrent
    apiType: apiType
    description: description
    displayName: displayName
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: apiVersionSetId
    format: 'openapi+json'
    value: loadTextContent('TodoApi.json')
    path: apiPath
    subscriptionRequired: false
    serviceUrl: serviceUrl
  }
  
  resource policy 'policies@2023-03-01-preview' = {    
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: replace(loadTextContent('../policies/common-api-policy.xml'), 'KEY_HOSTNAME', backendHostKeyName) 
    }
  }
}

resource complianceWebApiWithProduct 'Microsoft.ApiManagement/service/products/apis@2023-03-01-preview' = {
  name: '${apimServiceName}/${productName}/${apiName}'
  dependsOn: [
    Api
  ]
}
