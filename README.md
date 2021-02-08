# instance_template

This submodule allows you to create an `google_compute_instance_template`
resource, which is used as the basis for the other instance, managed, and
unmanaged instance groups submodules.

Mayo managed instances must use shielded VMs, and therefore will have secure boot, vtpm, and integrity monitoring enabled by default.

## Usage

```hcl
module "instance_template" {
  source          = "../../../modules/instance_template"
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  name_prefix     = "simple"
  tags            = var.tags
  labels          = var.labels
  access_config   = [local.access_config]
}
```
## Changelog
| Version | Description |
|------|-------------|
| 1.0.6 | Allow setting name_prefix argument using boolean variable var.enable_name_prefix
| 1.0.5 | Allow setting secure boot. Secure boot breaks support for Nvidia Drivers|
| 1.0.4 | Allow setting live migration policy |
| 1.0.3 | Allow configuration for guest_accelerator (GPU) |
| 1.0.2 | Project-Wide SSH has been disabled for all VMs made with this templates from this module. |
| 1.0.1 | Explicitly set host maintenance to migrate. |

## Testing
The fixtures use a `source_image_project` that will fail once in MCCP-Live due to org policies prohibiting outside OS images. `project_id` and `service_account` will also need to be updated for MCCP-Live.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access\_config | Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet. | object | `<list>` | no |
| additional\_disks | List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#disk_name | object | `<list>` | no |
| app\_code | Application code. Always starts with 'a' abcd = reserved for corebuild team. | string | n/a | yes |
| auto\_delete | Whether or not the boot disk should be auto-deleted | string | `"true"` | no |
| can\_ip\_forward | Enable IP forwarding, for NAT instances for example | string | `"false"` | no |
| disk\_size\_gb | Boot disk size in GB | string | `"100"` | no |
| disk\_type | Boot disk type, can be either pd-ssd, local-ssd, or pd-standard | string | `"pd-standard"` | no |
| enable\_guest\_accelerator | Whether to enable guest accelerator (GPU) configuration on the instance | string | `"false"` | no |
| enable\_name\_prefix | Whether to use name_prefix argument | bool | `"false"` | no |
| enable\_secure\_boot | Toggle secure boot. Set to false if using guest accelerator | bool | `"true"` | no |
| guest\_accelerator\_config | Not used unless enable_guest_accelerator is true. Guest accelerator (GPU) configuration for the instance. | object | `<map>` | no |
| label | A meaningful description in hyphen-case of the template's use case. | string | n/a | yes |
| labels | Labels, provided as a map | map(string) | `<map>` | no |
| machine\_type | Machine type to create, e.g. n1-standard-1 | string | `"n1-standard-1"` | no |
| metadata | Metadata, provided as a map | map(string) | `<map>` | no |
| network | The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks. | string | `""` | no |
| on\_host\_maintenance | Set action for live migration. Ex. MIGRATE or TERMINATE. Note guest accelerator only supports TERMINATE | string | `"MIGRATE"` | no |
| preemptible | Allow the instance to be preempted | bool | `"false"` | no |
| project\_id | The GCP project ID | string | `"null"` | no |
| region | Region where the instance template should be created. | string | `"null"` | no |
| service\_account | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account. | object | n/a | yes |
| source\_image | Source disk image. The image must be a shielded image. | string | n/a | yes |
| source\_image\_project | Project where the source image comes from. | string | n/a | yes |
| startup\_script | User startup script to run when instances spin up | string | `""` | no |
| subnetwork | The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided. | string | `""` | no |
| subnetwork\_project | The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used. | string | `""` | no |
| tags | Network tags, provided as a list | list(string) | `<list>` | no |
| vers | The version of the template, in the format of 'v[int]'. e.g. v12 | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | Name of instance template |
| self\_link | Self-link of instance template |
| tags | Tags that will be associated with instance(s) |
| template | The entire template resource that was created. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->