namespace :chef do
  task :write_json, :serial => true do
    role = @current_servers.first.role
    conf = get(:chef_config).merge(:role => role, :run_list => "role[#{role}]").to_json
    run "mkdir -p #{get(:release_path)}/config"
    chef_config =<<-_END_
    cookbook_path    ["/var/chef/cookbooks",
                      "#{get(:release_path)}/cookbooks"]
    log_level         :info
    file_cache_path  "/var/chef"
    role_path        "#{get(:release_path)}/roles"
    Chef::Log::Formatter.show_time = false
_END_
    put chef_config, get(:release_path) + "/config/chef-solo.rb"
    put conf, get(:release_path) + "/config/chef.json"
  end

  task :run do
    run "chef-solo --config #{get(:release_path)}/config/chef-solo.rb -j #{get(:release_path)}/config/chef.json"
  end
end
