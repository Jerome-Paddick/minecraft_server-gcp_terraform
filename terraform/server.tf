
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

    # metadata_startup_script = file("${path.module}/../files/scripts/startup_script.sh")

    metadata_startup_script = <<-EOT
    
    #! /bin/bash

    sudo yum update -y
    sudo yum install -y unzip java-1.8.0-openjdk

    java -version

    mkdir -p /home/minecraft
    cd /home/minecraft

    # Download server files
    gsutil cp gs://${google_storage_bucket_object.server_files_zip.bucket}/${google_storage_bucket_object.server_files_zip.name} /home/minecraft/server_files.zip

    # List files in the GCS bucket, sort them by modification time, and get the most recent one
    LATEST_ZIP=\$(gsutil ls -l gs://${google_storage_bucket.world_backups.name}/*.zip | sort -k2n | tail -n 1 | awk '{print \$NF}')

    # If no file was found, exit
    if [ -z "$LATEST_ZIP" ]; then
        echo "No zip file found."
        exit 1
    fi

    # Download the latest world file
    gsutil cp $LATEST_ZIP /home/minecraft/latest_world.zip

    # Unzip the files
    mkdir -p /home/minecraft/world
    unzip /home/minecraft/latest_world.zip -d /home/minecraft/world
    unzip /home/minecraft/server_files.zip -d /home/minecraft

    # Remove Zip file
    rm /home/minecraft/latest_world.zip
    rm /home/minecraft/server_files.zip
    
    echo "eula=true" > eula.txt

    java -Xmx8192M -Xms4096M -jar forge-1.12.2-14.23.5.2860.jar nogui
    EOT

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
