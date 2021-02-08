data "google_compute_image" "disk_image" {
  name    = var.source_image
  project = var.source_image_project
}

locals {
  boot_disk = [
    {
      source_image = data.google_compute_image.disk_image.self_link
      disk_size_gb = var.disk_size_gb
      disk_type    = var.disk_type
      auto_delete  = var.auto_delete
      boot         = "true"
    },
  ]

  all_disks = concat(local.boot_disk, var.additional_disks)

  template_name = "${var.app_code}-${var.label}-${var.vers}"

  # This will allow users to enter any metadata they would like, but also will prevent project wide SSH keys
  project_ssh_keys = { block-project-ssh-keys = "True" }
  metadata         = merge(var.metadata, local.project_ssh_keys)

  #This will enable guest_accelerator configuration (GPU) within the template
  guest_accelerator_config = var.enable_guest_accelerator ? [true] : []
}

####################
# Instance Template
####################
resource "google_compute_instance_template" "tpl" {
  name                    = var.enable_name_prefix ? null : local.template_name
  name_prefix             = var.enable_name_prefix ? local.template_name : null
  project                 = var.project_id
  machine_type            = var.machine_type
  labels                  = var.labels
  metadata                = local.metadata
  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  metadata_startup_script = var.startup_script
  region                  = var.region
  dynamic "disk" {
    for_each = local.all_disks
    content {
      auto_delete  = lookup(disk.value, "auto_delete", null)
      boot         = lookup(disk.value, "boot", null)
      device_name  = lookup(disk.value, "device_name", null)
      disk_name    = lookup(disk.value, "disk_name", null)
      disk_size_gb = lookup(disk.value, "disk_size_gb", null)
      disk_type    = lookup(disk.value, "disk_type", null)
      interface    = lookup(disk.value, "interface", null)
      mode         = lookup(disk.value, "mode", null)
      source       = lookup(disk.value, "source", null)
      source_image = lookup(disk.value, "source_image", null)
      type         = lookup(disk.value, "type", null)

      dynamic "disk_encryption_key" {
        for_each = lookup(disk.value, "disk_encryption_key", [])
        content {
          kms_key_self_link = lookup(disk_encryption_key.value, "kms_key_self_link", null)
        }
      }
    }
  }
  dynamic "service_account" {
    for_each = [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

  lifecycle {
    create_before_destroy = "true"
  }

  # More info on resource options here: https://www.terraform.io/docs/providers/google/r/compute_instance_template.html

  # scheduling must have automatic_restart be false when preemptible is true.
  scheduling {
    preemptible         = var.preemptible
    automatic_restart   = ! var.preemptible
    on_host_maintenance = var.on_host_maintenance
  }

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  dynamic "guest_accelerator" {
    for_each = local.guest_accelerator_config
    content {
      type  = lookup(var.guest_accelerator_config, "type", null)
      count = lookup(var.guest_accelerator_config, "count", null)
    }
  }
}