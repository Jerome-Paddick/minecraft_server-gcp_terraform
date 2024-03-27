
resource "google_compute_instance" "mc_server" {
    depends_on = [ 
        google_storage_bucket_object.world_zip,
        google_storage_bucket_object.server_files_zip,
    ]

    name         = "mc-server"
    machine_type = "n2-standard-2"
    zone         = var.zone

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-7"
        }
    }

    network_interface {
        network = "default"
        access_config {
            // Ephemeral IP
        }
    }

    metadata_startup_script = file("${path.module}/../files/scripts/startup_script.sh")

    tags = ["minecraft-server"]
}

resource "google_service_account" "jjmc_compute_instance_service_account" {
    account_id   = "jjmc-ci-service-account"
    display_name = "JJMC instance Service Account"
}

resource "google_project_iam_binding" "object_viewer_binding" {
    project = var.project_id
    role    = "roles/storage.objectViewer"

    members = [
        "serviceAccount:${google_service_account.jjmc_compute_instance_service_account.email}",
    ]
}

resource "google_project_iam_binding" "object_creator_binding" {
  project = var.project_id
  role    = "roles/storage.objectCreator"

  members = [
    "serviceAccount:${google_service_account.jjmc_compute_instance_service_account.email}",
  ]
}


resource "google_compute_firewall" "minecraft_fw" {
  name    = "minecraft-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-server"]
}
