# Network Deployment Sample

```
./deploy.sh -i 'rawe - MSDN' -g 'RobNetworkRG' -n 'RobNetwork' -l 'East US' -t ./network/VirtualNetwork.json -p ./network/VirtualNetwork.parameters.json
```

# IIS Deployment Sample

```
./deploy.sh -i 'rawe - MSDN' -g 'IisRG' -n 'IisApp' -l 'East US' -t ./web/WebEnvironment.json -p ./web/WebEnvironment.iis.parameters.json
```

# NGINX Deployment Sample

```
./deploy.sh -i 'rawe - MSDN' -g 'NginxRG' -n 'NginxApp' -l 'East US' -t ./web/WebEnvironment.json -p ./web/WebEnvironment.nginx.parameters.json
```