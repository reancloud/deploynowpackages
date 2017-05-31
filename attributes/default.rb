default['deploynowpackages']['packages'] = []

if platform?('windows')
  default['deploynowpackages']['packages_home'] = 'C:\\Temp\\cookbooks\\'
else
  default['deploynowpackages']['packages_home'] = '/tmp/cookbooks/'
end
