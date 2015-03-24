
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
		end
	end
end

