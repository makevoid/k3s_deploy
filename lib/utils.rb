require 'open3'

module SSHUtils

  def ssh_exe(cmd)
    ssh_exe "ssh -t root@#{IP_CURR} \"#{cmd}\""
  end

  def ssh_exe_user(cmd, user: USER)
    ssh_exe "ssh -t #{user}@#{IP_CURR} 'sudo -u root #{cmd}'"
  end

  def exe_all(cmd)
    threads = []
    IPS.each do |swarm_node_ip|
      threads << Thread.new do
        ssh_exe "ssh root@#{swarm_node_ip} \"#{cmd}\""
      end
    end
    threads.map &:join
  end

  def exe_all_user(cmd, user: USER)
    threads = []
    IPS.each do |swarm_node_ip|
      threads << Thread.new do
        ssh_exe "ssh #{user}@#{swarm_node_ip} 'sudo su -c \"#{cmd}\"'"
      end
    end
    threads.map &:join
  end

  SSHCmd = -> (ip, cmd, open3) {
    open3 = !!(open3 == :open3)
    ssh_exe "ssh  root@#{ip} \"#{cmd}\"", open3: open3
  }

  AddSSHKnownHost = -> (ip) {
    known_hosts = File.expand_path "~/.ssh/known_hosts"

    ip_present = system "ssh-keygen -F #{ip}";
    unless ip_present
      puts system "ssh-keyscan -H #{ip} >> #{known_hosts}"
      puts "IP added to known hosts\n"
    else
      puts "IP already present"
    end
  }

  AddSSHKnownHosts = -> {
    puts "Adding IPs to known hosts"
    AddSSHKnownHost.(IP_MASTER)
    AddSSHKnownHost.(IP_WORKER1)
    AddSSHKnownHost.(IP_WORKER2)
    puts "\n\n"
  }

end

module Utils

  include SSHUtils

  def ssh_exe(cmd, dir: nil, open3: false)
    cd_cmd = "cd #{dir} && " if dir
    cmd = "#{cd_cmd}#{cmd}"
    puts "executing: #{cmd}"
    unless open3
      out = system cmd
    else
      out, err, st = Open3.capture3 cmd
      out.strip!
    end
    puts out
    puts "#{err}\n"
    out
  end

end
