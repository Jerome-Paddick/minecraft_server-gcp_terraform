from google.cloud import storage

def maintain_rolling_storage(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
        event (dict): Event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """
    bucket_name = event['bucket']
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)

    # List all objects in the bucket
    blobs = list(bucket.list_blobs())
    
    # Check if the bucket contains more than 5 items
    if len(blobs) > 5:
        # Sort the blobs by creation time (oldest first)
        blobs_sorted = sorted(blobs, key=lambda blob: blob.time_created)
        
        # Remove the oldest blobs until only 5 remain
        for blob in blobs_sorted[:-5]:
            print(f"Deleting {blob.name}...")
            blob.delete()