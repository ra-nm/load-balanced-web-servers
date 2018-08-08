Configuration IisServer
{
    Node localhost
    {
        WindowsFeature IIS { 
            Name   = "Web-Server"
            Ensure = "Present"
        }

        WindowsFeature WebManagementConsole {
            Name      = "Web-Mgmt-Console"
            DependsOn = "[WindowsFeature]IIS"
            Ensure    = "Present"
        }
    }
}





