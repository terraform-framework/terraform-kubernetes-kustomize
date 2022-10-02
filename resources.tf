locals {
  group_regex = "(?P<group_kind>.*/.*)/.*/.*"
}

resource "kustomization_resource" "first" {
  for_each = data.kustomization_overlay.this.ids_prio[0]

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.this.manifests[each.value])
    : data.kustomization_overlay.this.manifests[each.value]
  )
}

resource "kustomization_resource" "second" {
  for_each = data.kustomization_overlay.this.ids_prio[1]

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.this.manifests[each.value])
    : data.kustomization_overlay.this.manifests[each.value]
  )

  depends_on = [
    kustomization_resource.first,
  ]
}

resource "kustomization_resource" "third" {
  for_each = data.kustomization_overlay.this.ids_prio[2]

  manifest = (
    contains(["_/Secret"], regex(local.group_regex, each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.this.manifests[each.value])
    : data.kustomization_overlay.this.manifests[each.value]
  )

  depends_on = [
    kustomization_resource.second,
  ]
}
