using 'app.bicep'

var appname = readEnvironmentVariable('APP_NAME')
var appEnv = readEnvironmentVariable('APP_ENV')
param imageName = readEnvironmentVariable('imageName')
param tagName = readEnvironmentVariable('tagName')

param uamiName = '${appname}-uami-${appEnv}'
param containerRegistryName = '${appname}contregistry${appEnv}'
param acaEnvName = '${appname}-appenv-${appEnv}'
param appInsightName = '${appname}-appinsights-${appEnv}'
param containerPort = 8080

