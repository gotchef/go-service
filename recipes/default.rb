##AWS OpsWorks, at the time of the creation of this file, doesn't support chef environments
if node[:chef_environment] != nil
  node.chef_environment = node[:chef_environment]
end
