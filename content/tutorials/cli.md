---
title: "Discovering and Downloading Data via the Command Line"
date: 2021-10-19T14:20:00-07:00
draft: false
weight: 20
---

This tutorial focuses on searching for and downloading Analysis Ready Data (ARD) from a dynamic Spatio-Temporal Asset Catalog (STAC) using the command line. At the end of this tutorial, you will have installed the [stac-client](https://pystac-client.readthedocs.io/en/stable/) command line tool, searched for Lunar data, and downloaded data locally for use in whatever analysis environment you prefer to use. Let's get right to it!

## Installing stac-client
[stac-client](https://pystac-client.readthedocs.io/en/stable/) is a python library and command line tool for discovering and downloading satellite data. In this tutorial, only the command line tool will be used. First, we need to get the tool installed. Since this is a python tool, we will use the [conda](https://docs.conda.io/en/latest/) package manager to perform the installation. Conda is a cross platform package manager, so this tutorial should work on all operating systems.

If you do not already have conda installed, start with the next section. If you do have conda installed, feel free to skip ahead to section 2 where we create a conda environment and install *stac-client*.

### 1. Install conda
Conda installs into your home directory or area using a standard installer. If you are on a machine that an IT department manages, this means that you should still be able to install. Nagivate to the [downloads page](https://docs.conda.io/en/latest/miniconda.html) and select the `miniconda` installation that is right for your operating system. We are suggesting `miniconda` only because it is smaller than the standard conda installation.

Once downloaded, the conda team provides some very good [installation instructions](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) specific for each operating system. The end result of these is that you should be able to execute `echo $Path` (Linux and OS X) or `echo %PATH%` (Windows) and see the `conda` tool in your path.

### 2. Configure conda and create an environment for *stac-client*
Once conda is installed, we want to add the `conda-forge` channel to the list of locations to get software. A channel is simply the term used to define a single location where software can be downloaded. Different channels can have different software and are usually supported by different communities. Conda-forge is a widely adopted, community channel, that seeks to standardize many commonly used packages. To add the channel to conda, execute:

    conda config --add channels conda-forge

Next, we want to create an environment from which we will run *stac-client*. Why do we need an environment? An environment is a nice way to sequester *stac-client* so that it does not interfere with any other software on your computer and no other software interferes with it. Conda offers some very [robust environment management tools](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-with-commands). For our purposes, all we need to do is create and then activate the environment.

First, create an environment with the name *stac-client*. You can name this environment anything that you like if you prefer.
    
    conda create --name stac-client

Wait while `conda` creates the environment and accept the prompt where `conda` asks if would like to proceed with the environment creation. Finally, activate the environment to enter it:

    conda activate stac-client

If you used a different for the environment, be sure to substitute it for *stac-client*.

### 3. Installing *stac-client*
At this point, you should have a conda environment into which we will install *stac-client*. All of the setup was hopefully worth it as we can now run a single command and have all of the necessary dependencies for *stac-client* installed. Execute:

    conda install pystac-client

{{% notice note %}}
Note the **py** at the start of the name above. The client is written in python so the module is called *pystac-client*. When we use the command line tool, the name is *stac-client*. 
{{% /notice %}}

To confirm that *stac-client* installed properly, execute:

    stac-client --help

You should see the following output:

```bash
usage: stac-client [-h] [--version] {collections,search} ...

STAC Client

positional arguments:
  {collections,search}
    collections         Get all collections in this Catalog
    search              Perform new search of items

optional arguments:
  -h, --help            show this help message and exit
  --version             Print version and exit
```

Congratulations! You have successfully installed *stac-client*. It is now time to search for analysis ready planetary data.

### 4. GeoJSON, A Brief Interlude
Before we start searching, lets take a moment to talk about GeoJSON. GeoJSON is a standard that is used to encode spatial geometries. All of the STAC items that are available for download include an image footprint or geometry that describes the spatial extent of the data. A common way to discover data is to ask a question like 'what image(s) intersect with my area of interest (AOI)?'. In order to answer that question, we need to ask it using a polygon encoded as GeoJSON. Since we are working with a command line, we need to do a bit of leg work and encode a GeoJSON polygon.

First, let's make a simple square. To do this, open a text editor (vim, emacs, nano, notepad++, text editor, etc.) and paste the following:

```json
{
    "type": "Polygon",
    "coordinates": [
      [ [0,0], [2.5,0], [2.5,2.5], [0,2.5], [0,0] ]
    ]
}
```

This area of interest spans from the prime meridian to 2.5˚ east of the prime meridian (0˚ to 2.5˚) and the equator to 2.5˚ north of the equator (0˚ to 2.5˚). The geometry includes five points because we need to 'close' the ring. In other words, the first and last point are identical.

Let's save that GeoJSON into a text file named `aoi.geojson` (or area of interest). If you are having any issues with the above, definitely run the string through a GeoJSON linter (or checker) like [geojsonlint.com](https://geojsonlint.com).

### 5. Basic Data Discovery
We have officially made it! We have the tools all set up to search for data. Let's get that first search out of the way immediately. Execute the following:

    stac-client search https://stac.astrogeology.usgs.gov/api --matched

You should see output that looks like the output below:

```bash
57114 items matched
```

{{% notice warning %}}
The stac-client command line tool is quite sensitive to trailing slashes in the URLs. While using `https://stac.astrogeology.usgs.gov/api` works, using `https://stac.astrogeology.usgs.gov/api/` returns an opaque `{"code":"NotFound","description":"Not Found"}` error.
{{% /notice %}}

The number of items found will differ as we add more data, but the general response should be identical. This means that the dynamic planetary analysis ready data catalog contains 57114 stac items when this tutorial was being written. 

Lets break down the query to understand what exactly is happening here. First, here is the query that we executed:

    stac-client search https://stac.astrogeology.usgs.gov/api --matched

The first thing we do is tell *stac-client* that we want to search for data. The other option would be `stac-client collections` (we will use that shortly). Next, *stac-client* needs to know the URL to use to be able to access the STAC search service. The USGS hosted STAC server URL is `https://stac.astrogeology.usgs.gov/api/`. The last argument tells *stac-client* to limit the number of returned items to 1 and to print the number of matched items. 

### 6. Listing the available collections
{{% notice note %}}
We use the *jq* tool in the section for pretty printing the GeoJSON responses from the API. *jq* can be installed just like `stac-client` was installed, using `conda install jq`.
{{% /notice %}}

Now we would like to see what collections are available to search and download data from. To do this, we can use the following command:

    stac-client collections https://stac.astrogeology.usgs.gov/api

or, if you have installed *jq* for pretty printing:

    stac-client collections https://stac.astrogeology.usgs.gov/api | jq

The output should look similar to the following:

```bash
[
  {
    "type": "Collection",
    "id": "galileo_usgs_photogrammetrically_controlled_observations",
    "stac_version": "1.0.0",
    "description": "A collection containing observations captured by the Galileo Orbiter Solid State Imaging System",
    "links": [
      {
        "rel": "self",
```

At the time of writing, the above command will return six different collections with data targeting the Moon, Mars, and Jupiter's moon Europa. Each of these collections can be queried independently. Let's see how many data products are available from the Kaguya/SELENE Terrain Camera.

The full dump of collection metadata is a lot to parse and likely not information needed all at once. It would be easier to just get the human readable title and the machine parseable collection id. To do this:

    stac-client collections https://stac.astrogeology.usgs.gov/api | jq '.[] | "\(.title) \(.id)"'

The output should look something similar to the following:

```bash
"Absolutely controlled Galileo Observations galileo_usgs_photogrammetrically_controlled_observations"
"Absolutely controlled Themis Observations themis_usgs_photogrammetrically_controlled_observations"
"Absolutely controlled Galileo Observation Mosaics galileo_usgs_photogrammetrically_controlled_mosaics"
"Uncontrolled Kaguya (SELENE) Monoscopic Observations kaguya_monoscopic_uncontrolled_observations"
"Uncontrolled Kaguya (SELENE) Stereoscopic Observations kaguya_stereoscopic_uncontrolled_observations"
"Uncontrolled Kaguya (SELENE) Spectral Profiler (SP) Support Observations kaguya_spsupport_uncontrolled_observations"
```

{{% notice note %}}
This tutorial is using the [jq](https://stedolan.github.io/jq/) command line JSON tool pretty heavily. While powerful, the jq syntax can be very intimidating! Feel empowered to just copy/paste for now and let us have spent the time getting the syntax right. Once you are more comfortable with the basics of querying the API you could dig more into jq. Alternatively, just print the JSON to the screen or pipe it to a text file and manually scan for the fields of interest.
{{% /notice %}}

### 7. Querying a Specific Collection
To see how many items (observations) are available within a given collection, it is necessary to tell *stac-client* which collection to search. We know the names of the collections because they are the *id* key in the STAC collection. In the example immediately above, the line is `"id": "usgs_controlled_mosaics_voy1_voy2_galileo"`. Since we are interested in Kaguya TC data, we will use the following command:

  stac-client search https://stac.astrogeology.usgs.gov/api/ -c kaguya_monoscopic_uncontrolled_observations --matched

At the time of writing, this command reports that 100 items are available. (We are adding the entire dataset shortly!)


### 6. Spatial Queries
Above, we created a file named `aoi.geojson` that defines an area of interest. Now we will combine that with a query for the target body we are interested in. Here is the full command:

    stac-client search https://stac.astrogeology.usgs.gov/api/ --intersects aoi.geojson -c kaguyatc_uncontrolled_monoscopic --save kaguyatc_to_download.json

Lets break this command down like we did above:

- `https://stac.astrogeology.usgs.gov/api/` - defines the URL to search
- `--intersects aoi.geojson` tells stac-client to only search for data that intersects our area of interest (as defined in aoi.json)
- `--save kaguyatc_to_download.json` tells *stac-client* to save the results to a file named `kaguyatc_to_download.json`. We will use this file in the next step to download the files found.

This command creates a new file on disk, *kaguyatc_to_download.json* that contains a GeoJSON FeatureCollection with some number of observations in it. We can see what the number is by parsing the file or running the above command replace *--save kaguyatc_to_download.json* with *--matched*. (At the time of writing, this command return 13 items.)

{{% notice note %}}
Since the *kaguyatc_to_download.json* file is a GeoJSON FeatureCollection, it is possible to load that file into your favorite GIS, to visualize the image footprints, and to see the attributes of the different items. You will not see the data behind the metadata, but we will download the data in the next step.
{{% /notice %}}

### Basic Data Download
Let's imagine that the four items found above are ones that we are looking for. In the previous step you executed a query and created a new file named `kaguyatc_to_download.json` that contains four STAC items. To download the data locally here is a small helper script. This script makes use of *jq* and *wget*. You could save this script to the directory you are currently in into a file named *download_stac.sh*.

```bash
#!/bin/bash
infile=$1

for row in $(cat $1 | jq -r '.features[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r ${1}
    }

    collection=$(_jq '.collection')
    dir=$(_jq '.id')

    if [ ! -d "${collection}/${dir}" ]
    then
      mkdir -p "${collection}/${dir}"
    fi

    for href in $(_jq '.assets[].href'); do
      wget $href -P "${collection}/${dir}"
    done

done
```

Then you can download the files that were found by the search using the following:

  ./download_stac.sh kaguyatc_to_download.json

This command will run for ~30 seconds (on a relatively fast internet connection). At the conclusion of the run, you should have a new directory called `kaguyatc_uncontrolled_monoscopic`. Inside of that directory, you should see four sub-directories, each containing **all** of the data for the stac items we discovered previously!

```bash
kaguyatc_uncontrolled_monoscopic/TC1S2B0_01_05522S084E0042:
TC1S2B0_01_05522S084E0042.caminfo.pvl TC1S2B0_01_05522S084E0042.lbl         TC1S2B0_01_05522S084E0042.xml
TC1S2B0_01_05522S084E0042.isis.lbl    TC1S2B0_01_05522S084E0042.tif         provenance.txt
TC1S2B0_01_05522S084E0042.jpg         TC1S2B0_01_05522S084E0042.tif.aux.xml

kaguyatc_uncontrolled_monoscopic/TC1W2B0_01_02703S067E3456:
TC1W2B0_01_02703S067E3456.caminfo.pvl TC1W2B0_01_02703S067E3456.lbl         TC1W2B0_01_02703S067E3456.xml
TC1W2B0_01_02703S067E3456.isis.lbl    TC1W2B0_01_02703S067E3456.tif         provenance.txt
TC1W2B0_01_02703S067E3456.jpg         TC1W2B0_01_02703S067E3456.tif.aux.xml

kaguyatc_uncontrolled_monoscopic/TC1W2B0_01_05207N014E3424:
TC1W2B0_01_05207N014E3424.caminfo.pvl TC1W2B0_01_05207N014E3424.lbl         TC1W2B0_01_05207N014E3424.xml
TC1W2B0_01_05207N014E3424.isis.lbl    TC1W2B0_01_05207N014E3424.tif         provenance.txt
TC1W2B0_01_05207N014E3424.jpg         TC1W2B0_01_05207N014E3424.tif.aux.xml

kaguyatc_uncontrolled_monoscopic/TC2S2B0_01_03017S081E0067:
TC2S2B0_01_03017S081E0067.caminfo.pvl TC2S2B0_01_03017S081E0067.lbl         TC2S2B0_01_03017S081E0067.xml
TC2S2B0_01_03017S081E0067.isis.lbl    TC2S2B0_01_03017S081E0067.tif         provenance.txt
TC2S2B0_01_03017S081E0067.jpg         TC2S2B0_01_03017S081E0067.tif.aux.xml
```

The data are organized temporally. The STAC specification is spatio-temporal after all.

### 7. Conclusion
That's it! In this tutorial, we have installed the *stac-client* tool into a conda environment and executed a simple spatial query in order to discover and downloaded STAC data from the USGS hosted analysis ready data (ARD) STAC catalog.
