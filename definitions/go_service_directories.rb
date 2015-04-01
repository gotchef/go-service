define :go_service_directories, :user => '', :group => '', :config_dir => '', :install_dir => '' do
	user = params[:user]
	group = params[:group]
	config_dir = params[:config_dir]
	service_dir = params[:install_dir]

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
	link config_dir do
		to "#{service_dir}/shared/config/"
	end

end
