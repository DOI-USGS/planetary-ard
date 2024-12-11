---
title: "Mosaic.json"
date: 2024-12-05T12:00:00-07:00
draft: false
weight: 20
---

{{< hint type=warning title="Draft" >}}
This is an in progress draft example. Please feel free to test, but use with caution!
{{< /hint >}}

## Introduction

This tutorial will instruct users about mosaic.json and how it can be used with the Planetary ARD data to construct virtual mosaics of ARD products.
We will demonstrate this with a test case on Mars over Jezero Crater using the CTX DEM ARD products through the command line and using Python code.

## Configuring the environment
For this tutorial you will need `pystac_client` (refer to "Discovering and Downloading Data with Python" for an example of how to get this set up), `cogeo_mosaic`, `shapely`, `fire`, and `planetcantile`. These packages can all be installed with pip or conda depending on preference.

To use the command line exclusively, we will need a few additional tools that are distributed through npm and run on nodejs, these can be considered optional for the purpose of the rest of this tutorial. In either case the `pystac_client` is required.

First ensure that nodejs is installed in your terminal, which can be installed using conda or other package managers. We will want three tools:

```bash 
npm install -g wellknown
npm install -g geojsonify
npm install -g geojsonio-cli
```


## What is mosaic.json and why use it?

Mosaic.json is a [open standard][3] for defining a mosaic of ARD assets that can be treated as a single data product as a json file. In particular it is useful for combining assets from STAC catalogs into a single layer. It is similar is concept to GDAL's [VirtualRasters (vrt's)][4], but supports indexes defined by TileMatrixSets (more next section) so that not every asset is used in every tile render that is desired by a client. This can make mosaics of STAC Catalog assets more efficient for use in analysis or visualizations.

## What is a TileMatrixSet?

Most commonly used web-maps work by representing the world with a series of images of constant dimension produced at a variety of resolutions (aka zoom levels) in what is commonly called a tile grid or pyramid structure. For the Earth, Google popularized a tile grid that used a Pseudo Mercator map projection within google maps that is now the defacto standard. To support additional map projections (and other planetary bodies in the solar system), we can use an OGC standard called the TileMatrixSet, which is a JSON document that is able to define other kinds of tile grids other than just Pseudo Mercator in a way that other software is aware of to correctly request the correct map tile for the given area of interest.  

[Tile Matrix Sets][5] (a.k.a. TMS(s)) are an OGC standard for defining two dimensional hierarchical grids. 

![TMS pyramid structure diagram credit OGC](/img/tms.svg)


