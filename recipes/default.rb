#
# Cookbook Name:: deploynowpackages
# Recipe:: default
#
# Copyright 2017, REAN CLOUD
#
# All rights reserved - Do Not Redistribute
#

# the instalation of git was regularly failing without first updating local cache
case node['platform_family']
when 'debian'
  command = 'apt-get update'
when 'rhel' # rhel, centos, amazon linux
  command = 'yum clean all'
when 'amazon'
  command = 'yum clean all'
end

unless node['platform'] == 'windows'
  execute 'clean repo cache' do
    command command
  end
end

# Download and untar/unzip the specified package in the /tmp/deploynow/cookbooks dir
node['deploynowpackages']['packages'].each do |package|
  raise "REAN Deploy : Package [#{package}] is required to be a hash" unless package.is_a? Hash
  raise "REAN Deploy : Package [#{package}] has no 'download_url'" unless package.key? 'download_url'
  raise "REAN Deploy : Package [#{package}] has no 'zip_file_name'" unless package.key? 'zip_file_name'
  raise "REAN Deploy : Package [#{package}] has no 'unzipped_name'" unless package.key? 'unzipped_name'
  raise "REAN Deploy : Package [#{package}] has no 'package_name'" unless package.key? 'package_name'
  raise "REAN Deploy : Package [#{package}] has no 'repo_type'" unless package.key? 'repo_type'
  raise "REAN Deploy : Package [#{package}] has no 'skip_install'" unless package.key? 'skip_install'
  directory node['deploynowpackages']['packages_home'] do
    mode '0755'
    action :create
  end

  if package['skip_install'] != 'true'
   package 'git' do
    action :install
   end
  end
  
  package_download_file = "#{node['deploynowpackages']['packages_home']}#{package['zip_file_name']}"
  actual_download_url = package['download_url']
  repo_type = package['repo_type']
  header_params = {}

  # I have not seen a blueprint that sets private_access_token to 'null' but I am going to leave this just in case.
  # I am going to add to it to check for a value of null
  if package['private_access_token'] != 'null' && !package['private_access_token'].nil?
    case repo_type
    	when 'github'
      # The only way I have found to download release tarballs is to use the api.github.com endpoint.
      # will need to be in this form: https://api.github.com/repos/:owner/:repo/tarball/:tag
      # :owner - this is the owner of the repo.  This will likely always be reancloud
      # :repo - name of the github repo
      # :tag - tag of :repo that you wanted downloaded
      header_params['Authorization'] = "token #{package['private_access_token']}"
      rewrite_url = actual_download_url
    when 'gitlab'
      header_params['PRIVATE-TOKEN'] = package['private_access_token']
      rewrite_url = actual_download_url
    when 'plain'
      header_params['Authorization'] = package['private_access_token']
      rewrite_url = actual_download_url
    when 'artifactory'
       header_params['X-JFrog-Art-Api'] = package['private_access_token']
       rewrite_url = actual_download_url
    else
      rewrite_url = actual_download_url
    end
  else
    rewrite_url = actual_download_url
  end

  remote_file package_download_file do
    source rewrite_url
    headers header_params
    mode '0755'
  end

  mv_cmd = ''

  if (package['unzipped_name']).to_s != (package['package_name']).to_s
    mv_cmd = "mv #{package['unzipped_name']} #{package['package_name']}"
  end

  if node['platform'] == 'windows'
    powershell_script 'unzip package' do
      code <<-EOH
        cd #{node['deploynowpackages']['packages_home']}
        mkdir #{package['unzipped_name']}
        tar -zxf #{package['zip_file_name']} -C #{package['unzipped_name']} --strip-components=1
        #{mv_cmd}
        EOH
    end
  else
    bash 'extract_package' do
      code <<-EOH
        cd #{node['deploynowpackages']['packages_home']}
        mkdir -p #{package['unzipped_name']}
        tar -zxf #{package['zip_file_name']} -C #{package['unzipped_name']} --strip-components=1
        #{mv_cmd}
      EOH
    end
  end
end
