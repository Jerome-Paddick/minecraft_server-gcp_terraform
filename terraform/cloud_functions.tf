data "archive_file" "start_server_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../files/functions/start_server"
  output_path = "${path.module}/../files/zips/start_server.zip"
}

data "archive_file" "stop_server_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../files/functions/stop_server"
  output_path = "${path.module}/../files/zips/stop_server.zip"
}

resource "google_cloudfunctions_function_iam_member" "start_server_invoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.start_server.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers" # Use "allAuthenticatedUsers" to require users to be authenticated
}

resource "google_cloudfunctions_function_iam_member" "stop_server_invoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.stop_server.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_storage_bucket" "server_functions_bucket" {
  name = "server-functions-source"
  location = var.location
}

resource "google_storage_bucket_object" "start_server_zip" {
  name   = "start_server.zip"
  bucket = google_storage_bucket.server_functions_bucket.name
  source = data.archive_file.start_server_zip.output_path
  detect_md5hash = true
}

resource "google_storage_bucket_object" "stop_server_zip" {
  name   = "stop_server.zip"
  bucket = google_storage_bucket.server_functions_bucket.name
  source = data.archive_file.stop_server_zip.output_path
  detect_md5hash = true
}

resource "google_cloudfunctions_function" "start_server" {
  name                  = "start_server"
  description           = "Start the server"
  runtime               = "python39"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.server_functions_bucket.name
  source_archive_object = google_storage_bucket_object.start_server_zip.name
  entry_point           = "start_server"
  trigger_http          = true
  project               = var.project_id
  region                = var.region
}

resource "google_cloudfunctions_function" "stop_server" {
  name                  = "stop_server"
  description           = "Stop the server"
  runtime               = "python39"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.server_functions_bucket.name
  source_archive_object = google_storage_bucket_object.stop_server_zip.name
  entry_point           = "stop_server"
  trigger_http          = true
  project               = var.project_id
  region                = var.region
}
