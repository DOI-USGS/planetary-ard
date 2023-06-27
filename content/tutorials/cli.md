---
title: "Discovering and Downloading Data via the Command Line"
date: 2021-10-19T14:20:00-07:00
draft: false
weight: 20
---

{{< hint type=warning title="Draft" >}}
This is an in progress draft example. Please feel free to test, but use with caution!
{{< /hint >}}

This tutorial focuses on searching for and downloading Analysis Ready Data (ARD) from a dynamic Spatio-Temporal Asset Catalog (STAC) using the command line. At the end of this tutorial, you will have installed the [stac-client](https://pystac-client.readthedocs.io/en/stable/) command line tool, searched for Lunar data, and downloaded data locally for use in whatever analysis environment you prefer to use. Let's get right to it!

In this tutorial, you will learn how to:
- Create GeoJSON Region of Interests (ROIs)
- Use the STAC API to list available collections
- Use the STAC API to search collections for data in the ROI
- Download data from the cloud inside of a predefined ROI.
## Prerequisites
This tutorial requires that you have the following tools installed on your computer:

| Software Library or Application | Version Used |
| ------------------------------- | ------------ |
| [stac-client](https://pystac-client.readthedocs.io/en/stable/) | 0.6.1 |
| [jq](https://jqlang.github.io/jq/) | 1.6|
| [wget](https://www.cyberciti.biz/faq/howto-install-wget-om-mac-os-x-mountain-lion-mavericks-snow-leopard/) | 1.20.3|




## Installing stac-client
[stac-client](https://pystac-client.readthedocs.io/en/stable/) is a python library and command line tool for discovering and downloading satellite data. In this tutorial, only the command line tool will be used. First, we need to get the tool installed. See the [installation instructions](https://pystac-client.readthedocs.io/en/stable/#installation) to get the tool installed.

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
      [ [0,0], [0.5,0], [0.5,0.5], [0,0.5], [0,0] ]
    ]
}
```

This area of interest spans from the prime meridian to 2.5˚ east of the prime meridian (0˚ to 0.5˚) and the equator to 0.5˚ north of the equator (0˚ to 0.5˚). The geometry includes five points because we need to 'close' the ring. In other words, the first and last point are identical.

Let's save that GeoJSON into a text file named `aoi.geojson` (or area of interest). If you are having any issues with the above, definitely run the string through a GeoJSON linter (or checker) like [geojsonlint.com](https://geojsonlint.com).

### 5. Basic Data Discovery
We have officially made it! We have the tools all set up to search for data. Let's get that first search out of the way immediately. Execute the following:

    stac-client search https://stac.astrogeology.usgs.gov/api --matched --method GET

You should see output that looks like the output below:

```bash
160719 items matched
```


The number of items found will differ as we add more data, but the general response should be identical. This means that the dynamic planetary analysis ready data catalog contains 57114 stac items when this tutorial was being written. 

Lets break down the query to understand what exactly is happening here. First, here is the query that we executed:

    stac-client search https://stac.astrogeology.usgs.gov/api --matched --method GET

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
    "description": "A collection containing observations captured by the Galileo Orbiter Solid State Imaging System.",
    "links": [
      {
        "rel": "self",
        "href": "https://stac.astrogeology.usgs.gov/api/collections/galileo_usgs_photogrammetrically_controlled_observations",
        "type": "application/json"
```

At the time of writing, the above command will return six different collections with data targeting the Moon, Mars, and Jupiter's moon Europa. Each of these collections can be queried independently. Let's see how many data products are available from the Kaguya/SELENE Terrain Camera.

The full dump of collection metadata is a lot to parse and likely not information needed all at once. It would be easier to just get the human readable title and the machine parseable collection id. To do this:

    `stac-client collections https://stac.astrogeology.usgs.gov/api | jq '.[] | "\(.title) \(.id)"'`

The output should look something similar to the following:

```bash
"Absolutely controlled Galileo Observations galileo_usgs_photogrammetrically_controlled_observations"
"Absolutely controlled Galileo Observation Mosaics galileo_usgs_photogrammetrically_controlled_mosaics"
"Mars Odyssey (MO) Thermal Emission Imaging System (THEMIS) Infrared (IR) Controlled Image Mosaics mo_themis_controlled_mosaics"
"Mars Reconnaissance Orbiter (MRO) Context Camera (CTX) Digital Terrain Models (DTMs) mro_ctx_controlled_usgs_dtms"
"Absolutely controlled Galileo Observation DTMs galileo_usgs_photogrammetrically_controlled_dtms"
"Mars Reconnaissance Orbiter (MRO) High Resolution Imaging Science Experiment (HiRISE) Observations mro_hirise_uncontrolled_observations"
```

{{% notice note %}}
This tutorial is using the [jq](https://stedolan.github.io/jq/) command line JSON tool pretty heavily. While powerful, the jq syntax can be very intimidating! Feel empowered to just copy/paste for now and let us have spent the time getting the syntax right. Once you are more comfortable with the basics of querying the API you could dig more into jq. Alternatively, just print the JSON to the screen or pipe it to a text file and manually scan for the fields of interest.
{{% /notice %}}

### 7. Querying a Specific Collection
To see how many items (observations) are available within a given collection, it is necessary to tell *stac-client* which collection to search. We know the names of the collections because they are the *id* key in the STAC collection. In the example immediately above, the line is `"id": "mro_hirise_uncontrolled_observations"`. Since we are interested in MRO HiRISE data, we will use the following command:

  `stac-client search https://stac.astrogeology.usgs.gov/api/ -c mro_hirise_uncontrolled_observations --matched`

The response should be:

```bash
155277 items matched
```

### 6. Spatial Queries
Above, we created a file named `aoi.geojson` that defines an area of interest. Now we will combine that with a query for the target body we are interested in. Here is the full command:

  `stac-client search https://stac.astrogeology.usgs.gov/api/ --intersects aoi.geojson -c mro_hirise_uncontrolled_observations --save hirise_to_download.json`

Lets break this command down like we did above:

- `https://stac.astrogeology.usgs.gov/api/` - defines the URL to search
- `--intersects aoi.geojson` tells stac-client to only search for data that intersects our area of interest (as defined in aoi.json)
- `--save hirise_to_download.json` tells *stac-client* to save the results to a file named `hirise_to_download.json`. We will use this file in the next step to download the files found.

This command creates a new file on disk, *hirise_to_download.json* that contains a GeoJSON FeatureCollection with some number of observations in it. We can see what the number is by parsing the file or running the above command replace *--save hirise_to_download.json* with *--matched*. (At the time of writing, this command return 4 items.)

{{% notice note %}}
Since the *hirise_to_download.json* file is a GeoJSON FeatureCollection, it is possible to load that file into your favorite GIS, to visualize the image footprints, and to see the attributes of the different items. You will not see the data behind the metadata, but we will download the data in the next step.
{{% /notice %}}

### Basic Data Download
Let's imagine that the four items found above are ones that we are looking for. In the previous step you executed a query and created a new file named `hirise_to_download.json` that contains four STAC items. To download the data locally here is a small helper script. This script makes use of *jq* and *wget*. You could save this script to the directory you are currently in into a file named *download_stac.sh*.

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

  `./download_stac.sh hirise_to_download.json`

This command will run for a few minutes (on a relatively fast internet connection). At the conclusion of the run, you should have a new directory called `hirise_uncontrolled_monoscopic`. Inside of that directory, you should see four sub-directories, each containing **all** of the data for the stac items we discovered previously!

```bash
ls mro_hirise_uncontrolled_observations/*
mro_hirise_uncontrolled_observations/ESP_041909_1800_COLOR:
ESP_041909_1800_COLOR.LBL ESP_041909_1800_COLOR.jpg ESP_041909_1800_COLOR.tif provenance.txt

mro_hirise_uncontrolled_observations/ESP_041909_1800_RED:
ESP_041909_1800_RED.LBL   ESP_041909_1800_RED.jpg   ESP_041909_1800_RED.jpg.1 ESP_041909_1800_RED.tif   ESP_041909_1800_RED.tif.1 provenance.txt

mro_hirise_uncontrolled_observations/PSP_007361_1800_COLOR:
PSP_007361_1800_COLOR.LBL PSP_007361_1800_COLOR.jpg PSP_007361_1800_COLOR.tif provenance.txt

mro_hirise_uncontrolled_observations/PSP_007361_1800_RED:
PSP_007361_1800_RED.LBL PSP_007361_1800_RED.jpg PSP_007361_1800_RED.tif provenance.txt
```

The data are organized temporally. The STAC specification is spatio-temporal after all.

### 7. Conclusion
That's it! In this tutorial, we have installed the *stac-client* tool into a conda environment and executed a simple spatial query in order to discover and downloaded STAC data from the USGS hosted analysis ready data (ARD) STAC catalog.

### Questions or Comments?
### Discuss the Data
<meta property="og:title">
<script src="https://giscus.app/client.js"
        data-repo="DOI-USGS/planetary-ard"
        data-repo-id="R_kgDOJXSw8g"
        data-category="General"
        data-category-id="DIC_kwDOJXSw8s4CVzn1"
        data-mapping="og:title"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="en"
        data-loading="lazy"
        crossorigin="anonymous"
        async>
</script>