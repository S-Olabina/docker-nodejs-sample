resource "helm_release" "bitnami" {
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

resource "helm_release" "custom-helm-chart" {
  name = "todo"
  repository = "oci://${module.ecr.repository_registry_id}.dkr.ecr.${var.region}.amazonaws.com"
  chart = "private-ecr-repo"
  version = "~> 0.1.0"
  namespace = "vegait-training"
  create_namespace = false

  set{
    name = "appname"
    value = "todo"
  }
  set{
    name = "namespace"
    value = "vegait-training"
  }
  set{
    name = "lable"
    value = "todo"
  }
  set{
    name = "replicaCount"
    value = 1
  }
  set{
    name = "fullnameOverride"
    value = "todo"
  }
  set{
    name = "map.userName"
    value = "postgres"
  }
  set{
    name = "map.password"
    value = "secret"
  }
  set{
    name = "map.dbname"
    value = "test2_db"
  }
  set{
    name = "map.host"
    value = "psql-bitnami"
  }
  set{
    name = "map.port"
    value = 5432
  }
  set{
    name = "image.repository"
    value = "ghcr.io/s-olabina/docker-nodejs-sample/test-app2"
  }
  set{
    name = "image.pullPolicy"
    value = "Always"
  }
  set{
    name = "image.tag"
    value = "latest"
  }
  set{
    name = "image.name"
    value = "test-app2"
  }
  set{
    name = "service.type"
    value = "ClusterIP"
  }
  set{
    name = "service.port"
    value = 80
  }
  set{
    name = "service.targetPort"
    value = 5432
  }
  set{
    name = "service.protocol"
    value = "TCP"
  }
  set{
    name = "ingress.className"
    value = "alb"
  }
  set{
    name = "ingress.host"
    value = var.domain
  }
  set{
    name = "ingress.path"
    value = "/"
  }
  set{
    name = "ingress.pathType"
    value = "Prefix"
  }
  set{
    name = "ingress.albTargetType"
    value = "ip"
  }
  set{
    name = "ingress.scheme"
    value = "internet-facing"
  }
  set{
    name = "ingress.certificateArn"
    value = module.acm.acm_certificate_arn
  }

}