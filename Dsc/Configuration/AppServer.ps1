Configuration AppServer {

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'cChoco'

        Node AppServer {

            cChocoInstaller installChoco
            {
              InstallDir = "c:\choco"
            }

            cChocoPackageInstallerSet Packages {
                DependsOn = "[cChocoInstaller]Choco"
                Ensure = "Present"
                Name = @(
                    "googlechrome", 
                    "7zip", 
                    "notepadplusplus", 
                    "putty", 
                    "cmder", 
                    "sql-server-management-studio", 
                    "rdcman", 
                    "azure-cli", 
                    "microsoftazurestorageexplorer", 
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
        }
}