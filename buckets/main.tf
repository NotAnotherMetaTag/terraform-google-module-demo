/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  bucket_name         = lower(join("-", list(var.org, random_id.suffix.hex, var.classification, var.data_source, var.tnt_code, var.location, var.env)))
  storage_bucket_name = element(concat(google_storage_bucket.bucket.*.name, [""]), 0) # to return a string
  destination_uri     = "storage.googleapis.com/${local.storage_bucket_name}"         # destination_uri is necessary to create the sink
  service_account     = var.log_sink_writer_identity != "" ? 1 : 0
}

resource "google_storage_bucket" "bucket" {
  count                       = var.enabled ? 1 : 0
  name                        = local.bucket_name
  project                     = var.project_id
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.bucket_policy_only
  labels                      = var.labels
  versioning {
    enabled = var.versioning
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = lookup(var.retention_policy, "is_locked", false)
      retention_period = lookup(var.retention_policy, "retention_period", 1)
    }
  }

  force_destroy = var.force_destroy

  dynamic "encryption" {
    for_each = var.default_kms_key_name == null ? [] : [var.default_kms_key_name]
    content {
      default_kms_key_name = var.default_kms_key_name
    }
  }

  dynamic "lifecycle_rule" {
    for_each = [for lr in var.lifecycle_rule : {
      action    = lr.action
      condition = lr.condition
    }]
    content {
      action {
        type          = lookup(lifecycle_rule.value.action, "type", null)
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        created_before        = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state            = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_storage_class = lookup(lifecycle_rule.value.condition, "matches_storage_class", null)
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : [var.logging]
    content {
      log_bucket        = lookup(logging.value, "log_bucket", null)
      log_object_prefix = lookup(logging.value, "log_object_prefix", null)
    }
  }

}

resource "google_storage_bucket_iam_member" "members" {
  for_each = var.enabled ? {
    for m in var.iam_members : "${m.role} ${m.member}" => m
  } : {}
  bucket = google_storage_bucket.bucket[0].name
  role   = each.value.role
  member = each.value.member
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_storage_bucket_iam_member" "storage_sink_member" {
  count  = (var.enabled && local.service_account != 0) ? 1 : 0
  bucket = local.storage_bucket_name
  role   = "roles/storage.objectCreator"
  member = var.log_sink_writer_identity
}