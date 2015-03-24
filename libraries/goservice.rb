
class Chef
	module GoService
		class << self
		  def active_binary(node)
		    File.join(node['consul']['install_dir'], 'consul')
		  end
		
		  def cached_archive(node)
		    File.join(Chef::Config[:file_cache_path], File.basename(remote_url(node)))
		  end

		  def config_root(node)
			config_root = node[:service][:config_root]
			config_root = "/etc" unless !config_root.to_s.empty?
			return config_root
		  end
		end
	end
end

