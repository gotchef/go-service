define :go_service_user, :user => '', :group => '', :shell => '', :home => '' do
	user = params[:user]
	group = params[:group]
	shell = params[:shell]
	home = params[:home]

	home = "/home/#{user}" unless !home.to_s.empty?
	shell = "/bin/bash" unless !shell.to_s.empty?

	group group do
		not_if { group == 'root' }
	end

	user user do
		not_if { user == 'root' }
		comment		"created by chef user"
		gid			group
		home		home
		supports	:manage_home => true
		system		true
		shell		shell
	end
end
