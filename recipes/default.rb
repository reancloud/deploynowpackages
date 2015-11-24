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
  
  directory node['deploynowpackages']['packages_home'] do
    mode '0755'
    action :create
  end

  package_download_file = "#{node['deploynowpackages']['packages_home']}#{package['zip_file_name']}"
  remote_file package_download_file do
    source package['download_url']
    mode '0755'
  end

  bash 'extract_package' do
    code <<-EOH
      cd #{node["deploynowpackages"]["packages_home"]}
      tar -zxf #{package['zip_file_name']}
      mv #{package['unzipped_name']} #{package['package_name']}
    EOH
  end

end
