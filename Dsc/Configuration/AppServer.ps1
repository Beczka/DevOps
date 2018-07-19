Configuration AppServer {

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xNetworking'
    Import-DscResource -ModuleName 'cChoco'

        Node AppServer {

            cChocoInstaller Choco
            {
              InstallDir = "c:\choco"
            }

            cChocoPackageInstallerSet Packages {
                DependsOn = "[cChocoInstaller]Choco"
                Ensure = "Present"
                Name = @(
                    "googlechrome",
                    "azure-cli",
                    "azurepowershell"
                    )
            }

            WindowsFeature IIS {
                Ensure = "Present"
                Name = "Web-Server"
            }

            WindowsFeature IISManagementTools
            {
                Ensure = "Present"
                Name = "Web-Mgmt-Tools"
                DependsOn='[WindowsFeature]IIS'
            }

            WindowsFeature WebApp {
                Ensure = "Present"
                Name = "Web-App-Dev"
                DependsOn='[WindowsFeature]IIS'
            }
        }
}