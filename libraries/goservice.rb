
class Chef
	module GoService
		class << self
			def cached_archive(node)
				File.join(Chef::Config[:file_cache_path], File.basename(remote_url(node)))
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
				log_root = "/var" unless !log_root.to_s.empty?
				return log_root
			end
			
			def log_dir(service)
				log_root = log_root(service)
				return "#{log_root}/#{service[:name]}"
			end

		end
	end
end

