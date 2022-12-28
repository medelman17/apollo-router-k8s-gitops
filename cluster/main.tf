terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
  name = "apollo-router-gitops-demo"
  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control_plane"
    }
  }
}

output "client_certificate" {
  value = kind_cluster.default.client_certificate
}

output "client_key" {
  value = kind_cluster.default.client_key
}

output "cluster_ca_certificate" {
  value = kind_cluster.default.cluster_ca_certificate
}

output "host" {
  value = kind_cluster.default.endpoint
}