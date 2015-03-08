module KN
  module SCM
    module Git

      def prepare_git_checkouts(options = {})
        raise ArgumentError, "need :user, :group, and :home" unless options.has_key?(:user) && options.has_key?(:group) && options.has_key?(:home)

        directory "#{options[:home]}/.ssh" do
          owner options[:user]
          group options[:group]
          mode "0700"
          action :create
          recursive true
        end

        file "#{options[:home]}/.ssh/config" do
          owner options[:user]
          group options[:group]
          action :touch
          mode '0744'
        end

        execute "echo 'StrictHostKeyChecking no' > #{options[:home]}/.ssh/config" do
          not_if "grep '^StrictHostKeyChecking no$' #{options[:home]}/.ssh/config"
        end

		# opsworks doesn't support new lines in json, however, vagrant does
		# thus, this jankyness
		ssh_key = options[:ssh_key]
		ssh_template = 'ssh_key.erb'
		if ssh_key.scan("\n").length > 3
			ssh_template = 'ssh_key_raw.erb'
		end
        template "#{options[:home]}/.ssh/id_dsa" do
          source ssh_template
		  cookbook 'go-chef'
          mode '0600'
          owner options[:user]
          group options[:group]
          variables({ :ssh_key => ssh_key })
        end

      end

    end
  end
end

class Chef::Recipe
  include KN::SCM::Git
end
