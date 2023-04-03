module "overlay" {
  source = "./modules/overlay"

  account                     = var.account
  load_restrictor             = var.load_restrictor
  annotation_prefix           = var.annotation_prefix
  common_annotations          = var.common_annotations
  labels                      = var.labels
  common_labels               = var.common_labels
  components                  = var.components
  custom_resource_definitions = var.custom_resource_definitions
  generators                  = var.generators
  name_prefix                 = var.name_prefix
  name_suffix                 = var.name_suffix
  namespace                   = var.namespace
  replicas                    = var.replicas
  resources                   = var.resources
  transformers                = var.transformers
  helm_path                   = var.helm_path
  helm_charts                 = var.helm_charts
  patches                     = var.patches
}

module "resources" {
  source = "./modules/consolidator"

  overlays = [
    module.overlay,
  ]

  wait = var.wait
}
