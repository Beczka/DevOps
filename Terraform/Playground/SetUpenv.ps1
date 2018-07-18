# $kvName = "123"
# $secrets = az keyvault secret list --vault-name $kvName | ConvertFrom-Json
# $terraform_variables_local_run = $secrets | Where-Object { $_.tags.terraform_local_env }

# $terraform_variables_local_run | ForEach-Object { 
#     $tagLocalEnvName = $_.tags.terraform_local_env
#     $secretName = $_.id.Split("/")[-1]
#     $secret = az keyvault secret show --vault-name $kvName --name $secretName | ConvertFrom-Json
#     [Environment]::SetEnvironmentVariable($tagLocalEnvName, $secret.value, "Process")
# }

[Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", "BxQz8E8YinwiIJ7QWCZweXv9wccV2SEuhKwfDyKfO1Y=", "Process")