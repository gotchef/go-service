
define :go_service_service, :service => {}, :options => {}  do
	include_recipe 'runit'
	
	service = params[:service]
	options = params[:options]

	service_name = service[:name]
	run_file = service[:run_file]

	run_file = service_name unless !run_file.to_s.empty?

	config_dir = "#{service[:config_root]}/#{service_name}"
	executable_path="#{service[:install_root]}/#{service_name}/current/bin/#{run_file} -config #{config_dir}" # all json in folder
	
	log_dir = "#{service[:log_root]}/#{service_name}"
	directory log_dir do
		group service[:group]
		owner service[:user]
		mode "0775"
		action :create
		recursive true
	end
	
	service_options = {
		:exec => executable_path,
		:user => service[:user],
		:log_dir => log_dir
	}.merge(options)

	runit_service service_name do
		default_logger true
		sv_timeout service[:timeout]
	
		options(service_options)
		action [:enable, :start]
	end
end
