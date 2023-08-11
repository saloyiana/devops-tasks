echo "Let's Start"

echo "Installing the ingress-nginx"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx &&\
  helm repo update &&\
  helm install ingress-nginx ingress-nginx/ingress-nginx --namespace nginx-ingress --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

echo " Check the public IP: $(kubectl --namespace nginx-ingress get services ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')" 
echo "Done with ingress-nginx installiation"

echo "Install Tools - Plus"
echo "----------------------"

echo "Argocd to be used as CD tool"
helm repo add argo https://argoproj.github.io/argo-helm &&\
    helm repo update &&\
    helm install argocd argo/argo-cd --set server.service.type=LoadBalancer -n argocd
echo " Access Argocd: $(kubectl --namespace argocd get services argocd-server --output jsonpath='{.status.loadBalancer.ingress[0].ip}')" 
echo "Username: admin"
echo "Password: $(kubectl get secrets --namespace=argocd argocd-initial-admin-secret -ojsonpath='{.data.password}' | base64 -d)"
echo "Done with Argocd installiation"
echo "----------------------"

echo "Prometnus & Grafana to be used as monitoring tool"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts &&\
  helm repo update &&\
  helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --set grafana.service.type="LoadBalancer"
echo " Access Grafana UI: http://$(kubectl --namespace monitoring get services prometheus-grafana --output jsonpath='{.status.loadBalancer.ingress[0].ip}')" 
echo "Done with Prometnus & Grafana installiation"
echo "----------------------"

echo "ELK to be used as monitoring tool"
helm repo add elastic https://Helm.elastic.co &&\
  helm repo update &&\
  helm install elasticsearch elastic/elasticsearch --namespace logging --set persistence.enabled=false,resources.requests.cpu=200m,resources.requests.memory=512Mi &&\
  helm install filebeat elastic/filebeat --namespace logging &&\
  helm install kibana elastic/kibana --namespace logging --set resources.requests.cpu=300m,resources.requests.memory=256Mi,service.type=LoadBalancer
echo " Access Kibana UI: http://$(kubectl --namespace logging get services kibana-kibana --output jsonpath='{.status.loadBalancer.ingress[0].ip}'):5601/" 
echo "Username: elastic"
echo "Password: $(kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d)"
echo "Done with ELK installiation"
echo "----------------------"

echo "Kyverno to be used as Policy Management tool"
helm repo add kyverno https://kyverno.github.io/kyverno/ &&\
    helm repo update &&\
    helm install kyverno kyverno/kyverno --version 3.0.4 -n kyverno
    kubectl apply -f ../kyverno-policies/require-pod-requests-limits.yaml
echo "Done with Kyverno installiation"
echo "----------------------"