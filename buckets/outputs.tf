output "bucket" {
  value       = google_storage_bucket.bucket.*.name
  description = "Detailed information about the bucket"
}

output "iam_members" {
  value       = google_storage_bucket_iam_member.members
  description = "Detailed information about the bucket's IAM members"
}

output "destination_uri" {
  description = "The destination URI for the storage bucket."
  value       = local.destination_uri
}

output "storage_bucket_name" {
  value = local.storage_bucket_name
}

output "destination" {
  description = "The destination referring to storage"
  value       = "storage"
}