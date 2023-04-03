variable "overlays" {
  type = list(object({
    ids_prio  = list(list(string))
    manifests = map(string)
  }))
}

variable "wait" {
  type        = bool
  default     = null
  description = "Whether to wait for pods to become ready"
}
