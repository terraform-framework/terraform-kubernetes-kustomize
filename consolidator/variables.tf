variable "overlays" {
  type = list(object({
    ids_prio  = list(list(string))
    manifests = map(string)
  }))
}
