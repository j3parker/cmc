variable "googlecreds" {
  type = string
}

locals {
  region = "northamerica-northeast1"
}

provider "google" {
  credentials = "${var.googlecreds}"
  project     = "cmc-things"
  region      = "${local.region}"
}
