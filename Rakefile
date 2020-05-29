desc "Run"
task :run do
  puts "note: run `rake SETUP=1` to set up the k3s cluster on the 3 VMs (you need to run this only the first time)"

  # sh "bundle exec ruby file.rb"
  sh "ruby kuber.rb"
end

task default: :run
