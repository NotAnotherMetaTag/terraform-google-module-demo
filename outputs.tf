output "buckets" {
    description = "info dump on all made buckets. not trying very hard."
    value = module.buckets[*].bucket
}