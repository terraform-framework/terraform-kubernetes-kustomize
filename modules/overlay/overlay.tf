data "kustomization_overlay" "this" {
  // Set global options for kustomize. As these are
  // set at the top-level overlay, these options are
  // inherited by the lower level manifests. i.e. we
  // set helm as available here so it's implicitly
  // available in the lower level resources.
  kustomize_options {
    enable_helm     = true
    load_restrictor = var.load_restrictor
    helm_path       = var.helm_path
  }

  // Set the namespace for all resources
  namespace = var.namespace

  // Name prefix will automatically include the
  // `build` from the account module if it's present,
  // and will be appended to the input name prefix
  name_prefix = join("", compact([
    var.name_prefix,
    local.build.name == null ? null : format("%s-", local.build.name),
  ]))

  // Name suffix will automatically include the
  // `deployment` from the account module if it's present,
  // and will be prepended to the input name suffix
  name_suffix = join("", compact([
    var.name_suffix,
    local.deployment.name == null ? null : format("-%s", local.deployment.name),
  ]))

  // Common annoations will set all tag pairs specified
  // in the account input if specified. These are sanitised
  // to ensure they're DNS safe as required by kubernetes.
  // these can be optionally prefixed with the `annotation_prefix`
  // input variable to support `domain/tag-name` style.
  common_annotations = merge({
    for k, v in local.tags :
    join("/", compact([
      var.annotation_prefix,
      lower(replace(replace(k, "/([a-z])([A-Z])/", "$1-$2"), "/\\s+/", "-")),
    ])) => v if !contains(local.blacklisted_tags, k)
  }, var.common_annotations)

  // Allows setting labels to all resources
  // but only affects metadata labels, not selectors.
  labels {
    pairs = var.labels
  }

  // Sets the common labels that are assigned to both
  // metadata and selectors in any kubernetes manifests.
  // we also inject the `build` and `deployment` labels
  // which come from the account input.
  common_labels = merge({
    "terraform-framework/build"      = coalesce(local.build.name, "none")
    "terraform-framework/deployment" = coalesce(local.deployment.name, "none")
  }, var.common_labels)

  // Lsit of resource manifests
  resources = var.resources

  // List of component manifests
  components = var.components

  // List of CRD manifests
  crds = var.custom_resource_definitions

  // List of generator configs
  generators = var.generators

  // List of transformer configs
  transformers = var.transformers

  // Allow overriding replica and stateful set replicas
  dynamic "replicas" {
    for_each = var.replicas

    content {
      name  = replicas.key
      count = replicas.value
    }
  }

  dynamic "helm_charts" {
    for_each = var.helm_charts

    content {
      name          = helm_charts.value.name
      version       = helm_charts.value.version
      repo          = helm_charts.value.repo
      release_name  = helm_charts.value.release_name
      namespace     = helm_charts.value.namespace
      include_crds  = helm_charts.value.include_crds
      values_file   = helm_charts.value.values_file
      values_inline = helm_charts.value.values_inline
      values_merge  = helm_charts.value.values_merge
    }
  }

  dynamic "patches" {
    for_each = var.patches

    content {
      path  = patches.value.path
      patch = patches.value.patch

      target {
        group               = patches.value.target.group
        version             = patches.value.target.version
        kind                = patches.value.target.kind
        name                = patches.value.target.name
        namespace           = patches.value.target.namespace
        label_selector      = patches.value.target.label_selector
        annotation_selector = patches.value.target.annotation_selector
      }

      options {
        allow_kind_change = patches.value.options.allow_kind_change
        allow_name_change = patches.value.options.allow_name_change
      }
    }
  }
}
