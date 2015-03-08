
define :go_service_clean_old do
	releases_dir = params[:releases_dir]

	sorted_dirs = ::Dir["#{releases_dir}/*"].sort.reverse
	max_index = sorted_dirs.length - 1
	for i in 5..max_index
		current = sorted_dirs[i]
		directory "#{current}" do
			action :delete
			recursive true
		end
	end

end
