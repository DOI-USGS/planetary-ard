---
title: "Analysis with Mosaic.json"
date: 2024-12-10T12:00:00-07:00
draft: false
weight: 20
---

{{< hint type=warning title="Draft" >}}
This is an in progress draft example. Please feel free to test, but use with caution!
{{< /hint >}}

## Introduction

In this tutorial we will demonstrate how to use the mosaic.json document created in the prior tutorial with Rasterio and QGIS for use in analysis.

### Prerequisites

Users will need a python environment with the following dependencies installed. The python environment made within the mosaic.json python tutorial has all of these dependencies included already except for matplotlib.

1. rasterio
2. httpx
3. matplotlib
4. uvicorn
5. planetcantile

### What is TiTiler?

TiTiler is a light-weight python based dynamic tile web server that is open source and freely made available and maintained by the company DevelopmentSeed. TiTiler uses TileMatrixSets to efficiently provide REST endpoints to work with COGs and mosaic.json documents, enabling basic metadata queries and more advanced operations such as dynamic reprojection, resampling, rescaling, and advanced user made algorithms computed on a per-tile basis. TiTiler also helps traditional GIS analysis applications like QGIS make use of newer standards like mosaic.json. 

For this tutorial we will use the TiTiler application included with Planetcantile for working with our mosaic.json documents both programmatically and with QGIS.

### Launching TiTiler

Users will also need access to a TiTiler endpoint that uses the Planetcantile TileMatrixSet definitions discussed in the mosaic.json tutorial. Users who have installed Planetcantile may use the TiTiler app included within Planetcantile, or they can connect to the one hosted by the USGS astrogeology center at <>.

To launch the Planetcantile TiTiler app, in another terminal run 

```bash
uvicorn planetcantile.app:app --port 8080
```

Which will launch a webserver for TiTiler on you machine.

Let this process continue to run as you proceed through the terminal, but it can be shutdown whenever you are no longer using it.




## 1. Basic mosaic.json metadata queries

Using TiTiler's REST api, we will make some basic queries demonstrating use of our mosaic.json documents.
First we will copy the mosaic.json files (assuming they are in the current working directory) to /tmp/ for shorter file paths later on in the tutorial.


```python
!cp *mosaic.json /tmp/ 
```

Next we will perform some imports


```python
import rasterio as rio
from PIL import Image
import httpx
from pprint import pprint
import matplotlib.pyplot as plt
titiler = 'http://localhost:8080'
```

And next we will define some paths we will re-use.


```python
mosaic_dtm = '/tmp/jezero_ctx_dtm_py_mosaic.json'
mosaic_oth = '/tmp/jezero_ctx_ortho_py_mosaic.json'
mosaic_hil = '/tmp/jezero_ctx_hillshade_py_mosaic.json'
mosaic_files = [mosaic_hil, mosaic_oth, mosaic_dtm]

```

First we will use the `mosaicjson/info` endpoint provided by TiTiler to output basic information about the mosaics we've made.


```python
for mosaic in mosaic_files:
    r = httpx.get(
        f"{titiler}/mosaicjson/info",
        params = {
            "url": mosaic,
        }
    ).json()
    print(f'Info for {mosaic}: ')
    pprint(r, indent=2)
    print('\n')
    bounds = r['bounds']
```

    Info for /tmp/jezero_ctx_hillshade_py_mosaic.json: 
    { 'bounds': [ 75.91771659930976,
                  14.65135146010114,
                  77.90597708129924,
                  19.777888275132497],
      'center': [76.91184684030449, 17.21461986761682, 0],
      'crs': 'http://www.opengis.net/def/crs/IAU/2015/49900',
      'mosaic_maxzoom': 25,
      'mosaic_minzoom': 9,
      'mosaic_tilematrixset': "<TileMatrixSet title='Mars (2015) - Sphere EN "
                              "MercatorSphere' id='MarsMercatorSphere' "
                              "crs='http://www.opengis.net/def/crs/EPSG/0/None>",
      'name': 'Jezero Example Hillshade',
      'quadkeys': []}
    
    
    Info for /tmp/jezero_ctx_ortho_py_mosaic.json: 
    { 'bounds': [ 75.91771659930976,
                  14.65135146010114,
                  77.90597708129924,
                  19.777888275132497],
      'center': [76.91184684030449, 17.21461986761682, 0],
      'crs': 'http://www.opengis.net/def/crs/IAU/2015/49900',
      'mosaic_maxzoom': 25,
      'mosaic_minzoom': 9,
      'mosaic_tilematrixset': "<TileMatrixSet title='Mars (2015) - Sphere EN "
                              "MercatorSphere' id='MarsMercatorSphere' "
                              "crs='http://www.opengis.net/def/crs/EPSG/0/None>",
      'name': 'Jezero Example Orthos',
      'quadkeys': []}
    
    
    Info for /tmp/jezero_ctx_dtm_py_mosaic.json: 
    { 'bounds': [ 75.91771659930976,
                  14.65135146010114,
                  77.90597708129924,
                  19.777888275132497],
      'center': [76.91184684030449, 17.21461986761682, 0],
      'crs': 'http://www.opengis.net/def/crs/IAU/2015/49900',
      'mosaic_maxzoom': 25,
      'mosaic_minzoom': 9,
      'mosaic_tilematrixset': "<TileMatrixSet title='Mars (2015) - Sphere EN "
                              "MercatorSphere' id='MarsMercatorSphere' "
                              "crs='http://www.opengis.net/def/crs/EPSG/0/None>",
      'name': 'Jezero Example DTMs',
      'quadkeys': []}
    
    


