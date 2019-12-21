variable "googlecreds" {
  type = string
}

locals {
  region = "northamerica-northeast1"
  zone   = "northamerica-northeast1a"
}

provider "google" {
  credentials = "${var.googlecreds}"
  project     = "cmc-things"
  region      = "${local.region}"
}
