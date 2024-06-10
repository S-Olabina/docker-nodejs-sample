
resource "helm_release" "psql_bitnami" {
  name = "psql-bitnami"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "postgresql"
  namespace = "vegait-training"
  create_namespace = true
  version = "~> 15.5.0"

  set {
    name = "primary.persistence.enabled"
    value = "true"
  }
  set {
    name = "primary.persistence.volumeName"
    value = "psql-pvc-volume"
  }
  set {
    name = "primary.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }
  set {
    name = "auth.username"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "username", "Error")
  }
  set {
    name = "auth.password"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "password", "Error")
  }
  set {
    name = "auth.database"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "dbname", "Error")
  }
  set {
    name = "containerPorts.postgresql"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "port", "Error")
  }
  set {
    name = "primary.persistence.storageClass"
    value = kubernetes_storage_class.storage_class.metadata[0].name
  }

}


resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = "task2-storage-class"
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"

  parameters = {
    "encrypted" = "true"
  }
}
