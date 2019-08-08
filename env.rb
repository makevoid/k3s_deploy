require_relative 'lib/utils'


module Config
  IP_MASTER  = "34.254.183.66"
  IP_WORKER1 = "54.194.143.89"
  IP_WORKER2 = "63.32.168.145"
  IPS = [
    IP_MASTER,
    IP_WORKER1,
    IP_WORKER2,
  ]

  USER = "admin" # debian
end

include Config
include Utils
