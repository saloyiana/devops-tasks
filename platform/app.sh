echo "Prepare the DB for the APP"
helm repo add bitnami https://charts.bitnami.com/bitnami &&\
    helm repo update &&\
    helm install postgres -n db --set primary.persistence.enabled=false,global.postgresql.auth.database=postgres,global.postgresql.auth.postgresPassword=postgres,global.postgresql.auth.username=postgres,tls.preferServerCiphers=false,readReplicas.persistence.enabled=false,serviceAccount.automountServiceAccountToken=false bitnami/postgresql --version 12.8.0

echo "Deploy the App"
helm install to-do todo-app/ -n app-test
echo "To ccess the App: http://$(kubectl --namespace nginx-ingress get services ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')/todos/list/"
