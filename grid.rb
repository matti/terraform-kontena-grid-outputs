require 'json'
require 'yaml'

params = JSON.parse(STDIN.read)

kontena_cli_prefix = if params["name"]
  "KONTENA_MASTER=#{params["organization"]}/#{params["name"]}"
end

if params["name"]
  org_master="#{params["organization"]}/#{params["name"]}"

  masters = `kontena master ls -q`.split("\n")
  unless masters.include? org_master
    `kontena cloud platform use #{org_master}`
  end
end

output = if params["name"]
  `#{kontena_cli_prefix} kontena grid show #{params["name"]}`
else
  `kontena grid current`
end

grids = YAML.load(output)
grid_name = grids.keys[0]
grid = grids[grid_name]

token = `#{kontena_cli_prefix} kontena grid show --token #{grid_name}`

#NOTE: as of 1.3.4 -q does not exist
trusted_subnets = `#{kontena_cli_prefix} kontena grid trusted-subnet ls -q`.split("\n")
external_registries = `#{kontena_cli_prefix} kontena external-registry ls -q`.split("\n")
nodes = `#{kontena_cli_prefix} kontena node ls -q`.split("\n")
services = `#{kontena_cli_prefix} kontena service ls -q`.split("\n")
stacks = `#{kontena_cli_prefix} kontena stack ls -q`.split("\n")
containers = `#{kontena_cli_prefix} kontena container ls -q`.split("\n")
volumes = `#{kontena_cli_prefix} kontena volume ls -q`.split("\n")

stats_mem_used = grid["stats"]&.dig("memory")&.split(" of ")&.at(0)
stats_mem_total = grid["stats"]&.dig("memory")&.split(" of ")&.at(1)&.split(" GB")&.at(0)

stats_fs_used = grid["stats"]&.dig("filesystem")&.split(" of ")&.at(0)
stats_fs_total = grid["stats"]&.dig("filesystem")&.split(" of ")&.at(0)&.split(" GB")&.at(0)

result = {
  name: grid_name,
  token: token.strip,
  uri: grid["uri"],
  initial_size: grid["initial_size"].to_s,
  default_affinity: grid["default_affinity"]&.join(","),
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