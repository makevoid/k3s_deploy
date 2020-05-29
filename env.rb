require_relative 'lib/utils'

module Config
  IP_MASTER  = "54.229.32.200"
  IP_WORKER1 = "34.245.172.16"
  IP_WORKER2 = "34.253.153.93"
  IPS = [
    IP_MASTER,
    IP_WORKER1,
    IP_WORKER2,
  ]

  STACK_NAME = "default" # default stack name
  COMPOSE_YAML_FILE = "docker-compose.yml" # default
  USER = "admin" # debian
  DEBIAN_RELEASE = "stretch" # (docker) debian release
end

include Config
include Utils
