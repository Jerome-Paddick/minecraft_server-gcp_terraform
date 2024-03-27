#!/bin/bash

# Variables from environment variables. Set these in your .bashrc, .profile, or the systemd service file that starts your server.
WORLD_DIR="/home/minecraft/world"
BUCKET_NAME="${MC_BUCKET_NAME}" # envar
BACKUP_NAME="minecraft-world-$(date +%Y%m%d%H%M%S).zip"

# Check if required environment variables are set
if [ -z "$BUCKET_NAME" ]; then
  echo "Error: Environment variables MC_WORLD_DIR or MC_BUCKET_NAME are not set."
  exit 1
fi

# Compress the Minecraft world directory
zip -r "/tmp/${BACKUP_NAME}" "${WORLD_DIR}"

# Upload the backup to Google Cloud Storage
gsutil cp "/tmp/${BACKUP_NAME}" "gs://${BUCKET_NAME}/${BACKUP_NAME}"

# Optional: Remove the local backup file to save space
rm "/tmp/${BACKUP_NAME}"