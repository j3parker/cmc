# This bucket stores keys (the Synapse signing key, TLS certificates, ...)
# We mount it with gcsfuse.
resource "google_storage_bucket" "chat-keys" {
  name     = "cmc-chat-keys"
  location = "${local.region}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_address" "chat" {
  name         = "chat-ip"
  network_tier = "PREMIUM"
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-1804-lts"
  project = "gce-uefi-images"
}

resource "google_compute_disk" "db" {
  name = "db"
  type = "pd-standard"
  size = "5" # GB
  zone = "${local.zone}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_instance" "chat" {
  name         = "chat"
  machine_type = "n1-standard-1"
  zone         = "${local.zone}"
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  attached_disk {
    source      = google_compute_disk.db.self_link
    device_name = "db"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.chat.address
    }
  }

  service_account {
    scopes = ["storage-full"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

  metadata_startup_script   = file("boot-chat.sh")
  allow_stopping_for_update = true
}

resource "google_compute_firewall" "chat" {
  name    = "chat"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
