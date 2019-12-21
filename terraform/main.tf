locals {
  region = "northamerica-northeast1"
  zone   = "northamerica-northeast1a"
}

terraform {
  backend "gcs" {
    bucket = "cmc-prod-tf-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "cmc-things"
  region  = "${local.region}"
}
