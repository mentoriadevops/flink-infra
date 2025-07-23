terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.45.0"
    }
  }
}

provider "google" {
  project = "mentoria-20250722"
}

resource "google_compute_instance" "flink" {
  name         = "flink"
  machine_type = "e2-small"
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  tags = ["flink"]
  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
    usermod -aG docker $USER
    docker run -p 8080:8080 -d quay.io/rtraceio/flink
    EOT
}
