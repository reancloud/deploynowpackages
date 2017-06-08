deploynowpackages Cookbook [Github]
=====================
Cookbook to get the other packages as per the given URL. 
Extract the tar.gz and then rename to correct name

Sample
------------------
```sh
{
  "deploynowpackages": {
    "packages": [
      {
        "download_url": "https://api.github.com/repos/reancloud/chef-dnow/tarball/test",
        "package_name": "chef-dnow",
        "unzipped_name": "chef-dnow-test",
        "zip_file_name": "chef-dnow-test.tar.gz",
        "private_access_token": "<accesstoken>"
      },
      {
        "download_url": "https://api.github.com/repos/opexsw/serf/tarball/0.9.0",
        "package_name": "serf",
        "unzipped_name": "serf-0.9.0",
        "zip_file_name": "serf-0.9.0.tar.gz"
      }
    ]
  }
}
```
License and Authors
-------------------
License: Owned by REAN. Do not copy or use without permission from REAN
Authors: REAN

