require_relative 'env'

class Kuber

  def initialize
    puts "new k3s setup:"
  end

  def setup!
    # uninstall!

    first_run = ENV["FIRST_RUN"] == "1" || ENV["INSTALL"] == "1" || false
    if first_run
      prereqs!
      install!
      sleep 5
    end

    check_nodes

    check_pods

    namespace = "nginx"

    # TODO: remove - this is for demonstration purposes, it rebuilds the deployment from scratch every time - note: this command is a bit aggressive :D
    exe :master, "kubectl delete daemonsets,replicasets,services,deployments,pods --all"

    check_pods

    deploy

    check_pods

    sleep 2

    check_pods

    exe :master, "kubectl get deployments"

  end

  def deploy

    exe :master, "cp /etc/rancher/k3s/k3s.yaml /root/.kube/config"

    scp :master, :kube_pods # (pods.yml)

    exe :master, "kubectl  apply -f pods.yml"

    # TODO: resume development here

    # makevoid fork - support for compose files and kompose compiled and modified kubernetes pod/service/deployment yml files
    # applied blockchain fork - support for private repositories

    # deploy via compose - TODO: at the moment it seems that k3s need to be configured - I'm getting Unauthorized (probably cert?) - TODO: try kompose as well

    # scp :master, :compose_yaml
    #
    # exe :master, "docker stack deploy --orchestrator=kubernetes -c #{COMPOSE_YAML_FILE} #{STACK_NAME}", open3: true

  end

  # TODO: refactor into multiple different files

  # main actions and helpers

  def prereqs!
    AddSSHKnownHosts.()
    exe_all_user "mkdir -p /root/.ssh"
    exe_all_user "cp /home/#{USER}/.ssh/authorized_keys /root/.ssh/authorized_keys"
  end

  # main method, install_k3s!

  def install!
    puts "installing K3s"
    install_k3s
  end

  def install_k3s
    install_k3s_master
    install_k3s_workers
    install_docker
  end

  def install_k3s_master
    exe :master, "#{curl_k3s} | sh -", open3: true
  end

  def install_k3s_workers
    master_host = "https://#{IP_MASTER}:6443"
    token = exe :master, "cat /var/lib/rancher/k3s/server/node-token", open3: true
    k3s_install_env = "K3S_URL=#{master_host} K3S_TOKEN=#{token}"

    exe :worker1, "#{curl_k3s} | #{k3s_install_env} sh -"
    exe :worker2, "#{curl_k3s} | #{k3s_install_env} sh -"
  end

  def check_pods
    nodes = exe :master, "kubectl get pods", open3: true
  end

  def check_nodes
    nodes = exe :master, "kubectl get nodes", open3: true
  end

  def uninstall!
    exe_all_user "/usr/local/bin/k3s-uninstall.sh"
  end

  # post install - post install procedure (gets executed after K3S is installed)

  def post_install
    install_docker
    # ...
  end

  # install docker - #TODO: move in lib/docker.rb - module VMProvisioning::Docker::Install

  def install_docker
     # install docker to be able to connect to the master and deploy directly from there

    exe :master, "apt -y update"
    exe :master, "apt -y install apt-transport-https ca-certificates gnupg2 software-properties-common"
    exe :master, "curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -"
    exe :master, "add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/debian #{DEBIAN_RELEASE} stable'"
    exe :master, "apt -y update"
    exe :master, "apt -y install docker-ce docker-ce-cli containerd.io"
  end

  # utils - #TODO: move in lib/utils.rb - module Utils

  def exe(ip, cmd, open3: false)
    ip = select_ip ip
    open3 = open3 && :open3
    SSHUtils::SSHCmd.(ip, cmd, open3)
  end

  def scp(ip, file, open3: false)
    ip = select_ip ip
    open3 = open3 && :open3
    file = case file
    when :compose_yaml then COMPOSE_YAML_FILE
    when :readme_md    then "Readme.md"
    when :kube_stack   then "stack.yml" # kube pods/services file
    when :services     then "services.yml"
    when :kube_pods    then "pods.yml"
    else
      raise "File not found - please pass :compose as file"
    end
    SSHUtils::SCPCmd.(ip, file, open3)
  end

  def select_ip(ip)
    case ip
    when :master  then IP_MASTER
    when :worker1 then IP_WORKER1
    when :worker2 then IP_WORKER2
    else
      raise "IP not found, select either master or workerN (1, 2, ...)"
    end
  end

  private

  def curl_k3s
    "curl -sfL https://get.k3s.io"
  end

end


if __FILE__ == $0
  kuber = Kuber.new
  kuber.setup!
end
