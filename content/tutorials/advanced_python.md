---
title: "Advanced: Discovering and Downloading Data with Python"
date: 2023-11-22T12:14:47-07:00
draft: false
weight: 21
---

This tutorial focuses on advancing the previous knowledge of searching for and downloading Analysis Ready Data (ARD) from a dynamic Spatio-Temporal Asset Catalog (STAC) using the python programming language. As one gets into more advanced queries, new tools can be used to speed up the process. In this tutorial we will use [`async`](https://docs.python.org/3/library/asyncio.html) to help us retrieve a list of url's that we want before using `rclone` to download them from the cloud. Rclone is perfered when accessing the cloud as opposed to `wget` or `urllib.request.urlretrieve`.

## Configuring the environment
For this tutorial you will need `pystac_client` (refer to "Discovering and Downloading Data with Python" for an example of how to get this set up), `pandas`, `geopandas`, `shapely`, `pvl`, `aiohttp` and `asyncio`. These packages can all be installed with pip or conda depending on preference.

### A quick aside about async
Why use async? Async allows you to write more eddiecient and responsive code. Tradionally, python programs execute code sequentially, which can lead to delays while eaiting for tasks to cpmplete (such as network requests). Async is based on asychronous programing and is implimented through Python's `asyncio` module. It enables non-blocking execution. In this tutorial we will use it to quickly find the data we need.

## The goal
In this tutorial we want to use the API to access several databases and then retrieve urls based on a certain critera. For the purposes of this example we will be looking at the incidence angle of each image. Lets start by getting our file set up, for the purposes of this example, we will say we are trying to get images in a certain bounding box.

```python
from pystac_client import Client
import pandas as pd
import geopandas as gpd
from shapely.geometry import shape
pd.set_option("display.max_colwidth", 150)
import pvl
import aiohttp
import asyncio

# set pystac_client logger to DEBUG to see API calls
import logging
logging.basicConfig()
logger = logging.getLogger('pystac_client') 
logger.setLevel(logging.INFO)

# Bounding Box for this example
bounding_box  = [3,4,5,6]

# Use async to define how to get incidence angle
async def get_incidence(session, url):
    async with session.get(url) as response:
        lbl_as_text = await response.text()
        lbl = pvl.loads(lbl_as_text)
        incidence_angle = lbl['Caminfo']['Geometry']['IncidenceAngle']
        return incidence_angle

loop = asyncio.get_event_loop()

# Setting up the catalog
catalog = Client.open("https://stac.astrogeology.usgs.gov/api/")
```

With this setup code we can then go on to create a geodata frame to store the results of the query. For example, the link to the image, the image id, the geometry, the incidence angle, etc. In the below example, the data is stored in `items.gdf`

```python
# Names of the databases you want to retrieve images from
databases = ['kaguya_terrain_camera_stereoscopic_uncontrolled_observations', 'kaguya_terrain_camera_spsupport_uncontrolled_observations', 'kaguya_terrain_camera_monoscopic_uncontrolled_observations']
results = []
result_df = pd.DataFrame()
# Iterate through allt he kaguya databases
for database in databases:
    result = catalog.search(collections=[database],bbox=bounding_box, max_items=200)
    results.append(result)

# Get all items as a dictionary
items = []
for r in results:
    items += r.get_all_items_as_dict()['features']
for i in items:
    i['geometry'] = shape(i['geometry'])
items_gdf = gpd.GeoDataFrame(pd.json_normalize(items))

# Use async to find the incidence angles
async with aiohttp.ClientSession() as session:
    tasks = []
    for url in items_gdf['assets.caminfo_pvl.href'].values:
        tasks.append(asyncio.ensure_future(get_incidence(session, url)))
    angles = await asyncio.gather(*tasks)

items_gdf['incidence_angle'] = angles
```

Now we have all the images that intersect our given bounding box, we want to download them locally. All of these images are hosted on the cloud, so this is a great time to use rclone. First, lets make the paths to were the data is hosted in the cloud

```python
with open("kaguyatc_images_to_download.txt", 'w') as f:
    for index in range(len(items_gdf)):
        old_url = items_gdf['assets.image.href'].iloc[index]
        updated_url = f"s3_noauth:/{old_url.split('/')[2].split('.')[0]}/{'/'.join(old_url.split('/')[3:])}\n"
        f.write(updated_url)
```

Where `s3_noauth` represents the name where they are stored in your config file. When using rclone one must setup a rclone.conf file. To do this navigate to the `rclone.conf` file, it should be stored in your home directory in `./.config/rclone/rclone.conf`. Open it using vim `vim ./.config/rclone/rclone.conf` and insert the following in.

```
[s3_noauth]
type = s3
provider = AWS
env_auth = false
region = us-west-2
```

Now rclone is all set up and ready to use! Although there are python packages that allow one to use rclone in python, they are a bit clunky and not as well supported. As such it is recommended to create the following script to quickly and easily download your files. Save this script in `download_files.sh`

```bash
#!/bin/bash

input_file=$1
destination=$2

while IFS= read -r file; do
    echo ${file}
    rclone copy "${file}" "${destination}"
done < "${input_file}"
```

It can then be run with a command like: `sh download_files.sh kaguyatc_images_to_download.txt /path/to/dowload/folder`

Thats it! You have sucesfully downloadde imags using rclone and async. Hopefully this will speed up downloading and fetching processess.