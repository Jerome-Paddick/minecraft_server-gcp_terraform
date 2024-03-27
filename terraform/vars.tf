variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "GCP region eg. europe-west2"
}

variable "location" {
  description = "GCP location eg. EU/ASIA/US"
}

variable "zone" {
  description = "GCP Zone"
}

variable "server_backups_bucket" {
  description = "server backups bucket name"
}

variable "server_files_bucket" {
  description = "server files bucket name"
}
