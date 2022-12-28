terraform { }

provider "kubernetes" {
  host                   = var.k8s_host
  client_certificate     = var.k8s_client_certificate
  client_key             = var.k8s_client_key
  cluster_ca_certificate = var.k8s_cluster_ca_certificate
  token                  = var.k8s_cluster_client_token
}

provider "vault" {
  alias   = "ca"
  address = var.vault_address
  token   = var.vault_token
}

variable "module_depends_on" {
  type    = any
  default = []
}

resource "vault_mount" "ca" {
  depends_on = [ var.module_depends_on ]
  provider    = vault.ca
  path        = "ca"
  type        = "pki"
  description = "CA server"

  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_config_ca" "ca" {
  depends_on = [vault_mount.ca]
  provider   = vault.ca
  backend    = vault_mount.ca.path
  pem_bundle = var.vault_ca_pem_bundle
}

resource "vault_pki_secret_backend_config_urls" "ca" {
  depends_on           = [vault_mount.ca]
  provider             = vault.ca
  backend              = vault_mount.ca.path
  issuing_certificates = [ "${var.vault_address}/v1/pki/ca" ]
}

resource "vault_pki_secret_backend_role" "ca" {
  depends_on         = [ vault_mount.ca ]
  provider           = vault.ca
  backend            = vault_mount.ca.path
  name               = "ca"

  ttl                = 3600
  max_ttl            = 86400
  key_type           = "rsa"
  key_bits           = 2048
  allow_ip_sans      = true
  require_cn         = false
  allow_bare_domains = true
  allow_subdomains   = true
  allowed_domains    = concat([
    "config-sidecar-injector-service",
    "config-sidecar-injector-service.platform",
    "config-sidecar-injector-service.platform.svc",
    "local"
  ], var.vault_allowed_domains)
  key_usage          = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment",
 ]
}

resource "vault_policy" "ca" {
  depends_on         = [ vault_mount.ca ]
  provider           = vault.ca
  name               = "ca"

  policy = <<EOT
path "ca*"                               { capabilities = [ "read", "list"     ] }
path "ca/roles/config-admission-webhook" { capabilities = [ "read", "list", "create", "update" ] }
path "ca/sign/*"                         { capabilities = [ "read", "list", "create", "update" ] }
path "ca/issue/config-admission-webhook" { capabilities = [ "read", "list", "create"           ] }
EOT
}

###############################

resource "kubernetes_service_account" "sa_vault_auth" {
  depends_on = [ vault_pki_secret_backend_role.ca ]
  metadata {
    name      = "vault-auth"
    namespace = var.cert_manager_namespace
  }
}

resource "kubernetes_cluster_role_binding" "role_tokenreview_binding" {
  depends_on = [ vault_pki_secret_backend_role.ca ]
  metadata {
    name = "role-tokenreview-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vault-auth"
    namespace = var.cert_manager_namespace
  }
}

data "kubernetes_secret" "sec_vault_auth" {
  metadata {
    name      = kubernetes_service_account.sa_vault_auth.default_secret_name
    namespace = var.cert_manager_namespace
  }
}

resource "vault_auth_backend" "kubernetes_auth_be_pki" {
  depends_on = [ vault_pki_secret_backend_role.ca ]
  provider   = vault.ca
  type       = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kube_auth_be_conf_pki" {
  backend                = vault_auth_backend.kubernetes_auth_be_pki.path
  provider               = vault.ca

  kubernetes_host        = "https://kubernetes.default.svc.cluster.local:443"
  token_reviewer_jwt     = data.kubernetes_secret.sec_vault_auth.data.token
  issuer                 = "https://kubernetes.default.svc.cluster.local"
  disable_iss_validation = "true"
}

resource "vault_kubernetes_auth_backend_role" "ca" {
  backend                          = vault_auth_backend.kubernetes_auth_be_pki.path
  provider                         = vault.ca
  role_name                        = "ca"
  bound_service_account_names      = [ "vault-auth"  ]
  bound_service_account_namespaces = [ var.cert_manager_namespace ]
  token_ttl                        = 3600
  token_policies                   = [ "default", "ca" ]
}

resource "kubernetes_manifest" "ca_mgmt_cluster_issuer" {
  depends_on = [ vault_kubernetes_auth_backend_role.ca ]

  manifest   = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata"   = {
      "name" = "vault-issuer"
    }
    "spec" = {
      "vault" = {
        "server"   = "${var.vault_address}"
        "path"     = "ca/sign/ca"
        "caBundle" = var.ca_bundle
        "auth"     = {
          "kubernetes" = {
            "mountPath"  = "/v1/auth/kubernetes"
            "role"       = "ca"
            "secretRef"  = {
              "name" = kubernetes_service_account.sa_vault_auth.default_secret_name
              "key"  = "token"
            }
          }
        }
      }
    }
  }
}

