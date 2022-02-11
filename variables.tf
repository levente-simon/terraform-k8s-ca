variable "k8s_host"                   { type = string       }
variable "k8s_client_certificate"     { type = string       }
variable "k8s_client_key"             { type = string       }
variable "k8s_cluster_ca_certificate" { type = string       }
variable "ca_bundle"                  { type = string       }
variable "vault_address"              { type = string       }
variable "vault_ca_pem_bundle"        { type = string       }
variable "vault_allowed_domains"      { type = list(string) }

variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}
