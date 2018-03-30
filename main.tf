terraform {
        backend "gcs" {
                bucket  = "deploy-devops"
        prefix  = "deploy-devops-test"
        }
}

provider "google" {
        credentials = "${file("gcp_jenkins_credentials.json")}"
        project = "${var.project_id}"
        region = "${var.region}"
}

provider "kubernetes" {
  host = "${google_container_cluster.primary.endpoint}"
  client_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
  client_key = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}

resource "google_container_cluster" "primary" {
  name = "devops-deploy-test"
  zone = "${var.zone}"
  initial_node_count = 2

  node_config {
        oauth_scopes = [
                "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append"
        ]
        machine_type = "n1-standard-2"
        image_type = "COS"
        disk_size_gb = "50"
  }
}

resource "kubernetes_service" "mapping-geocoding" {
  metadata {
       name = "mapping-geocoding"
  }
  spec {
    selector {
      app = "${kubernetes_replication_controller.mapping-geocoding.metadata.0.labels.app}"
    }
    port {
      port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_replication_controller" "mapping-geocoding" {
  metadata {
    name = "mapping-geocoding"
    labels {
      app = "mapping-geocoding"
    }
  }

  spec {
    replicas = 1
    selector {
      app = "mapping-geocoding"
    }
    template {
      container {
        image = "${var.image_base_url}:${var.image_ver}"
        name  = "mapping-geocoding"
        resources{
          limits {
            cpu    = "1"
            memory = "1Gi"
          }
          requests{
            cpu    = "1"
            memory = "1Gi"
          }
        }
      }
    }
  }
}