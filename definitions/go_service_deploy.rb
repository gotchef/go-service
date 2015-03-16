
define :go_service_deploy, :service => nil, :build => nil, :key => "" do
	service = params[:service]
	build = params[:build]
	key		= params[:key]

	service_name = service[:name]

	user = service[:user]
	user = service_name unless !user.to_s.empty?

	group = service[:group]
	group = user unless !group.to_s.empty?
	
	install_root = service[:install_root]
	install_root	= '/opt' unless !install_root.to_s.empty?

	home = service[:home]
	home = "/home/#{user}" unless !home.to_s.empty?

	config_root = service[:config_root]
	config_root = "/etc" unless !config_root.to_s.empty?

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
	end
end

