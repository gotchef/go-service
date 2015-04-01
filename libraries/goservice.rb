
class Chef
	module GoService
		class << self
			def cached_archive(node)
				File.join(Chef::Config[:file_cache_path], File.basename(remote_url(node)))
			end

			def install_root(service)
				install_root = service[:install_root]
				install_root = "/opt" unless !install_root.to_s.empty?
				return install_root
			end

			def install_dir(service)
				install_root = install_root(service)
				return "#{install_root}/#{service[:name]}"
			end

			def config_root(service)
				config_root = service[:config_root]
				config_root = "/etc" unless !config_root.to_s.empty?
				return config_root
			end

			def config_dir(service)
				config_root = config_root(service)
				return "#{config_root}/#{service[:name]}"
			end

			def log_root(service)
				log_root = service[:log_root]
				log_root = "/var/log" unless !log_root.to_s.empty?
				return log_root
			end
			
			def log_dir(service)
				log_root = log_root(service)
				return "#{log_root}/#{service[:name]}"
			end

			def user(service)
				user = service[:user]
				user = service[:name] unless !user.to_s.empty?
				return user
			end

			def group(service)
				group = service[:group]
				group = user(service) unless !group.to_s.empty?
				return group
			end

		end
	end
end

