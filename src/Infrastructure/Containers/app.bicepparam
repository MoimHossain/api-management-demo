using 'app.bicep'

var appname = readEnvironmentVariable('APP_NAME')
var appEnv = readEnvironmentVariable('APP_ENV')

param uamiName = '${appname}-uami-${appEnv}'

param imageName = 'todo-api'
param tagName = readEnvironmentVariable('TAG_NAME')
param containerRegistryName = '${appname}contregistry${appEnv}'
param acaEnvName = '${appname}-appenv-${appEnv}'

param appInsightName = '${appname}-appinsights-${appEnv}'

param containerPort = 8080

