require_relative 'lib/utils'

module Config
  IP_MASTER  = "52.212.144.80"
  IP_WORKER1 = "52.211.145.247"
  IP_WORKER2 = "34.254.99.189"
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
