locals {
  // Regex for finding all `Kind`s in manifests
  group_regex = "(?P<group_kind>.*/.*)/.*/.*"

  priority1_ids = concat([
    for x in var.overlays : x.ids_prio[0]
  ]...)

  priority2_ids = concat([
    for x in var.overlays : x.ids_prio[1]
  ]...)

  priority3_ids = concat([
    for x in var.overlays : x.ids_prio[2]
  ]...)

  manifests = merge(var.overlays.*.manifests...)
}
