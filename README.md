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
        "download_url": "https://github.com/opexsw/serf/archive/0.9.0.tar.gz",
        "package_name": "serf",
        "unzipped_name": "serf-0.9.0",
        "zip_file_name": "serf-0.9.0.tar.gz"
      },
      {
        "download_url": "https://github.com/opexsw/serf/archive/0.9.0.tar.gz",
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

