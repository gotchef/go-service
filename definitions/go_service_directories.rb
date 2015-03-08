define :go_service_directories, :user => '', :group => '', :config_root => '', :service_name => '', :deploy_root => '' do
	user = params[:user]
	group = params[:group]
	config_root = params[:config_root]
	service_name = params[:service_name]

	service_dir = "#{params[:deploy_root]}/#{service_name}"

	directory "#{service_dir}" do
		group group
		owner user
		mode 0774
		action :create
		recursive true
	end

	directory "#{service_dir}/shared" do
		group group
		owner user
		mode 0774
		action :create
		recursive true
	end

  # create shared/ directory structure
	['log','config','system','pids','scripts','sockets'].each do |current|
		directory "#{service_dir}/shared/#{current}" do
			group	group
			owner	user
			mode	0774
			action	:create
			recursive true
		end
	end

	# ln -s /etc/{servicename}
	link "#{config_root}/#{service_name}" do
		to "#{service_dir}/shared/config/"
	end

end
