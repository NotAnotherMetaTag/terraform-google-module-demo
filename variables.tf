variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = null
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "preemptible" {
  type        = bool
  description = "Allow the instance to be preempted"
  default     = false
}

variable "on_host_maintenance" {
  type        = string
  description = "Set action for live migration. Ex. MIGRATE or TERMINATE. Note guest accelerator only supports TERMINATE"
  default     = "MIGRATE"
}

variable "region" {
  type        = string
  description = "Region where the instance template should be created."
  default     = null
}

variable "enable_secure_boot" {
  type        = bool
  description = "Toggle secure boot. Set to false if using guest accelerator"
  default     = true
}

#######
# disk
#######
variable "source_image" {
  description = "Source disk image. The image must be a shielded image."
  type        = string
}

variable "source_image_project" {
  description = "Project where the source image comes from."
  type        = string
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  default     = "100"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = "true"
}

variable "additional_disks" {
  description = "List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#disk_name"
  type = list(object({
    auto_delete  = bool
    boot         = bool
    disk_size_gb = number
    disk_type    = string
  }))
  default = []
}

####################
# network_interface
####################
variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  default     = ""
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = ""
}

variable "subnetwork_project" {
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used."
  default     = ""
}

###########
# metadata
###########

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

##################
# service_account
##################

variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

###########################
# Public IP
###########################
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}

###########################
# Naming Convention
###########################
variable "app_code" {
  description = "Application code. Always starts with 'a' abcd = reserved for corebuild team."
  type        = string
}
variable "label" {
  description = "A meaningful description in hyphen-case of the template's use case."
  type        = string
}
variable "vers" {
  description = "The version of the template, in the format of 'v[int]'. e.g. v12"
  type        = string
}

###########################
# Guest Accelerator
###########################

variable "enable_guest_accelerator" {
  default     = false
  description = "Whether to enable guest accelerator (GPU) configuration on the instance"
}

variable "guest_accelerator_config" {
  description = "Not used unless enable_guest_accelerator is true. Guest accelerator (GPU) configuration for the instance."
  type = object({
    type  = string
    count = string
  })

  default = {
    type  = "nvidia-tesla-k80"
    count = "1"
  }
}

###########################
# name_prefix condition
###########################
variable "enable_name_prefix" {
  description = "If set to true, use name_prefix argument. If set to false, use name argument"
  type        = bool
  default     = false
}
