
define :go_service_deploy, :service => nil, :build => nil, :deploy_key => ''  do
	service = params[:service]
	build = params[:build]
	deploy_key	= params[:deploy_key]

	user = Chef::GoService.user(service) 
	group = Chef::GoService.group(service)
	
	home = service[:home]
	home = "/home/#{user}" unless !home.to_s.empty?

	config_dir = Chef::GoService.config_dir(service)
	install_dir = Chef::GoService.install_dir(service)

	shell = service[:shell]

	go_service_user do
		user  user
		group group
		shell shell
		home  home
	end

	go_service_directories do
		user		user
		group		group
		config_dir	config_dir
		install_dir	install_dir
	end

	go_service_build do
		service		service
		build		build
		deploy_key	deploy_key
		install_dir install_dir
	end
end

