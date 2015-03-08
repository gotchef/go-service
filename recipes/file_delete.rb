


file node[:onetime][:file_to_delete] do
  owner 'root'
  group 'root'
  mode '0755'
  action :delete
end
