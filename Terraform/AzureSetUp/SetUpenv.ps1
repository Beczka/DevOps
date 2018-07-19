[Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", "xxxxx", "Process")

# Set up terraform
# iex (wget 'https://chocolatey.org/install.ps1' -UseBasicParsing);
# choco install terraform

# $kvName = "123"
# $secrets = az keyvault secret list --vault-name $kvName | ConvertFrom-Json
# $terraform_variables_local_run = $secrets | Where-Object { $_.tags.terraform_local_env }

# $terraform_variables_local_run | ForEach-Object { 
#     $tagLocalEnvName = $_.tags.terraform_local_env
#     $secretName = $_.id.Split("/")[-1]
#     $secret = az keyvault secret show --vault-name $kvName --name $secretName | ConvertFrom-Json
#     [Environment]::SetEnvironmentVariable($tagLocalEnvName, $secret.value, "Process")
# }

# Download az cli
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest

# az account list --output table
# az account set --subscription ""

# Install-WindowsFeature -name Web-Server -IncludeManagementTools
# Install-WindowsFeature Web-App-Dev -IncludeAllSubFeature