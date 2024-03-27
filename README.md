
LOCAL CONFIG

gcloud auth configure-docker

APIs to enable

https://console.cloud.google.com/apis/library/iam.googleapis.com
https://console.cloud.google.com/apis/library/containerregistry.googleapis.com
https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com
https://console.cloud.google.com/apis/library/cloudfunctions.googleapis.com
https://console.cloud.google.com/apis/library/cloudbuild.googleapis.com
https://console.cloud.google.com/apis/library/artifactregistry.googleapis.com

---

Server
---

Compute instance

Firewall

Cloudfunctions



DEBUGGING
---


 rerun the startup script -  `sudo google_metadata_script_runner startup`


View the startup script logs -  `sudo journalctl -u google-startup-scripts.service`