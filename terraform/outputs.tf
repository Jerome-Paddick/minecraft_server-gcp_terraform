
output "start_server_url" {
  value = google_cloudfunctions_function.start_server.https_trigger_url
}

output "stop_server" {
  value = google_cloudfunctions_function.stop_server.https_trigger_url
}
