## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding.role_tokenreview_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_manifest.ca_mgmt_cluster_issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_service_account.sa_vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [vault_auth_backend.kubernetes_auth_be_pki](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_kubernetes_auth_backend_config.kube_auth_be_conf_pki](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_role.ca](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_role) | resource |
| [vault_mount.ca](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_pki_secret_backend_config_ca.ca](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_config_ca) | resource |
| [vault_pki_secret_backend_config_urls.ca](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_config_urls) | resource |
| [vault_pki_secret_backend_role.ca](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_role) | resource |
| [vault_policy.ca](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [kubernetes_secret.sec_vault_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_bundle"></a> [ca\_bundle](#input\_ca\_bundle) | n/a | `string` | n/a | yes |
| <a name="input_k8s_host"></a> [k8s\_host](#input\_k8s\_host) | n/a | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | n/a | `string` | n/a | yes |
| <a name="input_vault_allowed_domains"></a> [vault\_allowed\_domains](#input\_vault\_allowed\_domains) | n/a | `list(string)` | n/a | yes |
| <a name="input_vault_ca_pem_bundle"></a> [vault\_ca\_pem\_bundle](#input\_vault\_ca\_pem\_bundle) | n/a | `string` | n/a | yes |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | n/a | `string` | `"cert-manager"` | no |
| <a name="input_k8s_client_certificate"></a> [k8s\_client\_certificate](#input\_k8s\_client\_certificate) | n/a | `string` | `""` | no |
| <a name="input_k8s_client_key"></a> [k8s\_client\_key](#input\_k8s\_client\_key) | n/a | `string` | `""` | no |
| <a name="input_k8s_cluster_ca_certificate"></a> [k8s\_cluster\_ca\_certificate](#input\_k8s\_cluster\_ca\_certificate) | n/a | `string` | `""` | no |
| <a name="input_k8s_cluster_client_token"></a> [k8s\_cluster\_client\_token](#input\_k8s\_cluster\_client\_token) | n/a | `string` | `""` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | n/a | `any` | `[]` | no |

## Outputs

No outputs.
