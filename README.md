# SKO2023-Terraform-Advanced

 Terraform for the SKO Terraform Advanced session

## Packaging

This repo contains all the necessary code to both configure and demonstrate a single Use Case of a Ping integrated application.

Everything needed for this demonstration is contained in this repo:

`/terraform` -- contains the HCL to deploy everything  
`/DaVinci` -- contains the DV Flow JSON that you'd like to deploy  
`/DV-App` -- contains the source of a NodeJS app that demostrates integration with the DaVinci Widget

### Terraform

The HCL contains resources for PingOne \ DaVinci and for k8s.  
K8s is used to deploy the application image with an associated Ingress to allow browser access to the container.

#### Providers

The Terraform here uses multiple providers:

| Provider | Description |
| --- | --- |
| **PingOne** | PingOne Environment \ Services configuration |
| **DaVinci** | PingOne DaVinci Flow & Application |
| **Kubernetes** | Configure k8s infrastructure components |

#### Terraform Resources

This is what the HCL will create

| Provider | Resource | Description |
| --- | --- | --- |
| PingOne | Environment | Contains all the P1 configuration for the app |
| PingOne | Application | OIDC App used by the app |
| PingOne | Resource Grant | Assigns resources \ scopes to the OIDC App |
| DaVinci | Flow | Import of the Flow JSON |
| DaVinci | Application | Flow assigned to a Policy |
| K8s | Deployment | Deploy the sample app |
| K8s | Service | Service pointing to the deployed app |
| K8s | Ingress | Inbound access to deployed app |

#### Variables

Create a `terraform.tfvars` file with the following:

```hcl
region = "{{ NorthAmerica | Canada | Asia | Europe }}"
organization_id = "{{orgId}}"
admin_env_id = "{{adminEnvId}}"
admin_user_id = "{{adminUserId}}"
admin_user_name = "{{Admin Username - needed for DV}}"
admin_user_password = "{{Admin User Password - needed for DV}}"
license_name = "{{License name to put on new Env}}"
worker_id = "{{workerId}}"
worker_secret = "{{workerSecret}}"
env_name = "{{PingOne Environment Name to create}}"
k8s_deploy_name = "{{Name used for K8s deployment}}"
k8s_deploy_domain="ping-devops.com"
k8s_namespace = "{{k8s namespace}}"
app_image_name="docker.io/pricecs/dv-demo-app:0.0.4"
app_port={{Port the app is listening on}}
```

#### Deployment

At a command line:

```zsh
terraform init
terraform plan
```

If the plan fails - check your `terraform.tfvars` values.

If the plan succeeds:

```hcl
terraform apply —auto-approve
````

If successful, you should be given the URL of the application that you can access with a browser
