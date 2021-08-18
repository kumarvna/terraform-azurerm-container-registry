# Azure Container Registry Terraform Module

The Azure container registry is Microsoft's hosting platform for Docker images. It is a private registry where you can store and manage the private Docker container images and other related artefacts. These images can then be pulled and run locally or used for container-based deployments to hosting platforms.

This Terraform module helps create Azure Container Registry with optional scope-map, token, webhook, Network ACLs, encryption and Private endpoints.

## Module Usage examples for

- [Container Registry with Georeplications](container_registry_with_georeplications/README.md)
- [Container Registry with Encryption](container_registry_with_encryption/README.md)
- [Container Registry with Private Endpoint and other optinal resources](container_registry_with_private_endpoint/README.md)

## Terraform Usage

To run this example you need to execute following Terraform commands

```hcl
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you don't need these resources.
