deploynowpackages Cookbook
=====================
Cookbook to get the other packages as per the given URL. 
Extract the tar.gz and then rename to correct name

Sample
------------------
```sh
{
"deploynowpackages":  { 
	"packages" : 
	[
        {
        "download_url":"https://github.com/opexsw/serf/archive/0.9.0.tar.gz",
        "zip_file_name":"serf-0.9.0.tar.gz",
        "unzipped_name":"serf-0.9.0",
        "package_name":"serf"
        },
        {
        "download_url":"https://github.com/opexsw/serf/archive/0.9.0.tar.gz",
        "zip_file_name":"serf-0.9.0.tar.gz",
        "unzipped_name":"serf-0.9.0",
        "package_name":"serf"
        }
        ]
	}
}
```
License and Authors
-------------------
License: Owned by Opex Software. Do not copy or use without permission from Opex Software
Authors: Opex Software

