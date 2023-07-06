provider "google" {
  region      = "northamerica-northeast2"
  zone        = "northamerica-northeast2a"
}

resource "google_compute_instance" "jenkins-server" {
  name         = "jenkins-server"
  machine_type = "e2-micro"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  
  network_interface {
    network = "default"
    access_config {
    }
  }
}