Next we can use the `assets` endpoint for mosaicjson that returns the actual COGs used for a given bounding box that is encoded as part of the url path. In the example below we requested the assets needed for the bounding box with a min longitude of 75 degrees, a max longitude of 76 degrees, a min latitude of 14 degrees, and a max latitude of 16 degrees. As the bounds of the mosaic are largely controlled by one very "long" CTX product, and we placed the bounding box in a corner of the extent where it should only intersect that asset.


```python
r = httpx.get(
    f"{titiler}/mosaicjson/75,14,76,16/assets",
    params = {
        "url": mosaic_hil,
        "coord_crs": 'IAU_2015:49900'
    }
).json()
print(f'Asset Info for {mosaic_hil}: ')
pprint(r, indent=2)
print('\n')
```

    Asset Info for /tmp/jezero_ctx_hillshade_py_mosaic.json: 
    [ 'https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W/P05_002809_1975_XI_17N283W__P13_006000_1974_XI_17N283W_hillshade.tif']
    
    


Next, we will use the `point` endpoint to ask for the assets that would be accessed for a particular coordinate. We will use a longitude and latitude in Jezero Crater near the Three Forks location and the front of the western fan.


```python
lon=77.41359752
lat=18.45369687
r = httpx.get(
    f"{titiler}/mosaicjson/point/{lon},{lat}",
    params = {
        "url": mosaic_dtm,
        "coord_crs": 'IAU_2015:49900',
        "resampling": 'cubic',
        "reproject": 'cubic',
        "bidx": 1
    }
).json()
print(f'Point Info for {mosaic_dtm}: ')
pprint(r, indent=2)
print('\n')
```

    Point Info for /tmp/jezero_ctx_dtm_py_mosaic.json: 
    { 'coordinates': [77.41359752, 18.45369687],
      'values': [ [ 'https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W/P18_007925_1987_XN_18N282W__P19_008650_1987_XI_18N282W_dtm.tif',
                    [-2515.744140625],
                    ['b1']],
                  [ 'https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W/P02_001820_1984_XI_18N282W__P06_003442_1987_XI_18N282W_dtm.tif',
                    [-2495.833740234375],
                    ['b1']],
                  [ 'https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W/N03_063453_1982_XN_18N282W__N03_063519_1982_XN_18N282W_dtm.tif',
                    [None],
                    ['b1']],
                  [ 'https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W/N01_062952_1988_XN_18N282W__N01_062662_1988_XN_18N282W_dtm.tif',
                    [-2539.234375],
                    ['b1']]]}
    
    


# Use in QGIS and Rasterio

Getting to more practical applications, below we demonstrate various ways to use the mosaic.json documents with TiTiler in commonly used analysis software such as QGIS for direct use in a GIS environment like any other geospatial dataset users are familiar with, and Rasterio, a popular python wrapper for the GDAL API. In both cases it is possible to access the full floating point precision data offered by the DTM and Orthoimage ARD COGs in the mosaic without needing to connect to all of the COGs individually or using GDAL's VRT format which doesn't optimize for image overlaps like the mosaic.json format does.


### Generating wms xml files for visualization in QGIS

