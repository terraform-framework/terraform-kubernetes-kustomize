variable "account" {
  type = object({
    build = optional(object({
      name = string
    }))

    deployment = optional(object({
      name = string
    }))

    resource_name = optional(object({
      format = string
    }))

    tag_name = optional(object({
      format = string
    }))

    tags = optional(map(string))
  })

  default  = null
  nullable = true
}

variable "load_restrictor" {
  type    = string
  default = "none"
}

variable "annotation_prefix" {
  type    = string
  default = null
}

variable "common_annotations" {
  type    = map(string)
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "common_labels" {
  type    = map(string)
  default = {}
}

variable "components" {
  type    = list(string)
  default = []
}

variable "custom_resource_definitions" {
  type    = list(string)
  default = []
}

variable "generators" {
  type    = list(string)
  default = []
}

variable "name_prefix" {
  type    = string
  default = null
}

variable "name_suffix" {
  type    = string
  default = null
}

variable "namespace" {
  type    = string
  default = null
}

variable "replicas" {
  type    = map(number)
  default = {}
}

variable "resources" {
  type    = list(string)
  default = []
}

variable "transformers" {
  type    = list(string)
  default = []
}

variable "helm_path" {
  type    = string
  default = "helm"
}

variable "helm_charts" {
  type = list(object({
    name          = string
    version       = string
    repo          = string
    release_name  = optional(string)
    namespace     = optional(string)
    include_crds  = optional(bool, true)
    values_file   = optional(string)
    values_inline = optional(string)
    values_merge  = optional(string)
  }))

  default = []
}

variable "patches" {
  type = list(object({
    path  = optional(string)
    patch = optional(string)

    target = object({
      group               = optional(string)
      version             = optional(string)
      kind                = optional(string)
      name                = optional(string)
      namespace           = optional(string)
      label_selector      = optional(string)
      annotation_selector = optional(string)
    })

    options = optional(object({
      allow_kind_change = optional(bool, false)
      allow_name_change = optional(bool, false)
      }), {
      allow_kind_change = false
      allow_name_change = false
    })
  }))

  default = []
}
