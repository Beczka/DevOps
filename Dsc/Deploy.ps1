param(
    $tenantId,
    $clientId,
    $clientSecret,
    $subscriptionId
)

$resourceGroupName = "TEST-automation-westeurope"
$storageAccountName = "automationdsc"
$containerName = "dsc"
$automationAccountName = "vm-automation-westeurope"

if (!(Get-Module -Name AzureRM.Profile -ListAvailable)) {
    if (!(Get-Module -Name PowerShellGet -ListAvailable)) {
        Install-Module -Name PowerShellGet -Force
    }

    Install-Module -Name AzureRM -AllowClobber -SkipPublisherCheck -Force
}

    if ($clientId -and ($clientSecret -and $tenantId)) {ls
        $clientSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
        $cred = New-Object PSCredential($clientId, $clientSecret)
        Login-AzureRmAccount -ServicePrincipal -Credential $cred -TenantId $tenantId -Subscription $subscriptionId
    } else {
        throw [System.ArgumentException] "Not all required params where passed"
    }


$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

function Prepare() {
    New-Item -Path packages -ItemType Directory -Force -InformationVariable None
}
function Compress-Config($configName) {    
    $files = Get-ChildItem -Path $configName | Select-Object -ExpandProperty FullName
    Compress-Archive -Path $files -DestinationPath "packages\$configName.zip" -Force
}

function Upload-Config($configName) {
    Compress-Config $configName
    Set-AzureStorageBlobContent -File "packages\$configName.zip" -Container $containerName -Blob "$configName.zip" -Context $storageAccount.Context -Force
}

function Clean() {
    Remove-Item -Recurse -Force packages
}

function Compile-Configs() {
    Get-ChildItem -Path Configuration -Filter "*.ps1" | ForEach-Object {
        Import-AzureRmAutomationDscConfiguration -AutomationAccountName $automationAccountName -ResourceGroupName $resourceGroupName -SourcePath $_.FullName -Published -Force

        $job = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -ConfigurationName $_.BaseName

        while (($job.EndTime -eq $null) -and ($job.Exception -eq $null)) {
            $job = $job | Get-AzureRmAutomationDscCompilationJob
            Start-Sleep -Seconds 5
        }

        $stream = $job | Get-AzureRmAutomationDscCompilationJobOutput -Stream Any 
        Write-Host $stream.Summary
    }
}

Prepare
Upload-Config "CustomConfigurationManager"
Compile-Configs
Clean
