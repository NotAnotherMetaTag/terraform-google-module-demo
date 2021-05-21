variable "org" {
  description = "The name of org for constructing the bucket name (ex: ml)"
  type        = string
}

variable "classification" {
  description = "The name of classification for constructing the bucket name (ex: config, phi)"
  type        = string
}

variable "data_source" {
  description = "The name of data source for constructing the bucket name (ex: dataproc, cardiology_uploads)"
  type        = string
}

variable "tnt_code" {
  description = "The name of the tenant for constructing the bucket name (ex: adp)"
  type        = string
}

variable "env" {
  description = "The name of the environment (ex: n)"
  type        = string
}

variable "project_id" {
  description = "The ID of the project"
  type        = string
}

variable "location" {
  description = "The GCS location"
  type        = string
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = null
}

variable "bucket_policy_only" {
  description = "Enables Bucket Policy Only access to a bucket."
  type        = bool
  default     = true
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = " When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  type        = bool
  default     = false
}

variable "iam_members" {
  description = "A list of IAM members where each item is a map containing 2 keys: role and member"
  type        = list
  default     = []
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type        = map(string)
  default     = null
}

variable "default_kms_key_name" {

  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  default     = null
}

variable "log_sink_writer_identity" {
  description = "The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module)."
  type        = string
  default     = ""

}
variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rule" {
  description = "A list of maps of bucket's Lifecycle Rules configuration"
  type        = any
  default     = []
}

variable "logging" {
  description = "The bucket's Access & Storage Logs configuration."
  type        = map(string)
  default     = null
}

variable "enabled" {
  description = "Flag to enable provisioning of storage bucket"
  default     = true
  type        = bool
}