To view the mosaic.json mosaics in QGIS we will need to use the WMS driver within GDAL, specifically the TMS minidriver to define xml files that point to the mosaic.json document we are interested in viewing and insert other metadata that is needed by hand. Unfortunately there is no automated option currently for generating these yet, but eventually we hope to provide such tools. In the end the XML file tells GDAL how to request tiles correctly from the TiTiler server.

More details about the GDAL WMS driver can be found [here](https://gdal.org/en/stable/drivers/raster/wms.html), but in brief 
the most important parameter is the `<ServerURL>...</ServerURL>` information. There we need to use the `mosaicjson/tiles` TiTiler endpoint to request tiles for the mosaic.json document that we pass in via the `url` parameter. Be aware that running the TiTiler endpoint yourself could cause files to no longer work if the port number for TiTiler changes, but using the USGS TiTiler instance should avoid that issue. The section `${z}/${x}/${y}@1x.{format}` critically defines the schema GDAL will use to make requests for tiles, and the file extension which will be critical for allow us to access floating point data provided by the DTM and Orthoimage mosaics, which will require the use of the `.tif` file extension, also used in the `<ImageFormat>` tag.

Next the `<DataWindow>` needs to be specified to match the information for the TileMatrixSet, which means defining the maximum bounds in the projection (in this case MarsEquidistantCylindricalSphere or IAU_2015:49910) and specifying the tile aspect ratio via the `<TileCountX/Y>` options which here say that our tile grid has twice as many tiles in the X axis as the Y axis. From the prior tutorial on mosaic.json, we used the MarsMercatorSphere TMS to define the mosaic.json file, however there is no requirement that similar mercator projects be used for viewing the mosaic.json document. Although we do not demonstrate it here, it is possible to use other projections and geographic CRSs with this mechanism.

Next we fill out some other important metadata like the tile size via the `BlockSize` parameters, which needs to match the tile size used in the TMS, the band count, and the data type. 

Critically for our DTM and Ortho mosaic products, we will use the `Float32` datatype so that we can get the data at full precision into our visualization in QGIS. However it is also possible to use TiTiler to rescale the data which we will demonstrate in a later section. 

Once these files are created it is possible to simply drag and drop them into a QGIS project to view them. You may notice some initial delay required by the TiTiler server that could last 10s of seconds, but after the map will be usable at typical speeds. You may also have to adjust the styling for the layers if QGIS doesn't respect the data range you specified in the xml files.


```python
%%file jezero_mosaic_json_hillshade.xml
<GDAL_WMS>
  <Service name="TMS">
    <ServerUrl>http://localhost:8080/mosaicjson/tiles/MarsEquidistantCylindricalSphere/${z}/${x}/${y}@1x.jpg?url=/tmp/jezero_ctx_hillshade_py_mosaic.json&bidx=1</ServerUrl>
  </Service>
  <ImageFormat>image/jpg</ImageFormat>
  <DataWindow>
    <UpperLeftX>-10669445.554195119</UpperLeftX>
    <UpperLeftY>5334722.7770975595</UpperLeftY>
    <LowerRightX>10669445.554195119</LowerRightX>
    <LowerRightY>-5334722.7770975595</LowerRightY>
    <TileLevel>14</TileLevel>
    <TileCountX>2</TileCountX>
    <TileCountY>1</TileCountY>
    <YOrigin>top</YOrigin>
  </DataWindow>
  <Projection>PROJCRS["Mars (2015) - Sphere / Equidistant Cylindrical",BASEGEOGCRS["Mars (2015) - Sphere",DATUM["Mars (2015) - Sphere",ELLIPSOID["Mars (2015) - Sphere",3396190,0,LENGTHUNIT["metre",1,ID["EPSG",9001]]],ANCHOR["Viking 1 lander : 47.95137 W"]],PRIMEM["Reference Meridian",0,ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]]],CONVERSION["World Equidistant Cylindrical",METHOD["Equidistant Cylindrical",ID["EPSG",1028]],PARAMETER["Latitude of 1st standard parallel",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Longitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",0,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1,ID["EPSG",9001]]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1,ID["EPSG",9001]]],USAGE[SCOPE["Mars graticule coordinates expressed in simple Cartesian form."],AREA["Whole of Mars"],BBOX[-90,-180,90,180]],REMARK["Use semi-major radius as sphere radius for interoperability. Source of IAU Coordinate systems: doi:10.1007/s10569-017-9805-5"]]</Projection>
  <BandsCount>1</BandsCount>
  <DataType>Byte</DataType>
  <DataValues NoData="0" min="1 1 1" max="255" />
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <MaxConnections>8</MaxConnections>
  <ZeroBlockHttpCodes>204,404</ZeroBlockHttpCodes>
  <ZeroBlockOnServerException>true</ZeroBlockOnServerException>
</GDAL_WMS>

```

    Overwriting jezero_mosaic_json_hillshade.xml



```python
%%file jezero_mosaic_json_ortho.xml
<GDAL_WMS>
  <Service name="TMS">
    <ServerUrl>http://localhost:8080/mosaicjson/tiles/MarsEquidistantCylindricalSphere/${z}/${x}/${y}@1x.tif?url=/tmp/jezero_ctx_ortho_py_mosaic.json&bidx=1&tile_format=tif</ServerUrl>
  </Service>
  <ImageFormat>image/tiff</ImageFormat>
  <DataWindow>
    <UpperLeftX>-10669445.554195119</UpperLeftX>
    <UpperLeftY>5334722.7770975595</UpperLeftY>
    <LowerRightX>10669445.554195119</LowerRightX>
    <LowerRightY>-5334722.7770975595</LowerRightY>
    <TileLevel>14</TileLevel>
    <TileCountX>2</TileCountX>
    <TileCountY>1</TileCountY>
    <YOrigin>top</YOrigin>
  </DataWindow>
  <Projection>PROJCRS["Mars (2015) - Sphere / Equidistant Cylindrical",BASEGEOGCRS["Mars (2015) - Sphere",DATUM["Mars (2015) - Sphere",ELLIPSOID["Mars (2015) - Sphere",3396190,0,LENGTHUNIT["metre",1,ID["EPSG",9001]]],ANCHOR["Viking 1 lander : 47.95137 W"]],PRIMEM["Reference Meridian",0,ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]]],CONVERSION["World Equidistant Cylindrical",METHOD["Equidistant Cylindrical",ID["EPSG",1028]],PARAMETER["Latitude of 1st standard parallel",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Longitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",0,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1,ID["EPSG",9001]]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1,ID["EPSG",9001]]],USAGE[SCOPE["Mars graticule coordinates expressed in simple Cartesian form."],AREA["Whole of Mars"],BBOX[-90,-180,90,180]],REMARK["Use semi-major radius as sphere radius for interoperability. Source of IAU Coordinate systems: doi:10.1007/s10569-017-9805-5"]]</Projection>
  <BandsCount>1</BandsCount>
  <DataType>Float32</DataType>
  <DataValues NoData="-32767.0" min="0.0" max="1.0" />
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <MaxConnections>8</MaxConnections>
  <ZeroBlockHttpCodes>204,404</ZeroBlockHttpCodes>
  <ZeroBlockOnServerException>true</ZeroBlockOnServerException>
</GDAL_WMS>
```

    Overwriting jezero_mosaic_json_ortho.xml


```python
%%file jezero_mosaic_json_dtm.xml
<GDAL_WMS>
  <Service name="TMS">
    <ServerUrl>http://localhost:8080/mosaicjson/tiles/MarsEquidistantCylindricalSphere/${z}/${x}/${y}@1x.tif?url=/tmp/jezero_ctx_dtm_py_mosaic.json&bidx=1&tile_format=tif</ServerUrl>
  </Service>
  <ImageFormat>image/tiff</ImageFormat>
  <DataWindow>
    <UpperLeftX>-10669445.554195119</UpperLeftX>
    <UpperLeftY>5334722.7770975595</UpperLeftY>
    <LowerRightX>10669445.554195119</LowerRightX>
    <LowerRightY>-5334722.7770975595</LowerRightY>
    <TileLevel>14</TileLevel>
    <TileCountX>2</TileCountX>
    <TileCountY>1</TileCountY>
    <YOrigin>top</YOrigin>
  </DataWindow>
  <Projection>PROJCRS["Mars (2015) - Sphere / Equidistant Cylindrical",BASEGEOGCRS["Mars (2015) - Sphere",DATUM["Mars (2015) - Sphere",ELLIPSOID["Mars (2015) - Sphere",3396190,0,LENGTHUNIT["metre",1,ID["EPSG",9001]]],ANCHOR["Viking 1 lander : 47.95137 W"]],PRIMEM["Reference Meridian",0,ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]]],CONVERSION["World Equidistant Cylindrical",METHOD["Equidistant Cylindrical",ID["EPSG",1028]],PARAMETER["Latitude of 1st standard parallel",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Longitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",0,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1,ID["EPSG",9001]]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1,ID["EPSG",9001]]],USAGE[SCOPE["Mars graticule coordinates expressed in simple Cartesian form."],AREA["Whole of Mars"],BBOX[-90,-180,90,180]],REMARK["Use semi-major radius as sphere radius for interoperability. Source of IAU Coordinate systems: doi:10.1007/s10569-017-9805-5"]]</Projection>
  <BandsCount>1</BandsCount>
  <DataType>Float32</DataType>
  <DataValues NoData="-32767.0" min="-10000.0" max="10000.0" />
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <MaxConnections>8</MaxConnections>
  <ZeroBlockHttpCodes>204,404</ZeroBlockHttpCodes>
  <ZeroBlockOnServerException>true</ZeroBlockOnServerException>
</GDAL_WMS>
```

    Overwriting jezero_mosaic_json_dtm.xml


As loading these files is as simple as dragging and dropping the files into the QGIS interface, we will not demonstrate that, but instead we will display some screenshots of the application using the layers.


First let's see the whole extent of the hillshade mosaic.

 {{< figure src="/images/tutorials/mosiac_json_analysis/qgis_zoomed_out_hillshade.webp" alt="A image showing the QGIS window with the full extent of the hillshade mosaic." >}}   

Zooming in we can see more detail at Jezero crater.

 {{< figure src="/images/tutorials/mosiac_json_analysis/qgis_zoomed_in_hillshade.webp" alt="A image showing the QGIS window with the hillshade mosaic zoomed in to Jezero Crater." >}}

Next we can display the ortho image mosaic. Due to the processing of the ortho mosaic products, the brightness of the various images is not uniform resulting in sharp changes where assets overlap

 {{< figure src="/images/tutorials/mosiac_json_analysis/qgis_zoomed_in_ortho.webp" alt="A image showing the QGIS window with the ortho image mosaic zoomed in to Jezero Crater" >}}

The DTM mosaic can be styled using QGIS layer options like any raster dataset, so we used the cividis colormap and scaled the data to the elevation range of -3200m to 0m.

 {{< figure src="/images/tutorials/mosiac_json_analysis/qgis_zoomed_in_dtm.webp" alt="A image showing the QGIS window with the DTM mosaic zoomed in to Jezero Crater" >}}

As QGIS provides powerful features such as on-the-fly contour computation, we can make a copy of the DTM map layer with the contour style applied and see it overlain ontop of the ortho mosaic. Contours are every 50 meters of elevation with index levels every 250 meters in white. 

 {{< figure src="/images/tutorials/mosiac_json_analysis/qgis_zoomed_in_hillshade.webp" alt="A image showing the QGIS window with the ortho image mosaic and overlain contours zoomed in to Jezero Crater" >}}

# Generate WMTS xml files for Rasterio 

In addition to the WMS driver, the WMTS driver in GDAL better supports the TileMatrixSets and follows a very similar XML format to the WMS XML files we created above, however these files don't seem to work in QGIS directly but will work in tools like Rasterio and the GDAL command line. Conversely, the WMS XML files don't seem to work well with Rasterio which benefits from more precise extent information. More information about this driver is available [here](https://gdal.org/en/latest/drivers/raster/wmts.html).

First we will use the `WMTSCapabilities.xml` endpoint from TiTiler to get the `Capabilities` xml documents for the mosaics. These contain metadata including the url GDAL and other tools will use to get tiles internally and the TileMatrixSet. As before we need to adjust the `tile_format` parameter if we wish to access the DTM and Ortho products at their native bit depth.


```python
for mosaic in mosaic_files:
    r = httpx.get(
        f"{titiler}/mosaicjson/MarsEquidistantCylindricalSphere/WMTSCapabilities.xml",
        params = {
            "url": mosaic,
            'tile_format': 'jpg' if 'hill' in mosaic else 'tif',
            'bidx': 1,
        }
    )
    dst_name = mosaic.replace('.json', '_wmst.xml')
    with open(dst_name, 'wb') as dst:
        dst.write(r.content)
    print(f'WMTS for {mosaic} written to {dst_name} ')
    print('\n')
```

    WMTS for /tmp/jezero_ctx_hillshade_py_mosaic.json written to /tmp/jezero_ctx_hillshade_py_mosaic_wmst.xml 
    
    
    WMTS for /tmp/jezero_ctx_ortho_py_mosaic.json written to /tmp/jezero_ctx_ortho_py_mosaic_wmst.xml 
    
    
    WMTS for /tmp/jezero_ctx_dtm_py_mosaic.json written to /tmp/jezero_ctx_dtm_py_mosaic_wmst.xml 
    
    


Although GDAL can partially use these files alone, we need to do additional work similar to the WMS XML we created earlier. First we will need the precise bounds for the mosaics using the `bounds` endpoint in TiTiler.


```python
for mosaic in mosaic_files:
    r = httpx.get(
        f"{titiler}/mosaicjson/bounds",
        params = {
            "url": mosaic,
            "crs": "IAU_2015:49910"
        }
    ).json()
    print(f'Bounds for {mosaic}: ')
    pprint(r, indent=2)
    print('\n')
    bounds = r['bounds']
```

    Bounds for /tmp/jezero_ctx_hillshade_py_mosaic.json: 
    { 'bounds': [ 4499999.688084169,
                  868454.426105146,
                  4617853.226751639,
                  1172328.3451582233],
      'crs': 'http://www.opengis.net/def/crs/IAU/2015/49910'}
    
    
    Bounds for /tmp/jezero_ctx_ortho_py_mosaic.json: 
    { 'bounds': [ 4499999.688084169,
                  868454.426105146,
                  4617853.226751639,
                  1172328.3451582233],
      'crs': 'http://www.opengis.net/def/crs/IAU/2015/49910'}
    
    
    Bounds for /tmp/jezero_ctx_dtm_py_mosaic.json: 
    { 'bounds': [ 4499999.688084169,
                  868454.426105146,
                  4617853.226751639,
                  1172328.3451582233],
      'crs': 'http://www.opengis.net/def/crs/IAU/2015/49910'}
    
    


Now that we know the bounds for the mosaics (of course they would all be the same), we can use these bounds within the `<DataWindow>` block of the `<GDAL_WMTS>` xml object. Below we will create all three files as we've done before, adjusting some parameters as needed for the floating point data.


```python
%%writefile jezero_ctx_hillshade_mosaic_wmts.xml
<GDAL_WMTS>
  <GetCapabilitiesUrl>/tmp/jezero_ctx_hillshade_py_mosaic_wmst.xml</GetCapabilitiesUrl>
  <Layer>default</Layer>
  <Style>default</Style>
  <TileMatrixSet>MarsEquidistantCylindricalSphere</TileMatrixSet>
  <DataWindow>
    <UpperLeftX>4499999.688084169</UpperLeftX>
    <UpperLeftY>1172328.3451582233</UpperLeftY>
    <LowerRightX>4617853.226751639</LowerRightX>
    <LowerRightY>868454.426105146</LowerRightY>
  </DataWindow>
  <Projection>PROJCRS["Mars (2015) - Sphere / Equidistant Cylindrical",BASEGEOGCRS["Mars (2015) - Sphere",DATUM["Mars (2015) - Sphere",ELLIPSOID["Mars (2015) - Sphere",3396190,0,LENGTHUNIT["metre",1,ID["EPSG",9001]]],ANCHOR["Viking 1 lander : 47.95137 W"]],PRIMEM["Reference Meridian",0,ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]]],CONVERSION["World Equidistant Cylindrical",METHOD["Equidistant Cylindrical",ID["EPSG",1028]],PARAMETER["Latitude of 1st standard parallel",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Longitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",0,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1,ID["EPSG",9001]]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1,ID["EPSG",9001]]],USAGE[SCOPE["Mars graticule coordinates expressed in simple Cartesian form."],AREA["Whole of Mars"],BBOX[-90,-180,90,180]],REMARK["Use semi-major radius as sphere radius for interoperability. Source of IAU Coordinate systems: doi:10.1007/s10569-017-9805-5"]]</Projection>
  <BandsCount>1</BandsCount>
  <DataType>Byte</DataType>
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <Cache />
  <UnsafeSSL>true</UnsafeSSL>
  <ZeroBlockHttpCodes>204,404</ZeroBlockHttpCodes>
  <ZeroBlockOnServerException>true</ZeroBlockOnServerException>
</GDAL_WMTS>


```

    Overwriting jezero_ctx_hillshade_mosaic_wmts.xml



```python
%%writefile jezero_ctx_ortho_mosaic_wmts.xml
<GDAL_WMTS>
  <GetCapabilitiesUrl>/tmp/jezero_ctx_ortho_py_mosaic_wmst.xml</GetCapabilitiesUrl>
  <Layer>default</Layer>
  <Style>default</Style>
  <TileMatrixSet>MarsEquidistantCylindricalSphere</TileMatrixSet>
  <DataWindow>
    <UpperLeftX>4499999.688084169</UpperLeftX>
    <UpperLeftY>1172328.3451582233</UpperLeftY>
    <LowerRightX>4617853.226751639</LowerRightX>
    <LowerRightY>868454.426105146</LowerRightY>
  </DataWindow>
  <Projection>PROJCRS["Mars (2015) - Sphere / Equidistant Cylindrical",BASEGEOGCRS["Mars (2015) - Sphere",DATUM["Mars (2015) - Sphere",ELLIPSOID["Mars (2015) - Sphere",3396190,0,LENGTHUNIT["metre",1,ID["EPSG",9001]]],ANCHOR["Viking 1 lander : 47.95137 W"]],PRIMEM["Reference Meridian",0,ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]]],CONVERSION["World Equidistant Cylindrical",METHOD["Equidistant Cylindrical",ID["EPSG",1028]],PARAMETER["Latitude of 1st standard parallel",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Longitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",0,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1,ID["EPSG",9001]]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1,ID["EPSG",9001]]],USAGE[SCOPE["Mars graticule coordinates expressed in simple Cartesian form."],AREA["Whole of Mars"],BBOX[-90,-180,90,180]],REMARK["Use semi-major radius as sphere radius for interoperability. Source of IAU Coordinate systems: doi:10.1007/s10569-017-9805-5"]]</Projection>
  <BandsCount>1</BandsCount>
  <DataType>Float32</DataType>
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <Cache />
  <UnsafeSSL>true</UnsafeSSL>
  <ZeroBlockHttpCodes>204,404</ZeroBlockHttpCodes>
  <ZeroBlockOnServerException>true</ZeroBlockOnServerException>
</GDAL_WMTS>


```

    Overwriting jezero_ctx_ortho_mosaic_wmts.xml



```python
%%writefile jezero_ctx_dtm_mosaic_wmts.xml
<GDAL_WMTS>
  <GetCapabilitiesUrl>/tmp/jezero_ctx_dtm_py_mosaic_wmst.xml</GetCapabilitiesUrl>
  <Layer>default</Layer>
  <Style>default</Style>
  <TileMatrixSet>MarsEquidistantCylindricalSphere</TileMatrixSet>
  <DataWindow>
    <UpperLeftX>4499999.688084169</UpperLeftX>
    <UpperLeftY>1172328.3451582233</UpperLeftY>
    <LowerRightX>4617853.226751639</LowerRightX>
    <LowerRightY>868454.426105146</LowerRightY>
  </DataWindow>
  <Projection>PROJCRS["Mars (2015) - Sphere / Equidistant Cylindrical",BASEGEOGCRS["Mars (2015) - Sphere",DATUM["Mars (2015) - Sphere",ELLIPSOID["Mars (2015) - Sphere",3396190,0,LENGTHUNIT["metre",1,ID["EPSG",9001]]],ANCHOR["Viking 1 lander : 47.95137 W"]],PRIMEM["Reference Meridian",0,ANGLEUNIT["degree",0.0174532925199433,ID["EPSG",9122]]]],CONVERSION["World Equidistant Cylindrical",METHOD["Equidistant Cylindrical",ID["EPSG",1028]],PARAMETER["Latitude of 1st standard parallel",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Longitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",0,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1,ID["EPSG",9001]]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1,ID["EPSG",9001]]],USAGE[SCOPE["Mars graticule coordinates expressed in simple Cartesian form."],AREA["Whole of Mars"],BBOX[-90,-180,90,180]],REMARK["Use semi-major radius as sphere radius for interoperability. Source of IAU Coordinate systems: doi:10.1007/s10569-017-9805-5"]]</Projection>
  <BandsCount>1</BandsCount>
  <DataType>Float32</DataType>
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <Cache />
  <UnsafeSSL>true</UnsafeSSL>
  <ZeroBlockHttpCodes>204,404</ZeroBlockHttpCodes>
  <ZeroBlockOnServerException>true</ZeroBlockOnServerException>
</GDAL_WMTS>


```

    Overwriting jezero_ctx_dtm_mosaic_wmts.xml


#### Loading with Rasterio

Now that we have the three `_wmts.xml` files we can begin to use rasterio to access the data from the mosaics in Python. We will use the `rasterio.open` function (`rio.open`) to open the xml file like any other raster file. The only additional parameter to pay attention to is the `zoomlevel` which is critical for mosaics where if the data was extracted at their native resolution would result in far too many tiles requested of the server for simple previewing. We will set this parameter to 8 and demonstrate what happens when a larger zoom level (more zoomed) query is performed. 

Rasterio will return a numpy array that we can display inline with Pillow.


```python
with rio.open('jezero_ctx_hillshade_mosaic_wmts.xml', zoomlevel=8) as src:
    print(src.width, src.height)
    wmts_hillshade = src.read(1)
Image.fromarray(wmts_hillshade)    
```

    725 1867


 {{< figure src="/images/tutorials/mosiac_json_analysis/hillshade_mosaic_rasterio.webp" alt="A image showing the hillshaded mosaic image as loaded by rasterio." >}}   



For floating point data like the ortho mosaics we will need to use matplotlib to display the data in grayscale.


```python
with rio.open('jezero_ctx_ortho_mosaic_wmts.xml', zoomlevel=8) as src:
    print(src.width, src.height)
    wmts_ortho = src.read(1)
plt.figure(figsize=(5,10), dpi=150)
plt.imshow(wmts_ortho, vmin=0, vmax=1, cmap='gray')
plt.colorbar()
```

    725 1867





    <matplotlib.colorbar.Colorbar at 0x17cca3d70>


 {{< figure src="/images/tutorials/mosiac_json_analysis/ortho_mosaic_rasterio.webp" alt="A image showing the ortho mosaic image as loaded by rasterio." >}}   
    


Next we will do the same request except we will ask for zoom level 9, which will result in 4x the number of pixels, and so will take longer to finish.


```python
with rio.open('jezero_ctx_ortho_mosaic_wmts.xml', zoomlevel=9) as src:
    print(src.width, src.height)
    wmts_ortho = src.read(1)
plt.figure(figsize=(5,10), dpi=150)
plt.imshow(wmts_ortho, vmin=0, vmax=1, cmap='gray')
plt.colorbar();
```

    1448 3733

    
 {{< figure src="/images/tutorials/mosiac_json_analysis/ortho_mosaic_rasterio_zoom_9.webp" alt="A image showing the ortho mosaic image as loaded by rasterio." >}}   


For more proof that the actual floating point data was loaded we can plot a histogram to demonstrate that:


```python
from numpy import linspace
plt.hist(wmts_ortho.ravel(), linspace(0.001,1,100));
```


 {{< figure src="/images/tutorials/mosiac_json_analysis/ortho_mosaic_hist.webp" alt="A image showing the histogram of the ortho mosaic image as loaded by rasterio." >}}   


Next we will load the DTM mosaic with rasterio and display it with matplotlib. Due to some quirks with the GDAL WMTS driver and how empty tiles are handled, we will need to manually map values of `0.0` to the nodata value used of `-32767.0` for the DTM products. We also then reassign those values to `nan` to permit better plotting in matplotlib. We will also plot the DTM with the cividis colormap to illustrate the elevation range in the data.


```python
from numpy import nan
with rio.open('jezero_ctx_dtm_mosaic_wmts.xml', zoomlevel=8) as src:
    print(src.width, src.height)
    wmts_dtm = src.read(1)
    wmts_dtm[wmts_dtm == 0.0] = -32767.0
    wmts_dtm[wmts_dtm  == -32767.0] = nan
plt.figure(figsize=(5,10), dpi=150)
plt.imshow(wmts_dtm, vmin=-3200, vmax=0, cmap='cividis')
plt.colorbar();
```

    725 1867  
    
 {{< figure src="/images/tutorials/mosiac_json_analysis/dtm_mosaic_rasterio.webp" alt="A image showing the DTM mosaic image as loaded by rasterio and plotted to a elevation range of -3200m to 0m." >}} 


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