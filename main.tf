variable "depends_id" {
  default = ""
}

variable "name" {
  default = ""
}

variable "organization" {
  default = ""
}

data "external" "kontena" {
  program = ["ruby", "${path.module}/grid.rb"]

  query {
    depends_id   = "${var.depends_id}"
    name         = "${var.name}"
    organization = "${var.organization}"
  }
}

output "name" {
  value = "${data.external.kontena.result["name"]}"
}

output "token" {
  value = "${data.external.kontena.result["token"]}"
}

output "uri" {
  value = "${data.external.kontena.result["uri"]}"
}

output "initial_size" {
  value = "${data.external.kontena.result["initial_size"]}"
}

output "default_affinity" {
  value = "${split(",", data.external.kontena.result["default_affinity"])}"
}

output "subnet" {
  value = "${data.external.kontena.result["subnet"]}"
}

output "supernet" {
  value = "${data.external.kontena.result["supernet"]}"
}

output "trusted_subnets" {
  value = "${split(",", data.external.kontena.result["trusted_subnets"])}"
}

output "external_registries" {
  value = "${split(",", data.external.kontena.result["external_registries"])}"
}

output "statsd_server" {
  value = "${data.external.kontena.result["statsd_server"]}"
}

output "stats" {
  value = {
    cpus       = "${data.external.kontena.result["stats_cpus"]}"
    users      = "${data.external.kontena.result["stats_users"]}"
    services   = "${data.external.kontena.result["stats_services"]}"
    containers = "${data.external.kontena.result["stats_containers"]}"

    mem = {
      used  = "${data.external.kontena.result["stats_mem_used"]}"
      total = "${data.external.kontena.result["stats_mem_total"]}"
    }

    filesystem = {
      used  = "${data.external.kontena.result["stats_fs_used"]}"
      total = "${data.external.kontena.result["stats_fs_total"]}"
    }

    load = "${split(",", data.external.kontena.result["stats_load"])}"
  }
}

output "logs" {
  value = {
    forwarder       = "${data.external.kontena.result["logs_forwarder"]}"
    fluentd-address = "${data.external.kontena.result["logs_fluentd_address"]}"
  }
}

output "nodes" {
  value = "${split(",", data.external.kontena.result["nodes"])}"
}

output "services" {
  value = "${split(",", data.external.kontena.result["services"])}"
}

output "stacks" {
  value = "${split(",", data.external.kontena.result["stacks"])}"
}

output "containers" {
  value = "${split(",", data.external.kontena.result["containers"])}"
}

output "volumes" {
  value = "${split(",", data.external.kontena.result["volumes"])}"
}
