# SERVER FILES

data "archive_file" "server_files_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../files/server"
  output_path = "${path.module}/../files/zips/server_files.zip"
}

resource "google_storage_bucket" "server_files_bucket" {
  name          = var.server_files_bucket
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "server_files_zip" {
  name   = "server_files.zip"
  bucket = google_storage_bucket.server_files_bucket.name
  source = data.archive_file.server_files_zip.output_path
  detect_md5hash = true
}

# WORLD FILES

data "archive_file" "world_files_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../files/world"
  output_path = "${path.module}/../files/zips/world.zip"
}

resource "google_storage_bucket" "world_backups" {
  name          = var.server_backups_bucket
  location      = var.region
  force_destroy = true # Allows Terraform to delete the bucket even if it contains objects
}

resource "google_storage_bucket_object" "world_zip" {
  name   = "world.zip"
  bucket = google_storage_bucket.world_backups.name
  source = data.archive_file.world_files_zip.output_path
  detect_md5hash = true
}
