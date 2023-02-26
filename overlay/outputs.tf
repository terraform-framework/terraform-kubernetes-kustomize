output "ids" {
  value = data.kustomization_overlay.this.ids
}

output "ids_prio" {
  value = data.kustomization_overlay.this.ids_prio
}

output "manifests" {
  value = data.kustomization_overlay.this.manifests
}
