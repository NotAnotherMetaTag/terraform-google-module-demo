data "google_storage_bucket_object_content" "buckets" {
  name   = "data.json"
  bucket = "remotejsonimport-test-eclark"
}

locals {
  json_data = jsondecode(data.google_storage_bucket_object_content.buckets.content)

  buckets = flatten([
    for bucket in local.json_data.buckets :
    {
      id          = bucket.id
      name        = bucket.name //this is used for logging, not for the resource name
      org         = bucket.org
      project_id  = bucket.project_id
      data_source = bucket.data_source
    }
  ])
}


module "buckets" {
  source  = "./buckets/"

  for_each = {
    for init in local.buckets : init.id => init
  }

  project_id = each.value.project_id
  org            = each.value.org
  classification = "config"
  data_source    = each.value.data_source
  tnt_code       = ""
  location       = "us-central1"
  env            = "t"
}
