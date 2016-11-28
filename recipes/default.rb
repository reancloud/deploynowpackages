#
# Cookbook Name:: deploynowpackages
# Recipe:: default
#
# Copyright 2015, Opex Software
#
# All rights reserved - Do Not Redistribute
#

# Download and untar/unzip the specified package in the /tmp/deploynow/cookbooks dir
node["deploynowpackages"]["packages"].each do |package|

  unless package.is_a? Hash
    raise "DeployNow : Package [#{package}] is required to be a hash"
  end

  if not package.has_key? "download_url"
    raise "DeployNow : Package [#{package}] has no 'download_url'"
  end

  if not package.has_key? "zip_file_name"
    raise "DeployNow : Package [#{package}] has no 'zip_file_name'"
  end

 
  if not package.has_key? "unzipped_name"
    raise "DeployNow : Package [#{package}] has no 'unzipped_name'"
  end

  if not package.has_key? "package_name"
    raise "DeployNow : Package [#{package}] has no 'package_name'"
  end
 
	actual_download_url = ""
	if platform?('windows')
		directory node['deploynowpackages']['packages_home_win'] do
			mode '0755'
			action :create
		end
		package_download_file = "#{node['deploynowpackages']['packages_home_win']}#{package['zip_file_name']}"
		actual_download_url = package['download_url']
	else
		directory node['deploynowpackages']['packages_home_linux'] do
			mode '0755'
			action :create
		end
		package_download_file = "#{node['deploynowpackages']['packages_home_linux']}#{package['zip_file_name']}"
		actual_download_url = package['download_url']
	end

	if actual_download_url.include? "github.com" and package['private_access_token'] != ""
		remote_file package_download_file do
			source actual_download_url+"?access_token=#{package['private_access_token']}"
			headers("Accept" => "application/octet-stream")
			mode '0755'
		end
	else
		remote_file package_download_file do
			source actual_download_url
			headers("PRIVATE-TOKEN" =>"#{package['private_access_token']}")
			mode '0755'
		end
	end

	if platform?('windows')
		powershell_script 'unzip package' do
  		code <<-EOH
	 			cd #{node["deploynowpackages"]["packages_home_win"]}
				tar -zxf #{package['zip_file_name']}
				mv #{package['unzipped_name']} #{package['package_name']}
	  		EOH
		end	

		
	else
		bash 'extract_package' do
			code <<-EOH
				cd #{node["deploynowpackages"]["packages_home_linux"]}
				tar -zxf #{package['zip_file_name']}
				mv #{package['unzipped_name']} #{package['package_name']}
			EOH
		end
	end
end
