# Network Deployment Sample

./deploy.sh -i 'rawe - MSDN' -g 'RobNetworkRG' -n 'RobNetwork' -l 'East US' -t ./network/VirtualNetwork.json -p ./network/VirtualNetwork.parameters.json

# IIS Deployment Sample

./deploy.sh -i 'rawe - MSDN' -g 'IisRG' -n 'IisApp' -l 'East US' -t ./web/WindowsWebServer.json -p ./web/WindowsWebServer.parameters.json