variable "ca_bundle"                  { type = string       }
variable "vault_address"              { type = string       }
variable "vault_ca_pem_bundle"        { type = string       }
variable "vault_allowed_domains"      { type = list(string) }

variable "k8s_host" {
  type      = string
  sensitive = true
}

variable "k8s_client_certificate" {
  type      = string
  sensitive = true
  default   = ""
}

variable "k8s_client_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "k8s_cluster_ca_certificate" {
  type      = string
  sensitive = true
  default   = ""
}

variable "k8s_cluster_client_token" {
  type      = string
  sensitive = true
  default   = ""
}
variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}
