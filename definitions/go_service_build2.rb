# this is not finished, consider deleting if not completed

#	define :go_service_build2, :deploy_key => "", :service => {}, :build => {}  do
#		service = params[:service]
#		build = params[:build]
#		deploy_key = params[:deploy_key]
#		install_root = params[:install_root]
#			
#		install_root =  '/opt' unless install_root.to_s.empty?
#		deploy_root = "#{install_root}/#{service[:name]}"
#	
#		ssh_home = "/tmp/private_code"
#	
#		prepare_git_checkouts(
#	      :user => service[:user],
#	      :group => service[:group],
#	      :home => ssh_home,
#	      :ssh_key => deploy_key
#	    )
#	
#		timestamp = Time.now.strftime("%Y-%m-%dT%H%M-%S")
#		temp_dir = "/tmp/deploy/#{service[:name]}/#{timestamp}" 
#		#mk temp dir
#		directory temp_dir do
#			owner service[:user]
#			group service[:group]
#			mode '770'
#			recursive true
#			action :create
#		end
#	
#		repo = build[:repository]
#		go_repository = build[:go_repository]
#		if go_repository.to_s.empty? 
#			# get the part that looks like this github.com/project/repo
#			#private syntax git@github.com:root/repot.git
#			if match = repo.gsub(/[-a-zA-Z0-9]+@([a-zA-Z0-9-]+[.][a-zA-Z]+):([-a-zA-Z0-9\/]+)/, '\1/\2')
#				go_repository = match
#			# public syntax https://github.com/root/repot
#			elsif match = repo.gsub(/https:\/\/([-a-zA-Z0-9]+[.][a-zA-Z]+\/[-a-zA-Z0-9\/]+)/, '\1')
#				go_repository = match
#			end
#		end
#		# if .git is on path, remove it
#		ext = File.extname(go_repository)
#		if ext.length > 0 
#			go_repository = go_repository.slice 0..(-1 * (ext.length + 1))
#		end
#	
#		revision = build[:revision]
#		
#		deploy deploy_root do
#			repo repo
#			revision revision# "abc123" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
#			enable_submodules true
#			shallow_clone true
#			keep_releases 5
#			action :deploy # or :rollback
#			git_ssh_wrapper "wrap-ssh4git.sh"
#			scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
#			
#			migrate true
#			# Callback awesomeness:
#			before_migrate do
#				current_release = release_path
#				new_dest = ::File.join(current_release, 'src', go_repository )
#	
#				# go requires a special dir structure
#				FileUtils.rm_rf(temp_dir) if ::File.exist?(temp_dir)
#				FileUtils.mkdir_p(temp_dir)
#				FileUtils.cp_r(::File.join(current_release, "."), temp_dir, :preserve => true)
#	
#				FileUtils.rm_rf(::File.join(current_release, "."))
#				FileUtils.mkdir_p(new_dest)
#				#
#				#go base dirs
#				['src','bin','pkg'].each do |dir|
#					directory "#{current_release}/#{dir}" do
#						group service[:group]
#						owner service[:user]
#						mode "0775"
#						recursive true
#						action :create
#					end
#				end
#	
#				FileUtils.cp_r(::File.join(temp_dir, "."), new_dest, :preserve => true)
#				Chef::Log.info "#{current_release} moved to #{new_dest}"
#				#now 
#			end
#			user service[:user]
#			migration_command 'echo "migrated"'
#			#environment "RAILS_ENV" => "production", "OTHER_ENV" => "foo"
#			#restart_command "touch tmp/restart.txt"
#		end
#	
#	end
