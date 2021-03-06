require_relative 'lib/utils'

module Config
  IP_MASTER  = "52.212.100.8"
  IP_WORKER1 = "3.250.186.128"
  IP_WORKER2 = "52.214.42.223"
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
