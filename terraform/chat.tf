# This bucket stores keys (the Synapse signing key, TLS certificates, ...)
# We mount it with gcsfuse.
resource "google_storage_bucket" "chat-keys" {
  name     = "cmc-chat-keys"
  location = "${local.region}"
}

resource "google_compute_address" "chat" {
  name         = "chat-ip"
  network_tier = "PREMIUM"
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-1804-lts"
  project = "gce-uefi-images"
}

resource "google_compute_instance" "chat" {
  name         = "chat"
  machine_type = "f1-micro"
  zone         = "${local.zone}"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.chat.address
    }
  }
}