default['deploynowpackages']['packages'] = []

if platform?('windows')
  default['deploynowpackages']['packages_home'] = 'C:\\Temp\\reandeploy\\cookbooks\\'
else
  default['deploynowpackages']['packages_home'] = '/tmp/reandeploy/cookbooks/'
end
