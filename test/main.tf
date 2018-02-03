module "kontena_grid" {
  source = ".."
}

output "grid" {
  value = {
    name                = "${module.kontena_grid.name}"
    token               = "${module.kontena_grid.token}"
    uri                 = "${module.kontena_grid.uri}"
    initial_size        = "${module.kontena_grid.initial_size}"
    default_affinity    = "${module.kontena_grid.default_affinity}"
    subnet              = "${module.kontena_grid.subnet}"
    supernet            = "${module.kontena_grid.supernet}"
    trusted_subnets     = "${module.kontena_grid.trusted_subnets}"
    external_registries = "${module.kontena_grid.external_registries}"
    stats               = "${module.kontena_grid.stats}"
    statsd_server       = "${module.kontena_grid.statsd_server}"
    logs                = "${module.kontena_grid.logs}"
    nodes               = "${module.kontena_grid.nodes}"
    services            = "${module.kontena_grid.services}"
    stacks              = "${module.kontena_grid.stacks}"
    containers          = "${module.kontena_grid.containers}"
    volumes             = "${module.kontena_grid.volumes}"
  }
}
