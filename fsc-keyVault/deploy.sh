#!/bin/bash
while getopts "d:" flag; do
    case "${flag}" in
        d) deploy=${OPTARG};;
    esac
done
cd iac

terraform init
terraform plan -out plan.tfplan

if [ $deploy == 'y' ]
then
    terraform apply "plan.tfplan"
fi

cd ..