# devops-tasks

## Application flow

[app-overview](images/app-overview.png)   

## to run the app locally: 
1. clone the repo `git clone -b main https://github.com/saloyiana/devops-tasks`   
2. change dir to devops-tasks/todo_app by cd `devops-tasks/todo_app/`   
3. run `docker-compose up`   
4. to access the app, go to: `http://localhost:8000/todos/list/`   

## to run k8s env
1. add your creds to the `platform/aks/terraform.tfvars`
2. run `make cluster up` or 
```
cd platform/aks
terraform init
terraform apply -auto-approve 
echo "Preparing the namespaces"
kubectl create namespace nginx-ingress
kubectl create namespace argocd
kubectl create namespace kyverno
kubectl create namespace todoapp
kubectl create namespace monitoring
kubectl create namespace logging
kubectl create namespace cattle-system
kubectl create namespace app-test
kubectl create namespace db-test
kubectl create namespace app-prod
kubectl create namespace db-prod
```
3. start installing the tools by running `make tools` or ` sh tools.sh`
4. create the db and argocd apps by running `make db-test argocd-test db-prod argocd-prod` or 
```
echo "Prepare the DB for the APP"
helm repo add bitnami https://charts.bitnami.com/bitnami &&\
    helm repo update &&\
    helm install postgres -n db-test --set primary.persistence.enabled=false,global.postgresql.auth.database=postgres,global.postgresql.auth.postgresPassword=postgres,global.postgresql.auth.username=postgres,tls.preferServerCiphers=false,readReplicas.persistence.enabled=false,serviceAccount.automountServiceAccountToken=false bitnami/postgresql --version 12.8.0

kubectl apply -f argocd-objects/repo.yaml -n argocd
kubectl apply -f argocd-objects/test.yaml -n argocd

echo "Prepare the DB for the APP"
helm repo add bitnami https://charts.bitnami.com/bitnami &&\
    helm repo update &&\
    helm install postgres -n db-prod --set primary.persistence.enabled=false,global.postgresql.auth.database=postgres,global.postgresql.auth.postgresPassword=postgres,global.postgresql.auth.username=postgres,tls.preferServerCiphers=false,readReplicas.persistence.enabled=false,serviceAccount.automountServiceAccountToken=false bitnami/postgresql --version 12.8.0

kubectl apply -f argocd-objects/repo.yaml -n argocd
kubectl apply -f argocd-objects/prod.yaml -n argocd
```
#### note: if you wish to install the app in push-mode, check `app.sh`

# Images
### K8S Resources
[app-overview](images/k8s-ns.png)   

### CI/CD Steps
[app-overview](images/app-overview.png)   

### Argocd Apps
[app-overview](images/argocd-ui.png)   

### Kibana Dashboard
[app-overview](images/kibana-dashboard.png)   

### Grafana Dashboard
[app-overview](images/app-monitoring.png) 

### Kyverno Polices
[app-overview](images/kyverno-policy.png)   

# Done
