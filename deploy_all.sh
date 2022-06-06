resources="fsc-init-tfstate-account fsc-service-principal fsc-datalake fsc-synapse-analitics fsc-keyVault fsc-databricks-ws"
for i in $resources; do
    cd "$i"
    ./deploy.sh -d y
    cd ..
done