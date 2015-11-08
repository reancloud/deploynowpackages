#
# Cookbook Name:: getcookbooks
# Recipe:: default
#
# Copyright 2015, Opex Software
#
# All rights reserved - Do Not Redistribute
#

# Download and untar/unzip the specified cookbook in the /tmp/deploynow/cookbooks dir
node["getcookbooks"]["cookbooks"].each do |cookbook|

  unless cookbook.is_a? Hash
    raise "DeployNow : Cookbook [#{cookbook}] is required to be a hash"
  end

  if not cookbook.has_key? "download_url"
    raise "DeployNow : Cookbook [#{cookbook}] has no 'download_url'"
  end

  if not cookbook.has_key? "zip_file_name"
    raise "DeployNow : Cookbook [#{cookbook}] has no 'zip_file_name'"
  end

  if not cookbook.has_key? "unzipped_cookbook_name"
    raise "DeployNow : Cookbook [#{cookbook}] has no 'unzipped_cookbook_name'"
  end

  if not cookbook.has_key? "actual_cookbook_name"
    raise "DeployNow : Cookbook [#{cookbook}] has no 'actual_cookbook_name'"
  end
  
  directory node['getcookbooks']['cookbooks_home'] do
    mode '0755'
    action :create
  end

  cookbook_download_file = "#{node['getcookbooks']['cookbooks_home']}#{cookbook['zip_file_name']}"
  remote_file cookbook_download_file do
    source cookbook['download_url']
    mode '0755'
  end

  bash 'extract_cookbook' do
    code <<-EOH
      cd #{node["getcookbooks"]["cookbooks_home"]}
      tar -zxf #{cookbook['zip_file_name']}
      mv #{cookbook['unzipped_cookbook_name']} #{cookbook['actual_cookbook_name']}
    EOH
  end

end
