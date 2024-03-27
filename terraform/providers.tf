terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.20.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.20.0"
    }
  }
}

provider "google" {
  credentials = file("${path.module}/../config/creds.json")
  project     = var.project_id
  region      = var.region
}
