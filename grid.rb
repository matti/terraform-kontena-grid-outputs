require 'json'
require 'yaml'

output = `kontena grid current`
grids = YAML.load(output)
grid_name = grids.keys[0]
grid = grids[grid_name]

token = `kontena grid show --token #{grid_name}`

trusted_subnet_output = `kontena grid trusted-subnet ls`
trusted_subnets = trusted_subnet_output.split("\n")

external_registries_output = `kontena external-registry ls -q`
external_registries = external_registries_output.split("\n")

node_ls_output = `kontena node ls -q`
nodes = node_ls_output.split("\n")

service_ls_output = `kontena service ls -q`
services = service_ls_output.split("\n")

stack_ls_output = `kontena stack ls -q`
stacks = stack_ls_output.split("\n")

container_ls_output = `kontena container ls -q`
containers = container_ls_output.split("\n")

volume_ls_output = `kontena volume ls -q`
volumes = volume_ls_output.split("\n")

stats_mem_used = grid["stats"]["memory"].split(" of ")&.at(0)
stats_mem_total = grid["stats"]["memory"].split(" of ")&.at(1)&.split(" GB")&.at(0)

stats_fs_used = grid["stats"]["filesystem"].split(" of ")&.at(0)
stats_fs_total = grid["stats"]["filesystem"].split(" of ")&.at(0)&.split(" GB")&.at(0)

result = {
  name: grid_name,
  token: token.strip,
  uri: grid["uri"],
  initial_size: grid["initial_size"].to_s,
  default_affinity: grid["default_affinity"].join(","),
  subnet: grid["subnet"],
  supernet: grid["supernet"],
  trusted_subnets: trusted_subnets.join(","),
  external_registries: external_registries.join(","),
  stats_cpus: grid["stats"]["cpus"].to_s,
  stats_users: grid["stats"]["users"].to_s,
  stats_services: grid["stats"]["services"].to_s,
  stats_containers: grid["stats"]["containers"].to_s,
  stats_mem_used: stats_mem_used,
  stats_mem_total: stats_mem_total,
  stats_fs_used: stats_fs_used,
  stats_fs_total: stats_fs_total,
  stats_load: grid["stats"]["load"].split(" ").join(","),
  statsd_server: grid.dig("exports", "statsd"),
  logs_forwarder: "",
  logs_fluentd_address: "",
  nodes: nodes.join(","),
  services: services.join(","),
  stacks: stacks.join(","),
  containers: containers.join(","),
  volumes: volumes.join(",")
}

if grids["logs"]
  result["logs_forwarder"] = grids.dig("logs", "forwarder")
  result["logs_fluentd_address"] = grids.dig("logs", "fluentd-address")
end

puts result.to_json