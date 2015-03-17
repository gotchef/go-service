define :go_service_build, :deploy_key => "", :service => {}, :build => {}  do
	service = params[:service]
	build = params[:build]
	deploy_key = params[:deploy_key]
	install_root = params[:install_root]
		
	install_root =  '/opt' unless !install_root.to_s.empty?

	new_release_dir = Time.now.strftime("%Y-%m-%dT%H%M-%S")

	releases_dir = "#{install_root}/#{service[:name]}/releases"
	go_path = "#{releases_dir}/#{new_release_dir}"

	repo = build[:repository]
	go_repository = build[:go_repository]
	if go_repository.to_s.empty? 
		# get the part that looks like this github.com/project/repo
		#private syntax git@github.com:root/repot.git
		if match = repo.gsub(/[-a-zA-Z0-9]+@([a-zA-Z0-9-]+[.][a-zA-Z]+):([-a-zA-Z0-9\/]+)/, '\1/\2')
			go_repository = match
		# public syntax https://github.com/root/repot
		elsif match = repo.gsub(/https:\/\/([-a-zA-Z0-9]+[.][a-zA-Z]+\/[-a-zA-Z0-9\/]+)/, '\1')
			go_repository = match
		end
	end

	# if .git is on path, remove it
	ext = File.extname(go_repository)
	if ext.length > 0 
		go_repository = go_repository.slice 0..(-1 * (ext.length + 1))
	end

	revision = build[:revision]

	#create go root
	directory "#{go_path}" do
		group service[:group]
		owner service[:user]
		mode "0775"
		action :create
		recursive true
	end

	#go base dirs
	['src','bin','pkg'].each do |current|
		directory "#{go_path}/#{current}" do
			group service[:group]
			owner service[:user]
			mode "0775"
			action :create
			recursive true
		end
	end

	ensure_scm_package_installed('git')

	home = "/home/#{service[:user]}"
	execute 'git config --global url."git@github.com:".insteadOf "https://github.com/"' do
		not_if { deploy_key.to_s.empty? }

		user service[:user]
		group service[:group]
		environment( { "HOME" => home })
	end

    prepare_git_checkouts(
      :user => service[:user],
      :group => service[:group],
      :home => home,
      :ssh_key => deploy_key
    ) 

	parts = go_repository.split("/")
	prev = "#{go_path}/src" 
	#we have to do this retarded thing because the owner and group only apply to 
	#leaf nodes on creating a recursive structure
	parts.each do |dir_name| 
		current = "#{prev}/#{dir_name}" 
		directory current do
			group service[:group]
			owner service[:user]
			mode "0775"
			action :create
			recursive false
		end
		prev = current
	end
	checkout_to =  "#{go_path}/src/#{go_repository}"

	#go source
	directory "#{checkout_to}" do
		group service[:group]
		owner service[:user]
		mode "0775"
		action :create
		recursive true
	end
	
	git "#{checkout_to}"  do
		repository "#{build[:repository]}"	
		revision revision
		action :sync
		#envirnoment not supported by opsworks
		#environment "HOME" => deploy[:home] 
		user service[:user]
		group service[:group]
	end

	main_dir = checkout_to

	if !build[:go_main_dir].to_s.empty?
		main_dir = "#{checkout_to}/#{build[:go_main_dir]}"
	end

	execute '/usr/local/go/bin/go get' do 
		cwd main_dir
		environment ({
			'GOROOT' => '/usr/local/go',
			'GOPATH' => "#{go_path}",
			'GOBIN' => "#{go_path}/bin",
			'HOME' => home
		})
		user  service[:user]
		group service[:group]
		ignore_failure true
	end

	build_cmd = build[:command].to_s.downcase
	if build_cmd == 'make' and ::File.exists?("#{main_dir}/Makefile")
		execute 'make install' do 
			cwd main_dir
			environment ({
				'GOROOT' => '/usr/local/go',
				'GOPATH' => "#{go_path}",
				'GOBIN' => "#{go_path}/bin",
				'HOME' => home
			})
			user service[:user]
			group service[:group]
		end
	else
		execute '/usr/local/go/bin/go install -race' do 
			cwd main_dir
			environment ({
				'GOROOT' => '/usr/local/go',
				'GOPATH' => "#{go_path}",
				'GOBIN' => "#{go_path}/bin",
				'HOME' => home
			})
			user service[:user]
			group service[:group]
		end
	end

	#be good to also run ginkgo tests
	#coverage also
	
	link "#{install_root}/current" do
		to "#{go_path}/"
		owner service[:user]
		group service[:group]
	end

	go_service_clean_old do
		releases_dir releases_dir
	end

end
