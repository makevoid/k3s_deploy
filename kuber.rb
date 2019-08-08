require_relative 'env'

class Kuber

  def initialize
    # ...
  end

  def setup!
    # uninstall!

    first_run = ENV["FIRST_RUN"] == "1" || false
    if first_run
      prereqs!
      install!
      sleep 5
    end

    check

    deploy

  end

  def deploy
    exe :master, "#{curl_k3s} | sh -", open3: true
    
  end

  # main actions and helpers

  def prereqs!
    AddSSHKnownHosts.()
    exe_all_user "mkdir -p /root/.ssh"
    exe_all_user "cp /home/#{USER}/.ssh/authorized_keys /root/.ssh/authorized_keys"
  end

  def install!
    exe :master, "#{curl_k3s} | sh -", open3: true
    # exe_all_user "#{curl_k3s} | sh -"

    token = exe :master, "cat /var/lib/rancher/k3s/server/node-token", open3: true

    master_host = "https://#{IP_MASTER}:6443"
    k3s_install_env = "K3S_TOKEN=#{token} K3S_URL=#{master_host}"

    exe :worker1, "#{curl_k3s} | #{k3s_install_env} sh -"
    exe :worker2, "#{curl_k3s} | #{k3s_install_env} sh -"

    # agent_cmd = "k3s agent --server #{master_host} --token #{token}"
    #
    # # exe :worker1, "service k3s stop", open3: true
    # # exe :worker2, "service k3s stop", open3: true
    # exe :worker1, agent_cmd
    # exe :worker2, agent_cmd
  end

  def check
    nodes = exe :master, "kubectl get nodes", open3: true
    puts nodes
  end

  def uninstall!
    exe_all_user "/usr/local/bin/k3s-uninstall.sh"
  end

  # utils

  def exe(ip, cmd, open3: false)
    ip = select_ip ip
    open3 = open3 && :open3
    SSHUtils::SSHCmd.(ip, cmd, open3)
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
