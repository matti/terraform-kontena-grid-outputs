# terraform-kontena-grid-outputs

Provides outputs for a grid (lightweight data source).

Selects grid with environment variables https://kontena.io/docs/references/environment-variables.html
Requires Ruby and `kontena` CLI.

See [test](test) folder for usage example.

Option 1: use current master and grid

    $ cd test
    $ terraform apply
      data.external.kontena: Refreshing state...

      Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

      Outputs:

      grid = {
        containers = [empty-sky-951/nsenter.nsenter-1 empty-sky-951/redis-1 empty-sky-951/weave empty-sky-951/kontena-etcd empty-sky-951/kontena-ipam-plugin empty-sky-951/kontena-agent empty-sky-951/kontena-cadvisor]
        default_affinity = [node!=aosdkfoasdkfoadsokf]
        external_registries = [us.gcr.io eu.gcr.io jp.gcr.io]
        initial_size = 1
        logs = map[fluentd-address:logs.example.com forwarder:fluentd]
        name = mygrid
        nodes = [empty-sky-951]
        services = [mygrid/nsenter/nsenter mygrid/null/redis]
        stacks = [nsenter]
        stats = map[containers:9 mem:map[used:0.34 total:0.96] filesystem:map[total:0.54 used:0.54] load:[0.2 0.0 0.0] cpus:1 users:2 services:2]
        statsd_server = example.com:8125
        subnet = 10.81.0.0/16
        supernet = 10.80.0.0/12
        token = YAXvsMeR5XXbf6HvC9bS7LjcFq1qegmQnDo8Idz9x03n5pEWQhAISV07jeRhIW2q7BDAcphzPnXj+C9q35ozlw==
        trusted_subnets = [123.123.123.123/0 123.123.123.121/0]
        uri = wss://withered-violet-6345.platforms.eu-west-1.kontena.cloud
        volumes = [wat]
      }

Option 2: use tokens

    $ cd test
    $ KONTENA_URL=https://withered-violet-6345.platforms.eu-west-1.kontena.cloud KONTENA_GRID=mygrid KONTENA_TOKEN=883c0072bb4e514caf2c2214897df00a004928b934ebd7a44152ffc78101e3d2 terraform apply
      data.external.kontena: Refreshing state...

      Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

      Outputs:

      grid = {
        default_affinity = ...
      ...

Option 3: use kontena config file masters

    $ cd test
    $ KONTENA_MASTER=myorg/mygrid KONTENA_GRID=mygrid

Option 4: define master & grid as inputs

    module "grid-outputs" {
      source  = "matti/grid-outputs/kontena"

      organization = "${var.organization}"
      name         = "${var.name}"
    }
