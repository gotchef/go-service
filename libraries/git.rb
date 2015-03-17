module GotChef
	module Git
	def prepare_git_checkouts(options = {})
			
        raise ArgumentError, "need :user, :group, and :home" unless options.has_key?(:user) && options.has_key?(:group) && options.has_key?(:home)
		
		ssh_home = options[:home]
		ssh_key = options[:ssh_key]
		user = options[:user]
		group = options[:group]

		directory "#{ssh_home}/.ssh" do
		  owner user
		  group group
		  mode '0700'
		  action :create
		  recursive true
		end
		
		file "#{ssh_home}/.ssh/config" do
		  owner		user
		  group		group
		  action	:touch
		  mode		'0744'
		end
		
		execute "echo 'StrictHostKeyChecking no' > #{ssh_home}/.ssh/config" do
		  not_if "grep '^StrictHostKeyChecking no$' #{ssh_home}/.ssh/config"
		end

		cookbook_file "#{ssh_home}/wrap-ssh4git.sh" do
			source 'wrap-ssh4git.sh'
			owner	user
			group	group
			mode	'0700'
		end


		if !ssh_key.to_s.empty?
			# opsworks doesn't support new lines in json, however, vagrant does
			# thus, this jankyness
			ssh_template = 'ssh_key.erb'

			if ssh_key.scan("\n").length > 3
				ssh_template = 'ssh_key_raw.erb'
			end

			template "#{ssh_home}/.ssh/id_dsa" do
			  source ssh_template
			  cookbook 'go-service'
			  mode '0600'
			  owner user
			  group group
			  variables({ :ssh_key => ssh_key })
			end
		end
	end
	end
end

class Chef::Recipe
  include GotChef::Git
end
