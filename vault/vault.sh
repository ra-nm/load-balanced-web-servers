#!/bin/bash

resourceGroup="VaultRG"
location="eastus"
keyVaultName="RawePasswordVault"
secretName="AdminPassword"

if [ $(az group exists -n $resourceGroup) != "true" ]; then
    echo "*** Creating Resource Group $resourceGroup in Location $location"
    az group create -g $resourceGroup -l $location
fi

kvShowResult=$(az keyvault show -g $resourceGroup -n $keyVaultName)
if [ "$kvShowResult" == "" ]; then
    echo "*** Creating Key Vault $keyVaultName in Location $location in Resource Group $resourceGroup"
    az keyvault create -g $resourceGroup -n $keyVaultName -l $location --enabled-for-template-deployment true --sku standard
fi

secretShowResult=$(az keyvault secret show --vault-name $keyVaultName -n $secretName )
if [ "$secretShowResult" == "" ]; then
    echo "*** Creating Secret named $secretName in Key Vault $keyVaultName"
    az keyvault secret set --vault-name $keyVaultName -n $secretName --value $(uuidgen -t)
fi



