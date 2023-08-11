up: cluster namespaces tools db argocd-test argocd-prod

prod: argocd-prod

cluster:
    cd platform/k8s-cluster
	terraform init
	terraform apply -auto-approve 

namespaces:
	echo "Preparing the namespaces"
	kubectl create namespace nginx-ingress
	kubectl create namespace argocd
	kubectl create namespace kyverno
	kubectl create namespace todoapp
	kubectl create namespace monitoring
	kubectl create namespace logging
	kubectl create namespace cattle-system
	kubectl create namespace app-test
	kubectl create namespace db
	kubectl create namespace app-prod

tools:
	./tools.sh

db:
	echo "Prepare the DB for the APP"
	helm repo add bitnami https://charts.bitnami.com/bitnami &&\
		helm repo update &&\
		helm install postgres -n db --set primary.persistence.enabled=false,global.postgresql.auth.database=postgres,global.postgresql.auth.postgresPassword=postgres,global.postgresql.auth.username=postgres,tls.preferServerCiphers=false,readReplicas.persistence.enabled=false,serviceAccount.automountServiceAccountToken=false bitnami/postgresql --version 12.8.0

argocd-test:
	kubectl apply -f argocd-objects/repo.yaml -n argocd
	kubectl apply -f argocd-objects/test.yaml -n argocd

argocd-prod:
	kubectl apply -f argocd-objects/repo.yaml -n argocd
	kubectl apply -f argocd-objects/prod.yaml -n argocd

clean:
	echo "Cleaning the env"
	kubectl delete namespace nginx-ingress
	kubectl delete namespace argocd
	kubectl delete namespace kyverno
	kubectl delete namespace todoapp
	kubectl delete namespace monitoring
	kubectl delete namespace logging
	kubectl delete namespace cattle-system
	kubectl delete namespace app-test
	kubectl delete namespace db-test
	kubectl delete namespace app-prod
	kubectl delete namespace db-prod

cluster-down:
    cd platform/k8s-cluster
	terraform destroy -auto-approve 

down: clean cluster-down