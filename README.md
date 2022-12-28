
# Dynamic Apollo Router Configuration for Kubernetes Deployments Using GitOps

## Introduction

The Apollo Router is a configurable, high-performance graph router for federated supergraphs. 
It features extensive declarative configuration options to enable and manage all sorts of 
things relevant to a given Apollo Router deployment. For example, the Apollo Router can be 
configured to employ various traffic shaping optimizations with respect to its communications 
with downstream subgraphs. This includes things like enabling compression, setting global 
rate limits, timeouts, and other like measures. Additionally, the Apollo Router configuration 
can be used to enable or disable features like introspection, set various CORS settings, 
override subgraph routing URLs (e.g., to handle changing network topology), and much more. 
For a complete list of configuration options, see the [relevant documentation]("https://www.apollographql.com/docs/router/configuration/overview").

Using the `--hot-reload` flag, the Apollo Router can be made to watch for changes to its 
configuration and schema files. When changes occur, the Apollo Router will reload the files 
and incorporate any changes therein without any downtime. 

Here, taking advantage of the above
and utilizing the popular, kubernetes `sidecar pattern`, we will create a multi-container 
Apollo Router deployment for kubernetes that automatically tracks and syncs changes 
to configuration files that we will store in a `git` repository hosted on `GitHub`. 
This design approach will allow us to keep each container small and simple, encourage re-use,
and make troubleshooting simpler. 


## Prerequisites

To follow along with the demonstration contained herein, the following prerequisites
must be met before continuing:

* `kind`
* `terraform`
* `kubectl`
* `docker`


## Getting Started

First, we need access to a kubernetes cluster. 



### Create Kubernetes Cluster

Any kubernetes cluster will do. Here, we'll use `terraform` and `kind` 
to setup a cluster on our local machine. Note: `kind` requires `docker`
to be up and running.

Change into the `cluster` directory.

```shell
cd cluster
```

Initialize the `terraform` project.

```shell
terraform init
```

Create the `kind` cluster.

```shell
terraform apply
```


### Create Router Deployment




