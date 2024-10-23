locals {
  google_project = "test-project-grit-438912"
  google_region  = "europe-west3"
  google_zone    = "europe-west3-a"
}

provider "google" {
  project = local.google_project
  region  = local.google_region
  zone    = local.google_zone
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_instance" "instance_with_ssh-keys_only" {
  name         = "instance-with-ssh-keys-only"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/family/cos-stable"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    ssh-keys = "example:${tls_private_key.ssh_key.public_key_openssh}"
  }
}

resource "google_compute_instance" "instance_with_ssh-keys_and_OSLogin" {
  name         = "instance-with-ssh-keys-and-oslogin"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/family/cos-stable"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    enable-oslogin = true
    ssh-keys       = "example:${tls_private_key.ssh_key.public_key_openssh}"
  }
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}