### References:
- Mosaic.json introductory blog post: [https://medium.com/devseed/cog-talk-part-2-mosaics-bbbf474e66df][1]
- [https://github.com/developmentseed/mosaicjson-spec][2]
- [https://en.wikipedia.org/wiki/Open_standard][3]
- [https://www.gdal.org/gdal_vrttut.html][4]
- [https://docs.ogc.org/is/17-083r4/17-083r4.html][5]

[1]: https://medium.com/devseed/cog-talk-part-2-mosaics-bbbf474e66df "mosaic.json announcement"
[2]: https://github.com/developmentseed/mosaicjson-spec "mosaic.json specification"
[3]: https://en.wikipedia.org/wiki/Open_standard "Open Standard"
[4]: https://www.gdal.org/gdal_vrttut.html "GDAL VRT"
[5]: https://docs.ogc.org/is/17-083r4/17-083r4.html "Tile Matrix Set Specification"
 

### Study Area of Jezero Crater and the ARD DATA we will use

For this tutorial we will focus on Mars and the CTX DTM ARD data that is available to make a mosaic of both the orthorectified CTX grayscale images, Digital Terrain Models (DTMs), and Hillshaded DTMs of the area.

### Where is Jezero Crater?

Jezero is located at Longitude Latitude 77.69 E, 18.41 N in mc13

![Jezero Crater overview from USGS-Astrogeology Center](https://astrogeology.usgs.gov/ckan/dataset/004cc4e5-af74-453b-8d51-ee886c6f4ac2/resource/85abd39a-0097-4b89-ac33-0e8cc9abe6d6/download/m2020_jezerocrater_ctxdem_mosaic-slide.png)

With this information, we can define a query geometry as a bounding box quickly by hand or by using the Shapely library. To start off let's import the various python libraries we will need and then define the Jezero bounds as a variable we'll call `jez`. 

```python
import json
from itertools import chain
from cogeo_mosaic.mosaic import MosaicJSON
import shapely
from pystac_client import Client
import planetcantile as ptile

# get jezero's bounds in shapely
jez = shapely.geometry.box(*shapely.geometry.Point([77.58, 18.38]).buffer(1.).boundary.bounds)
```

### Query the STAC catalogs

Using the `pystac_client` api, we could simply use the `--bbox` parameter in the command line search tool on the USGS CTX Controlled DTM collection (e.g. `--bbox 76.69 17.41 78.69 19.41`).

```bash
stac-client search https://stac.astrogeology.usgs.gov/api/ --bbox 76.69 17.41 78.69 19.41 -c mro_ctx_controlled_usgs_dtms --matched
```

    80 items matched

80 items is a lot! For this example we are interested in showing an example in an area that is interesting to a broad audience, but few places on Mars will have so many data products. To reduce the number of items to work with going forward, let's add a `--max-items 10` to the command to reduce the count to 10 items and then save the search results as json, and then verify that we only had 10 features using `jq`:

```bash
stac-client search https://stac.astrogeology.usgs.gov/api/ --bbox 76.69 17.41 78.69 19.41 -c mro_ctx_controlled_usgs_dtms --max-items 10 --save jezero_ctx_assets_bbox.json
cat jezero_ctx_assets_bbox.json | jq '.features | length'
```
    10

Next let's do the same thing with the Python API using the bounds Shapely geometry we created above. Below we use the Client as described in other tutorials on this page, ensuring to grab all the possible features by iterating over all the pages in the response to the search query, and we will similarly limit the results to 10 items using the `max_items` parameter.

```python
# Setting up the catalog
catalog = Client.open("https://stac.astrogeology.usgs.gov/api/")
# search the catalog for CTX products 
results = list(catalog.search(collections=['mro_ctx_controlled_usgs_dtms'], bbox=jez.bounds, max_items=10).pages_as_dicts())
# make a single geojson layer of all the footprints across all pages
footprints = {'type': 'FeatureCollection', 'features': list(chain.from_iterable([_['features'] for _ in results]))}
print(len(footprints['features']))
```

    10

Let's also try using Python and Shapely to define the AOI geojson within the command line by using a very neat library called `fire` that turns any python code into a command line tool. First we'll create a point geometry object, buffer it by 1.0 degree, run a convex hull to get a polygon, reverse the coordinate order and report the geometry in WKT format. We will then pipe this to a nodejs tool called `wellknown` that will convert it to geojson and then we can write the stdout to the jezereo_aoi.geojson file 


```bash
python -m fire shapely geometry Point 77.69 18.41 - buffer 1.0 - convex_hull - reverse - wkt | wellknown > jezero_aoi.geojson
```

Now we can use the aoi with the stac-client search tool to query the catalog, limiting the results to 10 items as we did before


```bash
stac-client search https://stac.astrogeology.usgs.gov/api/ --intersects jezero_aoi.geojson -c mro_ctx_controlled_usgs_dtms --max-items 10 --save jezero_ctx_assets_aoi.json
!cat jezero_ctx_assets_aoi.json | jq '.features | length'
```

    10

Let's examine the kinds of assets we have for each DTM product


```bash
cat jezero_ctx_assets_aoi.json | jq -r '.features[0].assets | keys'
```
    [
      "dtm",
      "image",
      "intersection_error",
      "mola_csv",
      "orthoimage",
      "qa_metrics",
      "thumbnail"
    ]

There are a number of these but for now let's just list the urls to the orthoimages.

```bash
cat jezero_ctx_assets_aoi.json | jq -r '.features[].assets.orthoimage.href'
```

    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_064020_1983_XN_18N283W__N04_063954_1982_XN_18N283W/N04_064020_1983_XN_18N283W__N04_063954_1982_XN_18N283W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W_orthoimage.tif
    https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062886_1988_XN_18N282W__N02_063308_1988_XN_18N282W/N01_062886_1988_XN_18N282W__N02_063308_1988_XN_18N282W_orthoimage.tif


### Constructing the mosaic.json document


Now we will use the returned footprints from the catalog search to construct three mosaic.json files, one for each kind of asset we are interested in: the DTMs, the hillshaded DTMs, and the ortho/grayscale images. 

First, we will need to get the appropriate TileMatrixSet for Mars from the `Planetcantile` project.

#### Mars TileMatrixSets

For this example on Mars, we will use a TileMatrixSet for Mars from the open-source [Planetcantile](https://github.com/AndrewAnnex/planetcantile) Python library which has created a large set of TMS for many solar system bodies that are recognized by the IAU. Specifically we will use the TMS called `MarsMercatorSphere` which is a TMS for a Mercator projection based on a spherical Mars geoid. Specifically it uses the CRS [IAU_2015:49990](https://www.opengis.net/def/crs/IAU/2015/49990) which is an official CRS that programs like QGIS will be aware of. Installing `planetcantile` to your local python environment via `pip install planetcantile` makes these TMSs available to you, although the json files in the GitHub repository can also be used.

We use this specific TMS because mosaic.json currently only supports TMSs that use an exact quadtree structure. Other TMS for other Mars map projections, such as the Equidistant Cylindrical TMSs (a.k.a Plate carrée or Equirectangular projection) do not obey the quadtree structure, they maintain a 2:1 ratio so are essentially 2 quad trees side-by-side. 

```python
MarsMercatorSphere = ptile.defaults.planetary_tms.get('MarsMercatorSphere')
MarsMercatorSphere
```
    <TileMatrixSet title='MarsMercatorSphere' id='MarsMercatorSphere' crs='http://www.opengis.net/def/crs/IAU/2015/49990>

For doing this work in the command line, we will need to find the path to the source `MarsMercatorSphere.json` file on the filesystem, download it from the `Planetcantile` Github project, or use the Python environment in the command line to access it via morecantiles' command line interface command `morecantile tms --identifier MarsMercatorSphere` which will require the `TILEMATRIXSET_DIRECTORY` environment variable to be set. Let's assume for the rest of this tutorial that `MarsMercatorSphere.json` is present in the current working directory.

### mosaic.json for the Jezero DTMs

Due to the way the STAC catalog items are organized, we will have to do some minimal processing to extract the specific assets we need. 

Then we will use the function `MosaicJSON.from_features` to actually construct the mosaic.json document. The function needs the TMS and collection of features with the paths to the assets, and also accepts two parameters for the min and max zoom level.

First let's make a mosaic.json document for the DTM products using the Python APIs.

```python
# get all the dtm products 
dtm_image_features = [
    dict(geometry=feature['geometry'], properties=dict(path=feature['assets']['dtm']['href']) ) for feature in footprints['features']
]
dtm_image_mosaic = MosaicJSON.from_features(dtm_image_features, minzoom=9, maxzoom=25, tilematrixset=MarsMercatorSphere)
dtm_image_mosaic.name = 'Jezero Example DTMs'
with open('jezero_ctx_dtm_py_mosaic.json', 'w') as dst:
    tmp_dict_dtm = dtm_image_mosaic.model_dump(exclude_none=True)
    dst.write(json.dumps(tmp_dict_dtm))
```

In the command line the same mosaic.json document can be made by using the `jq` CLI tool to downselect the assets we want with the Python `cogeo-mosaic` CLI to make the document.

```bash
jq -c '{"type": "FeatureCollection", features: [ .features[] | .properties = { path: .assets.dtm.href } ]}' jezero_ctx_assets_aoi.json | cogeo-mosaic create-from-features --tms ./MarsMercatorSphere.json --minzoom 9 --maxzoom 30 --property path -o jezero_ctx_dtm_cli_mosaic.json
```

    Get quadkey list for zoom: 9
    Feed Quadkey index
    Iterate over quadkeys  [####################################]  100%

Of the two zoom parameters, the minimum zoom level is the most important to consider when constructing the mosaic.json document for the collection you are using and is also important to think about in relation to the expected size of the asset footprints on the map.

Essentially the minimum zoom level defines how much the assets in the collection will be grouped together. Setting this value to a low number (zoomed-out perspective), will use "higher" levels of the TileMatrixSet pyramid structure, which will use larger and larger tiles to cover the spatial extent of the assets in the collection. 

Conversely, setting the minimum zoom level to be a high number (zoomed-in perspective) will use smaller tiles, and will result in a longer mosaic.json document as all the tiles must be enumerated. These tiles will have fewer assets needed per partition, however if too small will create a lot of spatial partitions that only contain one asset. 

For our use-case, as we are constructing a mosaic of an area where we expect a number of assets to overlap significantly, we will want to set as high of a minimum zoom level as we can without creating too many tiles that contain only one asset (and the same asset repeatedly). Going with too-low of a value would result in fewer entries in the mosaic.json document, but with the high degree of overlap, would mean that many tiles will query redundant overlapping data. 

If we were attempting to mosaic a collection of features that are more sparsely distributed and with few or no overlaps, then a lower minimum zoom level could be used.  

As doing this process is somewhat repetitive, the steps below for the hillshade and ortho image mosaic.json documents with the Python code and the CLI are presented below without additional comments. 


```python
# get all the hillshade products
hillshade_image_features = [
    dict(geometry=feature['geometry'], properties=dict(path=feature['assets']['image']['href']) ) for feature in footprints['features']
]
hillshade_image_mosaic = MosaicJSON.from_features(hillshade_image_features, minzoom=9, maxzoom=25, tilematrixset=MarsMercatorSphere)
hillshade_image_mosaic.name ='Jezero Example Hillshade'
with open('jezero_ctx_hillshade_py_mosaic.json', 'w') as dst:
    tmp_dict_hill = hillshade_image_mosaic.model_dump(exclude_none=True)
    dst.write(json.dumps(tmp_dict_hill))
```

```bash
jq -c '{"type": "FeatureCollection", features: [ .features[] | .properties = { path: .assets.image.href } ]}' jezero_ctx_assets_aoi.json | cogeo-mosaic create-from-features --tms ./MarsMercatorSphere.json --minzoom 9 --maxzoom 30 --property path -o jezero_ctx_hillshade_cli_mosaic.json
```

    Get quadkey list for zoom: 9
    Feed Quadkey index
    Iterate over quadkeys  [####################################]  100%


```python
# get all the ortho image products 
ortho_image_features = [
    dict(geometry=feature['geometry'], properties=dict(path=feature['assets']['orthoimage']['href']) ) for feature in footprints['features']
]
ortho_image_mosaic = MosaicJSON.from_features(ortho_image_features, minzoom=9, maxzoom=25, tilematrixset=MarsMercatorSphere)
ortho_image_mosaic.name = 'Jezero Example Orthos'
with open('jezero_ctx_ortho_py_mosaic.json', 'w') as dst:
    tmp_dict_ortho = ortho_image_mosaic.model_dump(exclude_none=True)
    dst.write(json.dumps(tmp_dict_ortho))
```


```bash
jq -c '{"type": "FeatureCollection", features: [ .features[] | .properties = { path: .assets.orthoimage.href } ]}' jezero_ctx_assets_aoi.json | cogeo-mosaic create-from-features --tms ./MarsMercatorSphere.json --minzoom 9 --maxzoom 30 --property path -o jezero_ctx_ortho_cli_mosaic.json
```

    Get quadkey list for zoom: 9
    Feed Quadkey index
    Iterate over quadkeys  [####################################]  100%

We have now successfully create mosaic.json files for three kinds of ARD assets using two different methods, resulting in six mosaic.json documents.

## Inspect the mosaic.json document.

Let's inspect the hillshade mosaic.json file to understand the structure:

```python
!cat jezero_ctx_hillshade_py_mosaic.json | jq 
```

```json
{
  "mosaicjson": "0.0.3",
  "name": "Jezero Example Hillshade",
  "version": "1.0.0",
  "minzoom": 9, 
  "maxzoom": 25, 
  "quadkey_zoom": 9, 
  "bounds": [75.91771659930976, 14.65135146010114, 77.90597708129924, 19.777888275132497], 
  "center": [76.91184684030449, 17.21461986761682, 9], 
  "tiles": {
    "123301033": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123301122": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123301132": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_hillshade.tif"], 
    "123301300": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif", 
    "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W_hillshade.tif", 
    "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W_hillshade.tif"], 
    "123301301": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W_hillshade.tif"], 
    "123301310": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W_hillshade.tif"], 
    "123301302": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W_hillshade.tif"], 
    "123301303": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W/N15_068162_1984_XN_18N283W__N12_067159_1988_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W/N09_065774_1988_XN_18N283W__N10_066196_1987_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_064020_1983_XN_18N283W__N04_063954_1982_XN_18N283W/N04_064020_1983_XN_18N283W__N04_063954_1982_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W_hillshade.tif"], 
    "123301312": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W/N02_063242_1988_XN_18N283W__N03_063532_1988_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W_hillshade.tif"], 
    "123301320": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123301321": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_064020_1983_XN_18N283W__N04_063954_1982_XN_18N283W/N04_064020_1983_XN_18N283W__N04_063954_1982_XN_18N283W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W_hillshade.tif"], 
    "123301330": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W/N04_063809_1982_XN_18N282W__N05_064231_1982_XN_18N282W_hillshade.tif", "https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W_hillshade.tif"], 
    "123301322": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123301323": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123303100": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123303101": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123303102": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123303103": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123303120": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"], 
    "123303121": ["https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif"]
    }, 
    "tilematrixset": {"title": "MarsMercatorSphere", "id": "MarsMercatorSphere", "orderedAxes": ["E", "N"], "crs": "http://www.opengis.net/def/crs/IAU/2015/49990", "tileMatrices": [{"id": "0", "scaleDenominator": 297696583.54339063, "cellSize": 83355.04339214937, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 1, "matrixHeight": 1}, {"id": "1", "scaleDenominator": 148848291.77169532, "cellSize": 41677.521696074684, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 2, "matrixHeight": 2}, {"id": "2", "scaleDenominator": 74424145.88584766, "cellSize": 20838.760848037342, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 4, "matrixHeight": 4}, {"id": "3", "scaleDenominator": 37212072.94292383, "cellSize": 10419.380424018671, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 8, "matrixHeight": 8}, {"id": "4", "scaleDenominator": 18606036.471461914, "cellSize": 5209.6902120093355, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 16, "matrixHeight": 16}, {"id": "5", "scaleDenominator": 9303018.235730957, "cellSize": 2604.8451060046677, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 32, "matrixHeight": 32}, {"id": "6", "scaleDenominator": 4651509.117865479, "cellSize": 1302.4225530023339, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 64, "matrixHeight": 64}, {"id": "7", "scaleDenominator": 2325754.5589327393, "cellSize": 651.2112765011669, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 128, "matrixHeight": 128}, {"id": "8", "scaleDenominator": 1162877.2794663697, "cellSize": 325.60563825058347, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 256, "matrixHeight": 256}, {"id": "9", "scaleDenominator": 581438.6397331848, "cellSize": 162.80281912529173, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 512, "matrixHeight": 512}, {"id": "10", "scaleDenominator": 290719.3198665924, "cellSize": 81.40140956264587, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 1024, "matrixHeight": 1024}, {"id": "11", "scaleDenominator": 145359.6599332962, "cellSize": 40.70070478132293, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 2048, "matrixHeight": 2048}, {"id": "12", "scaleDenominator": 72679.8299666481, "cellSize": 20.350352390661467, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 4096, "matrixHeight": 4096}, {"id": "13", "scaleDenominator": 36339.91498332405, "cellSize": 10.175176195330733, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 8192, "matrixHeight": 8192}, {"id": "14", "scaleDenominator": 18169.957491662026, "cellSize": 5.087588097665367, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 16384, "matrixHeight": 16384}, {"id": "15", "scaleDenominator": 9084.978745831013, "cellSize": 2.5437940488326833, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 32768, "matrixHeight": 32768}, {"id": "16", "scaleDenominator": 4542.4893729155065, "cellSize": 1.2718970244163417, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 65536, "matrixHeight": 65536}, {"id": "17", "scaleDenominator": 2271.2446864577532, "cellSize": 0.6359485122081708, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 131072, "matrixHeight": 131072}, {"id": "18", "scaleDenominator": 1135.6223432288766, "cellSize": 0.3179742561040854, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 262144, "matrixHeight": 262144}, {"id": "19", "scaleDenominator": 567.8111716144383, "cellSize": 0.1589871280520427, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 524288, "matrixHeight": 524288}, {"id": "20", "scaleDenominator": 283.90558580721915, "cellSize": 0.07949356402602135, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 1048576, "matrixHeight": 1048576}, {"id": "21", "scaleDenominator": 141.95279290360958, "cellSize": 0.03974678201301068, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 2097152, "matrixHeight": 2097152}, {"id": "22", "scaleDenominator": 70.97639645180479, "cellSize": 0.01987339100650534, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 4194304, "matrixHeight": 4194304}, {"id": "23", "scaleDenominator": 35.488198225902394, "cellSize": 0.00993669550325267, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 8388608, "matrixHeight": 8388608}, {"id": "24", "scaleDenominator": 17.744099112951197, "cellSize": 0.004968347751626335, "cornerOfOrigin": "topLeft", "pointOfOrigin": [-10669445.554195119, 10669445.554195119], "tileWidth": 256, "tileHeight": 256, "matrixWidth": 16777216, "matrixHeight": 16777216}]}
}

```

#### Discussion of mosaic.json structure
The mosaic.json file starts with some metadata telling clients the version of the mosaic.json spec that is being used, the bounds of the mosaic, and the zoom level range to consider.

Within the `tiles` section, various assets are listed within lists corresponding to tile indexes as represented by the quadkey convention. This ensures that all children for the given parent tile only use the assets contained in the corresponding list. 

From trial and error we found that a minimum zoom level of 9 had the best trade offs for this area of Mars and for this STAC catalog. As can be seen a dozen or so tiles only contain the CTX ARD asset starting with the image id "P05", but going to a lower zoom level resulted in larger groupings. 

The mosaic.json file also contains the TMS document directly making it easy to distribute. 


## Conclusions

In this tutorial we demonstrated how to construct a mosaic.json document from a STAC Catalog query using the Python API. Next we will demonstrate how to use the mosaic.json document with the Titiler dynamic tile server to view these mosaics of ARD products in QGIS.


### Questions or Comments?
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