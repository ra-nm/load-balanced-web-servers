# Load Balanced Web Servers in Azure

This repo contains Azure Resource Manager Templates to deploy a load balanced web enviornment using IIS or NGINX.

To get started, you will need to make sure you have an Azure Account and have Azure CLI installed on your machine.  The scripts in this repo were developed on a Windows machine with the Linux Subsystem installed (Ubuntu 18.04), but they could be run on any machine with Azure CLI installed.

Before running any of the commands to deploy these templates you will need to log into Azure using the following command:

```
az login
```

## Network

### Resources
* Application Security Groups
* Network Security Groups
* Virtual Network

### Parameters
|Parameter Name|Type|Description|
|---|---|---|
|costCenter|string|The value for the cost center tag on each resource.|
|networkName|string|The name for the virtual network.|
|secondOctet|int|The second octet for the address space of the network.  This template creates a /16 network with the address space of 10.xx.0.0/16.|
|administrationIp|string|The IP Address used to do administration on the servers in this network.  You specify which port should be open for each application in the webAppicationData parameter|
|webApplicationData|array|Array of objects representing the web applications hosted on this network.|

webApplicationData parameter format:

```
[
    {
        "name": "ApplicationOnIis",
        "publicFacingPorts": [
            "80",
            "443"
        ],
        "administrationPorts": [
            "3389"
        ]
    },
    {
        "name": "ApplicationOnNginx",
        "publicFacingPorts": [
            "80"
        ],
        "administrationPorts": [
            "22"
        ]
    }
]
```

### Network Security Group Rules

* Inbound traffic from the VirtualNetwork is denied by default.
* The publicFacingPorts from the webApplicationData parameter will be opened from the Internet to the Application Secruity Group for the web application.
* The administrationPorts  from the webApplicationData parameter will be opened from the IP specified in the administrationIp parameter to the Application Secruity Group for the web application.
* All traffic will be allowed within an Application Security Group.

### Deployment

To deploy the template, run a command similar to the following from the root of this repo:

```
./deploy.sh -i 'rawe - MSDN' -g 'RobNetworkRG' -n 'RobNetwork' -l 'East US' -t ./network/VirtualNetwork.json -p ./network/VirtualNetwork.parameters.json
```

## Key Vault

Deploying a key vault is an optional step but can be helpful to you by securely storing the administrator password for your VMs.  The administrator password secret can be referenced in your ARM Template Parameter file so you don't need to check it into source control.

To deploy the key vault and a randomly generated secret, run a script similar to the following at the root of this repo:

```
./vault/vault.sh -r 'VaultRG' -l 'eastus' -n 'RawePasswordVault' -s 'AdminPassword' -c 'Marketing'
```

## Load Balanced Web Environment

This template deploys a load balanced web enviornment to either IIS on a Windows server or NGINX on a Linux server.  The servers are deployed into an existing Azure Virtual Network.

### Resources

* Availability Set
* Load Balancer
* Public IP Address
* Storage Account
* Network Interfaces
* Virtual Machines
* Virtual Machine Extensions

### Parameters

|Parameter Name|Type|Description|
|---|---|---|
|costCenter|string|The value for the cost center tag on each resource.|
|webServerType|string|The type of web server to deploy.  Valid values are "iis" and "nginx".|
|vmNamePrefix|string|The prefix of the vm name.  A number will be appended to the end of the name of each vm created.|
|numberOfVms|int|The number of VMs to be deployed.  Valid range of values: 3-5|
|networkResourceGroupName|string|Name of the resource group that the network lives in.|
|networkName|string|Name of the network the VMs will be deployed to.|
|subnetName|string|Name of the subnet the VMs will be deployed to.|
|applicationSecurityGroupName|string|Name of the application security group for this application in the Network Resource Group.|
|virtualMachineSize|string|The size of VMs that will be deployed. Allowed values are "Standard_B2S" and "Standard_B2MS"|
|osDiskSizeInGb|string|The size of the operating system disk.  Allowed values are "32", "64", "128", "256".|
|administratorUserName|string|Administrator User Name for the VMs.|
|administratorPassword|string|Administrator Password for the VMs.|
|storageAccountType|string|The type of storage to use for the OS managed disk.  Allowed values are "Standard_LRS", "Standard_GRS", and "Premium_LRS"|
|diagnosticsStorageAccountType|string|The type of storage account to create for vm diagnostics. Allowed values are "Standard_LRS", "Standard_GRS", and "Premium_LRS"|
|publicIpDomainNameLabel|string|Value to use as part of the IP address DNS name: ```<value>.<location>.cloudapp.azure.com```|
|httpPort|int|The port number the web application will use for http traffic. Allowed values range from 80-9999.|
|httpsPort|int|The port number the web application will use for https traffic. Allowed values range from 443-9999.|



### IIS Deployment

To deploy the template, run a command similar to the following from the root of this repo:

```
./deploy.sh -i 'rawe - MSDN' -g 'IisRG' -n 'IisApp' -l 'East US' -t ./web/WebEnvironment.json -p ./web/WebEnvironment.iis.parameters.json
```

### NGINX Deployment

To deploy the template, run a command similar to the following from the root of this repo:

```
./deploy.sh -i 'rawe - MSDN' -g 'NginxRG' -n 'NginxApp' -l 'East US' -t ./web/WebEnvironment.json -p ./web/WebEnvironment.nginx.parameters.json
```
