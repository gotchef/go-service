
define :go_service_service, :service_name => '', :run_file => '', :run_args => '', :options => {}, :user => '', :group => '', :install_root => '/opt', :log_root => '/var/log', :timeout => 60 do
	include_recipe 'runit'
	
	options = params[:options]
	install_root = params[:install_root]
	run_args = params[:run_args]
	log_root = params[:log_root]
	timeout = params[:timeout]
	service_name = params[:service_name]
	user = params[:user]
	group = params[:group]

	user = service_name unless !user.to_s.empty?
	group = user unless !group.to_s.empty?

	run_file = params[:run_file]
	run_file = service_name unless !run_file.to_s.empty?

	executable_path="#{install_root}/#{service_name}/current/bin/#{run_file} #{run_args}" # all json in folder
	
	log_dir = "#{log_root}/#{service_name}"
	directory log_dir do
		group group
		owner user
		mode "0775"
		action :create
		recursive true
	end
	
	service_options = {
		:exec => executable_path,
		:user => user,
		:log_dir => log_dir
	}.merge(options)

	runit_service service_name do
		default_logger true
		sv_timeout timeout
	
		options(service_options)
		action [:enable, :start]
	end
end
