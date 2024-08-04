up: cluster-up app-deploy

cluster-up: 
  cd terraform/
  terraform init
  terraform apply -auto-approve

cluster-down: 
  cd terraform/
  terraform destroy

app-deploy: 
  ansible-playbook ansible/deploy-pipeline.yml

down: cluster-down  