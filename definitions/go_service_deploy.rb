
define :go_service_deploy, :service => nil, :build => nil, :key => "", :install_root => '/opt', :config_root => '/etc' do
	service = params[:service]
	build = params[:build]
	key		= params[:key]
	install_root = params[:install_root]
	config_root = params[:config_root]

	service_name = service[:name]

	user = service[:user]
	user = service_name unless !user.to_s.empty?

	group = service[:group]
	group = user unless !group.to_s.empty?
	
	home = service[:home]
	home = "/home/#{user}" unless !home.to_s.empty?

	config_root = Chef::GoService.config_root(service)

	shell = service[:shell]

	go_service_user do
		user  user
		group group
		shell shell
		home  home
	end

	go_service_directories do
		user			user
		group			group
		install_root	install_root
		service_name	service_name
		config_root		config_root
	end

	go_service_build do
		service		service
		build		build
		deploy_key	key
		install_root install_root
	end
end

