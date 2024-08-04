provider "local" {
  # This provider doesn't require configuration.
}

provider "null" {
  # This provider doesn't require configuration.
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/minikube-kubeconfig"
  }
}

resource "null_resource" "minikube_start" {
  provisioner "local-exec" {
    command = <<EOT
      minikube start --driver=docker
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
      minikube ip
    EOT
    on_failure = continue
    when = "destroy"
  }
}

resource "local_file" "kubeconfig" {
  content  = file("${local.kubeconfig_path}")
  filename = "${path.module}/minikube-kubeconfig"
}

data "local_file" "helm_chart" {
  filename = "${path.module}/../../platform/local/todo-app"
}

resource "helm_release" "my_app" {
  name       = "my-app"
  chart      = data.local_file.helm_chart.filename
  namespace  = "default"
  values     = []       # Add any values you need for your Helm chart

  depends_on = [null_resource.minikube_start]
}

locals {
  kubeconfig_path = "${path.module}/.kube/config"
}
