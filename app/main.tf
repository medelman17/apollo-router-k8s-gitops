## /app/main.tf

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host = var.host
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

resource "kubernetes_deployment" "apollo-router" {
  metadata {
    name = "git-sync"
    labels = {
      App = "ApolloRouterGitOpsExample"
    }
  }
  spec {
    selector {
      match_labels = {
        App = "ApolloRouterGitOpsExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ApolloRouterGitOpsExample"
        }
      }
      spec {
        container {
          name = "app"
          image = "nginx"

          volume_mount {
            mount_path = "/usr/share/nginx/"
            name       = "html"
          }

          resources {
            limits = {
              cpu = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu = "250m"
              memory = "50Mi"
            }
          }

        }
        container {
          name = "sync"
          image = "k8s.gcr.io/git-sync:v3.1.6"


          volume_mount {
            mount_path = "/tmp/git"
            name       = "html"
          }

          env {
            name = "GIT_SYNC_REPO"
            value = "https://github.com/medelman17/apollo-router-k8s-gitops.git"
          }

          env {
            name = "GIT_SYNC_BRANCH"
            value = "main"
          }

          env {
            name = "GIT_SYNC_DEPTH"
            value = "1"
          }

          env {
            name = "GIT_SYNC_DEST"
            value = "html"
          }

        }

        volume {
          name = "html"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "apollo-router" {
  metadata {
    name = "svc-sidecar"
  }
  spec {
    selector = {
      App = kubernetes_deployment.apollo-router.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port = 80
      node_port = "30001"
#      target_port = "80"
    }
    type = "NodePort"
  }
}