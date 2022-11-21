---
title: "Discovering and Downloading Data with Python"
date: 2021-10-22T09:27:47-07:00
draft: false
weight: 21
---

This tutorial focuses on searching for and downloading Analysis Ready Data (ARD) from a dynamic Spatio-Temporal Asset Catalog (STAC) using the python programming language. At the end of this tutorial, you will have installed the [pystac-client](https://pystac-client.readthedocs.io/en/stable/) library, searched for Lunar data, and downloaded data locally for use in whatever analysis environment you prefer to use. Let's get right to it!

{{% notice note %}}
If you completed the similarly named [Discovering and Downloading Data via the Command Line]({{< ref "/tutorials/cli.md" >}}) you have already installed *conda* and *pystac*. You can simply activate the conda environment (*conda activate stac-client* assuming you used *stac-client* as the environment name in the other tutorial) and skip ahead to section 5!
{{% /notice %}}

## Installing pystac-client
[pystac-client](https://pystac-client.readthedocs.io/en/stable/) is a python library and command line tool for discovering and downloading satellite data. In this tutorial, we will use the python module. First, we need to get the tool installed. Since this is a python tool, we will use the [conda](https://docs.conda.io/en/latest/) package manager to perform the installation. Conda is a cross platform package manager, so this tutorial should work on all operating systems.

If you do not already have conda installed, start with the next section. If you do have conda installed, feel free to skip ahead to section 2 where we create a conda environment and install *stac-client*.

### 1. Install conda
Conda installs into your home directory or area using a standard installer. If you are on a machine that an IT department manages, this means that you should still be able to install. Navigate to the [downloads page](https://docs.conda.io/en/latest/miniconda.html) and select the `miniconda` installation that is right for your operating system. We are suggesting `miniconda` only because it is smaller than the standard conda installation.

Once downloaded, the conda team provides some very good [installation instructions](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) specific for each operating system. The end result of these is that you should be able to execute `echo $Path` (Linux and OS X) or `echo %PATH%` (Windows) and see the `conda` tool in your path.

### 2. Configure conda and create an environment for *pystac-client*
Once conda is installed, we want to add the `conda-forge` channel to the list of locations to get software. A channel is simply the term used to define a single location where software can be downloaded. Different channels can have different software and are usually supported by different communities. Conda-forge is a widely adopted, community channel, that seeks to standardize many commonly used packages. To add the channel to conda, execute:

    conda config --add channels conda-forge

Next, we want to create an environment from which we will run *stac-client*. Why do we need an environment? An environment is a nice way to sequester *stac-client* so that it does not interfere with any other software on your computer and no other software interferes with it. Conda offers some very [robust environment management tools](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-with-commands). For our purposes, all we need to do is create and then activate the environment.

First, create an environment with the name *stac-client*. You can name this environment anything that you like if you prefer.
    
    conda create --name pystac-client

Wait while `conda` creates the environment and accept the prompt where `conda` asks if would like to proceed with the environment creation. Finally, activate the environment to enter it:

    conda activate pystac-client

If you used a different for the environment, be sure to substitute it for *stac-client*.

### 3. Installing *pystac-client*
At this point, you should have a conda environment into which we will install *stac-client*. All of the setup was hopefully worth it as we can now run a single command and have all of the necessary dependencies for *stac-client* installed. Execute:

    conda install pystac-client

To confirm that *stac-client* installed properly, execute:

    python -c "from pystac_client.version import __version__; print(__version__)"


You should see a version number similar to the following:

```bash
0.3.0
```

Congratulations! You have successfully installed *pystac-client*. It is not time to search for analysis ready planetary data.

### 4. Basic Data Discovery
We have officially made it! We have the tools all set up to search for data. Let's get that first search out of the way immediately. If you use an interactive environment like [JupyterLab](https://jupyterlab.readthedocs.io/en/stable/) you can copy the lines into a notebook and execute them. If you do not use JupyterLab, no worries! You can copy the text below into a plaintext file (maybe named search.py) and then run it by executing *python search.py* in the same terminal you used to setup the *conda* environment.

```python
from pystac_client import Client
catalog = Client.open("https://stac.astrogeology.usgs.gov/api")
mysearch = catalog.search(max_items=10)
print(f"{mysearch.matched()} items found")
```

You should see output that looks like the output below:

```bash
1648 items found
```

{{% notice warning %}}
The pystac_client is quite sensitive to trailing slashes in the URLs. While using `https://stac.astrogeology.usgs.gov/api` works, using `https://stac.astrogeology.usgs.gov/api/` returns an opaque `{"code":"NotFound","description":"Not Found"}` error.
{{% /notice %}}

The number of items found will differ as we add more data, but the general response should be identical. This means that the dynamic planetary analysis ready data catalog contains 1648 stac items when this tutorial was being written. 

Lets break down the query to understand what exactly is happening here.

First, we import the pystac client library:

```python
from pystac_client import Client
```

Next, we connect to a catalog using the *Client* object:

```python
catalog = Client.open("https://stac.astrogeology.usgs.gov/api")
```

Then, the search interface is connected do and a maximum number of items (*max_items=10*) keyword argument is passed in order to limit the amount of returned data:

```python
mysearch = catalog.search(max_items=10)
```

Finally, the results of the search are printed to the screen:

```python
print(f"{mysearch.matched()} items found")
```
### 5. GeoJSON, A Brief Interlude
Before we start searching, lets take a moment to talk about GeoJSON. GeoJSON is a standard that is used to encode spatial geometries. All of the STAC items that are available for download include an image footprint or geometry that describes the spatial extent of the data. A common way to discover data is to ask a question like 'what image(s) intersect with my area of interest (AOI)?'. In order to answer that question, we need to ask it using a polygon encoded as GeoJSON. Since we are working with a command line, we need to do a bit of leg work and encode a GeoJSON polygon.

Here is an example of a simple square, defined as GeoJson:

```json
{
    "type": "Polygon",
    "coordinates": [
      [ [-20,-10], [ 20,-10], [20,10], [-20,10], [ -20,-10] ]
    ]
}
```

This area of interest spans from 20˚ west of the prime meridian to 20˚ east of the prime meridian (-20˚ to 20˚) and 10˚ south of the equator to 10˚ north of the equator (-10˚ to 10˚). The geometry includes five points because we need to 'close' the ring. In other words, the first and last point are identical.

In python, we can use this GeoJson object by simply assigning it to a variable:

```python
aoi = {
    "type": "Polygon",
    "coordinates": [
      [ [-20,-10], [ 20,-10], [20,10], [-20,10], [ -20,-10] ]
    ]
}
```

We will use this area of interest lower in the tutorial.

### 6. Listing the available collections

Now we would like to see what collections are available to search and download data from. To do this, we use the same *Client* object from above. The full code looks like this:

```python
from pystac_client import Client
catalog = Client.open("https://stac.astrogeology.usgs.gov/api")
for c in catalog.get_collections():
    print(c)
```

Feel free to execute this in a JupyterLab cell or save a new file (perhaps named *collections.py*). When you run the code above, you should see the following output:

```bash
<CollectionClient id=galileo_usgs_photogrammetrically_controlled_observations>
<CollectionClient id=themis_usgs_photogrammetrically_controlled_observations>
<CollectionClient id=galileo_usgs_photogrammetrically_controlled_mosaics>
<CollectionClient id=kaguya_monoscopic_uncontrolled_observations>
<CollectionClient id=kaguya_stereoscopic_uncontrolled_observations>
<CollectionClient id=kaguya_spsupport_uncontrolled_observations>
```

At the time of writing, the above command will return five different collections with data targeting the Moon, Mars, and Jupiter's moon Europa. Each line represents a different collection that is available from the API (https://stac.astrogeology.usgs.gov/api/"). The [CollectionClient](https://pystac-client.readthedocs.io/en/docs/api.html#collection-client) is a python object that is usable to get associated items. Using that object is beyond the scope of this tutorial.

Let's use the pystac-client to see how many data products are available from the Kaguya/SELENE Terrain Camera.

### 7. Querying a Specific Collection
To see how many items (observations) are available within a given collection, it is necessary to tell *pystac-client* which collection to search. We know the names of the collections because they are the *id* key in the STAC collection. In the example immediately above, the line is `<CollectionClient id=kaguya_monoscopic_uncontrolled_observations>`. Since we are interested in Kaguya TC data, we will use the following code:

```python
from pystac_client import Client
catalog = Client.open("https://stac.astrogeology.usgs.gov/api/")
mysearch = catalog.search(collections=['kaguya_monoscopic_uncontrolled_observations'], max_items=10)
print(f"{mysearch.matched()} items found")
```

Again, this code can be executed using a JupyterLab cell or copied into a new file. At the time of writing, this command reports that 197 items are available.


### 6. Spatial Queries
Above, we described GeoJSON that defines an area of interest. Now we will combine that with a query for the target body we are interested in. Here is the full code:

```python
from pystac_client import Client
catalog = Client.open("https://stac.astrogeology.usgs.gov/api/")

aoi = {
    "type": "Polygon",
    "coordinates": [
      [ [-20,-10], [ 20,-10], [20,10], [-20,10], [ -20,-10] ]
    ]
  }

response = catalog.search(collections=['kaguya_monoscopic_uncontrolled_observations'], intersects=aoi)
print(f"{response.matched()} items found")
```

The first few lines of this code should be starting to look very familiar. After our imports and connection to the client are completed, we define the GeoJSON area of interest (AOI) variable. This time, when performing the search, we tell the API which collection to search and to intersect the footprints in that collection with our area of interest. At the time of writing, this code block return 4 items.

### Basic Data Download
Let's image that the four items found above are ones that we are looking for. To download the data locally we use the *os* and *urllib* modules that are part of the python standard library. 

```python
import os
import urllib

from pystac_client import Client
catalog = Client.open("https://stac.astrogeology.usgs.gov/api")

aoi = {
    "type": "Polygon",
    "coordinates": [
      [ [0,0], [2.5,0], [2.5,2.5], [0,2.5], [0,0] ]
    ]
}

response = catalog.search(collections=['kaguya_monoscopic_uncontrolled_observations'], intersects=aoi)
print(f"{response.matched()} items found")


for item in response.get_items():
    download_path = os.path.join(item.collection_id, item.id)
    if not os.path.exists(download_path):
        os.makedirs(download_path, exist_ok=True)
    for name, asset in item.assets.items():
        urllib.request.urlretrieve(asset.href, 
                                   os.path.join(download_path, 
                                   os.path.basename(asset.href)))
```

The start of the script should also look familiar. The new code, copied below, simply iterates over the items found, checks to see if the download directory already exists, creates it if it does not, and then downloads all of the assets for the discovered items.

This command will run for ~30 seconds (on a relatively fast internet connection). At the conclusion of the run, you should have a new directory called `kaguya_monoscopic_uncontrolled_observations`. Inside of that directory, you should see four sub-directories, each containing **all** of the data for the stac items we discovered previously!

```bash
> ls kaguya_monoscopic_uncontrolled_observations/*
kaguya_monoscopic_uncontrolled_observations/TC1S2B0_01_05522S084E0042:
kaguya_monoscopic_uncontrolled_observations/TC1S2B0_01_05524N012E0019:
TC1S2B0_01_05524N012E0019.isis.lbl    TC1S2B0_01_05524N012E0019.tif
TC1S2B0_01_05524N012E0019.jpg         TC1S2B0_01_05524N012E0019.tif.aux.xml
TC1S2B0_01_05524N012E0019.lbl         provenance.txt

kaguya_monoscopic_uncontrolled_observations/TC1S2B0_01_05524N025E0019:
TC1S2B0_01_05524N025E0019.caminfo.pvl TC1S2B0_01_05524N025E0019.tif
TC1S2B0_01_05524N025E0019.isis.lbl    TC1S2B0_01_05524N025E0019.tif.aux.xml
TC1S2B0_01_05524N025E0019.jpg         provenance.txt
TC1S2B0_01_05524N025E0019.lbl

kaguya_monoscopic_uncontrolled_observations/TC1S2B0_01_05525N005E0009:
TC1S2B0_01_05525N005E0009.caminfo.pvl TC1S2B0_01_05525N005E0009.tif
TC1S2B0_01_05525N005E0009.isis.lbl    TC1S2B0_01_05525N005E0009.tif.aux.xml
TC1S2B0_01_05525N005E0009.jpg         provenance.txt
TC1S2B0_01_05525N005E0009.lbl

kaguya_monoscopic_uncontrolled_observations/TC1S2B0_01_05525N019E0009:
TC1S2B0_01_05525N019E0009.caminfo.pvl TC1S2B0_01_05525N019E0009.tif
TC1S2B0_01_05525N019E0009.isis.lbl    TC1S2B0_01_05525N019E0009.tif.aux.xml
TC1S2B0_01_05525N019E0009.jpg         provenance.txt
TC1S2B0_01_05525N019E0009.lbl
...
```

The data are organized temporally. The STAC specification is spatio-temporal after all.

### 7. Conclusion
That's it! In this tutorial, we have have installed the *pystac-client* library into a conda environment and executed a simple spatial query in order to discover and downloaded STAC data from the USGS hosted analysis ready data (ARD) STAC catalog.
