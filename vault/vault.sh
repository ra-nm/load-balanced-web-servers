#!/bin/bash

declare resourceGroup=""
declare location=""
declare keyVaultName=""
declare secretName=""
declare costCenter=""

# Initialize parameters specified from command line
while getopts ":r:l:n:s:c:" arg; do
	case "${arg}" in
		r)
			resourceGroup=${OPTARG}
			;;
		l)
			location=${OPTARG}
			;;
		n)
			keyVaultName=${OPTARG}
			;;
		s)
			secretName=${OPTARG}
			;;
        c)
			costCenter=${OPTARG}
			;;
		esac
done

if [ $(az group exists -n $resourceGroup) != "true" ]; then
    echo "*** Creating Resource Group $resourceGroup in Location $location"
    az group create -g $resourceGroup -l $location
fi

kvShowResult=$(az keyvault show -g $resourceGroup -n $keyVaultName)
if [ "$kvShowResult" == "" ]; then
    echo "*** Creating Key Vault $keyVaultName in Location $location in Resource Group $resourceGroup"
    az keyvault create -g $resourceGroup -n $keyVaultName -l $location --enabled-for-template-deployment true --sku standard --tags "Cost Center"="$costCenter"
fi

secretShowResult=$(az keyvault secret show --vault-name $keyVaultName -n $secretName )
if [ "$secretShowResult" == "" ]; then
    echo "*** Creating Secret named $secretName in Key Vault $keyVaultName"
    az keyvault secret set --vault-name $keyVaultName -n $secretName --value $(uuidgen -t)
fi



