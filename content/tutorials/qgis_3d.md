---
title: "Visualizing CTX DTMs in 3D Using QGIS"
date: 2023-04-26
draft: false
weight: 30
---

 {{< figure src="/images/tutorials/qgis_3d/3d_visualization.png" alt="A PNG showing the final 3d visualization." title="The results of this tutorial, a 3D visualization in Valles Marineris composed of 83 Mars Reconnaissance Orbiter (MRO) Context Camera (CTX) Digital Terrain Models (DTMs)." >}}

In this tutorial, we will:
- searching for CTX DTMs using the [STAC API](https://stac.astrogeology.usgs.gov/api)
- creating a [GDAL Virtual Format](https://gdal.org/drivers/raster/vrt.html) or VRT of a merge of the discovered DTMs
- use the [QGIS hillshade tool](https://www.geodose.com/2020/02/how-to-make-beautiful-hillshading-map-qgis.html) to create a beautiful hillshade of the merged DTMs
- create a 3d interactive visualization using the [QGIS 3d map capabilities](https://opengislab.com/blog/2018/3/20/3d-dem-visualization-in-qgis-30)

This tutorial is linking together a number of other tutorials (linked above), so if you have any issues, check those out or add a question in the comments section at the end. If you have changes you would like to see, consider [submitting them back to the community via a pull request by clicking the "Edit page" link in the top right of this page.

## Prerequisites
This tutorial requires that you have the following tools installed on your computer:

- A [QGIS installation](https://www.qgis.org/en/site/forusers/download.html)
- A [pystac-client installation](https://pystac-client.readthedocs.io/en/stable/); we suggest installing via conda
- A [GDAL installation](https://opensourceoptions.com/blog/how-to-install-gdal-with-anaconda/)

## 1. Search for CTX DTMs
For this tutorial, a region of interest (ROI) around Valles Marineris was selected. This is because quite a few DTMs are in that area and the vertical relief is high. The `pystac-client` library and a simple python script were used to find the 83 DTMs in the ROI.

```python
import pystac_client

# Find all DTMs in the bounding box (bbox)
catalog = pystac_client.Client.open('https://stac.astrogeology.usgs.gov/api')
search = catalog.search(collections=['mro_ctx_controlled_usgs_dtms'],
                        bbox=[-75, -10, -65, -5],
                        max_items=None)

# Get the 'dtm' asset from the item
urls = [item.assets['dtm'].href for item in search.items()]
```

Line by line, this code:

  1. Imports the `pystac_client` library for use.
  1. Creates a [`Client`](https://pystac-client.readthedocs.io/en/stable/api.html#client) object that is the connection to the search API.
  1. Performs a search on the API in the collection named `mro_ctx_controlled_usgs_dtms` and for all data that intersect the bounding box (`bbox`). No limit on the number of returned items is provided.*
  1.  `search.items()` returns a list of [STAC Items](https://developers.planet.com/docs/planetschool/introduction-to-stac-part-1-an-overview-of-the-specification/#STAC-Item). The full line of code uses a [list comprehension](https://www.w3schools.com/python/python_lists_comprehension.asp) to extract the URL of the DTM from the downloadable assets associated with each Item. The end result is a list of URLs to DTMs stored in an S3 bucket.

## 2. Create a GDAL VRT
Next, the discovered DTMs will be merged together into a single file. One could download each DTM locally and then merge them. Because these data are cloud optimized and well suited for streaming, it is more efficient to simply make a virtual file or VRT that points at the source data. The following python snippet creates a VRT.

```python
from osgeo import gdal
# Prepend '/vsicurl/' to all of the URLs for GDAL
urls = ['/vsicurl/' + i for i in urls]

# Build a VRT of the DTMs
gdal.BuildVRT('mydtms.vrt', urls)
```

Line by line, this code:

1. Imports the `gdal` library for use.
1. Prepends every URL in the previously created URL list with `/vsicurl`. The [vsicurl](https://gdal.org/user/virtual_file_systems.html#vsicurl-http-https-ftp-files-random-access) prefix to files tells GDAL to use a remote file accessor to read the files. This prefix allows streaming of the data from a network accessible source to a local computer for visualization and analysis.
1. Build a local, on-disk VRT that be loaded into QGIS and visualized. 

By combining these together, a script can be created to generate a VRT for any ROI. Create a file named `find_dtms_and_make_vrt.py`. Paste the code below into the file.

```python
import pystac_client

# Find all DTMs in the bounding box (bbox)
catalog = pystac_client.Client.open('https://stac.astrogeology.usgs.gov/api')
search = catalog.search(collections=['mro_ctx_controlled_usgs_dtms'],
                        bbox=[-75, -10, -65, -5],
                        max_items=None)

# Get the 'dtm' asset from the item
urls = [item.assets['dtm'].href for item in search.items()]

from osgeo import gdal
# Prepend '/vsicurl/' to all of the URLs for GDAL
urls = ['/vsicurl/' + i for i in urls]

# Build a VRT of the DTMs
gdal.BuildVRT('mydtms.vrt', urls)
```

Then open a terminal and run `python find_dtms_and_make_vrt.py` in the diretory where you saved the script. If you are using conda environments, make sure you have one activated that has `gdal` and `pystac_client` in it. You will know that this step worked because the directory where you ran the script will now contain a file named `mydtms.vrt`.

{{< hint type=tip title="Using a Different ROI" >}}
If you want to reproduce the visualization above, you can use the same ROI. If you are interested in a different region, just alter the bounding box coordinates.
{{< /hint >}}
 

## 3. Create a hillshade in QGIS
This section of the tutorial draws almost entirely from @geomatics and their [QGIS hillshade tool](https://www.geodose.com/2020/02/how-to-make-beautiful-hillshading-map-qgis.html) tutorial. Follow along here or follow the link to their tutorial and come back once you created a colorized hillshade (Figure 9 in the linked tutorial).

First, what is a hillshade? The [USGS Earthquakes Hazards Program](https://earthquake.usgs.gov/education/geologicmaps/hillshades.php) defines a hillshade as: "a technique where a lighting effect is added to a map based on elevation variations within the landscape \[that\] provides a clearer picture of the topography by mimicking the sun’s effects (illumination, shading and shadows) on hills and canyons." Below is a screen capture of the VRT, loaded into QGIS, and visualized over a [MOLA hillshade product](https://astrogeology.usgs.gov/search/map/Mars/GlobalSurveyor/MOLA/Mars_MGS_MOLA_Shade_global_463m). 

As you can see, it is significantly easier to see the topography in the MOLA product than it is in the DTM VRT. Our brains do not easily extract height from intensity values. This is probably because our eyes do not see taller items as being universally brighter in the real world! This is one of the downsides of a DTMs 2.5 dimensional representation of the world.

 {{< figure src="/images/tutorials/qgis_3d/dtm_over_hillshade.png" alt="A screen capture of an 83 DTM VRT overlayed on a MOLA hillshaded product." title="The MOLA shaded relief, or hillshade product provides the background context for this figure. A GDAL VRT containing 83 DTMs is overlayed to illustrate the differences between a DTM, where height is represented by intensity and a hillshade, where height is accentuated by shading caused by an artificially placed light source." >}}

 ### 3a. Load the VRT
 To load the VRT into QGIS:

 1. In the menu bar open the “Layer” menu and choose "Add Raster Layer"
 2. In the "Add Raster Layer" window navigate to the directory where the VRT was created and select it.
 3. Click the "Add" button to add the VRT to the project.

Alternatively, simply drag the VRT from the directory it is saved in into the Table of Contents (lower left side of the QGIS window).

 {{< figure src="/images/tutorials/qgis_3d/load_vrt.gif" alt="A GIF showing how to load a VRT into QGIS." title="A GIF demonstrating loading a VRT into QGIS using the steps enumerated above." >}}

The VRT that was created in the ROI contains 83 DTMs, but only a single layer is added to QGIS. Why is this? The VRT is a virtual mosaic of all of the DTMs and is effectively combined into a single raster layer. Therefore, it is important to note that this product does contain less data than one would have if they loaded in 83 individual DTMs. This produce also inevitably has small discontinuities in the $z$ dimension due to misalignments to MOLA[^1].

### 3b. Create a Hillshade of the DTM
To create the hillshade:
1. Right click on the DTM in the Table of Contents (ToC) and select *Properties*. 
2. In the properties dialog, select *Symbology*.
3. In the *Render type* dropdown, select *Hillshade*.
4. Set the *Z Factor* to 2.5. This applies a 2.5x vertical exaggeration to the DTM which results in a nice looking, albeit artificial final product. 
5. **Optional**: Check the *Multidirectional* box (it makes a more even hillshade with less stark shadows).
6. Change the *Resampling* (Zoomed In and Zoomed Out) to *Bilinear* or *Cubic*

 {{< figure src="/images/tutorials/qgis_3d/create_hillshade.gif" alt="A GIF showing how to create a hillshade using the QGIS symbology dialog" title="A GIF demonstrating creating a pretty hillshade using the DTM VRT." >}}

 If you are interested in all of the other options in the dialog, make sure to checkout [this terrific tutorial](https://www.geodose.com/2020/02/how-to-make-beautiful-hillshading-map-qgis.html).

### 3c. Create a Colorized DEM Layer
The hillshade created above is in grayscale. If you like the look, skip this step. If you like the look of a colorized hillshade, this step is for you. To create the colorized layer:

1. Add the DEM again to QGIS (using the same steps as step 3a) and make sure it is the top layer.
2. Right click on the DTM in the ToC and select *Properties*.
3. In the properties dialog select *Symbology*.
4. In the *Render type* dropdown select *Singleband pseudocolor* (this is the first step that is different than the steps taken to make the hillshade).
5. Choose a color ramp that you like (maybe making sure it is [colorblind safe?](https://colorbrewer2.org/#type=diverging&scheme=BrBG&n=5)) and click *Apply* (to preview) or *Ok* (to close the dialog box).

 {{< figure src="/images/tutorials/qgis_3d/create_colorized_band.gif" alt="A GIF showing how to create a single band colorized layer using the QGIS symbology dialog" title="A GIF demonstrating creating a single band colorized layer using a VRT DTM." >}}

The colorized layer is overlayed with and obscuring pretty the hillshade. To fix this and visually combine the layers:

1. Reopen the *Symology* dialog (steps 2 & 3 above).
2. In the *Blending mode* dropdown select *Multiply*.

Now you should see a colorized layer **and** the pretty hillshade underneath. These are still two layers in QGIS, but are rendering as a colorized hillshade in the main map area.

 {{< figure src="/images/tutorials/qgis_3d/blend_colorized_band.gif" alt="A GIF showing how to blend the single band colorized layer with the hillshade using the QGIS symbology dialog" title="A GIF demonstrating blending the  single band colorized layer with the hillshade." >}}

 ## 4. Create a 3D Map View
 Finally, lets create an interactive 3D map view of the colorized hillshade. This section draws heavily from the terrific tutorial by [Stephanie](https://opengislab.com/about-me) available [here](https://opengislab.com/blog/2018/3/20/3d-dem-visualization-in-qgis-30). To create the visualization:

 1. Open the *View* menu in the top menu bar and select *New 3D Map View*
 2. In the newly opened dialog, click *Configure*.
 3. For the *Elevation* layer select the hillshade created above.

You should now see a 3D visualization of the 83 DTM VRT, streaming off of an offsite S3 bucket. You can pan/zoom this visualization (hold shift to switch between panning and rotating.) You can also grap the whole *Map View 1* window and embed it next to (or above/below) the initial 2D visualization. This way, you can see both the top down view and the 3D (exaggerated *z* dimension) DTM at the same time.

## Conclusion
That's it! You now have a 3D, colorized hillshade to play around with. You also know how to search for DTMs from our [API](https://stac.astrogeology.usgs.gov/api), create a VRT from results, load the VRT into QGIS, and create a very cool looking colorized hillshade. Fun next steps might be to try and render a flyover or add the MOLA shaded relief into the 3D visualization as a background layer.

If you have questions, comments, or a visualization to share, consider chatting below.


## Discuss this Tutorial
{{< comments >}}

-----------------------------------------

### Disclaimers
> Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.

### Footnotes
[^1]: How is it possible that overlapping DTMs are not in perfect alignment? During product generation, each DTM is aligned to MOLA and then groups of DTMs are further aligned. These multiple alignment steps result in very good accuracy to the MOLA point cloud. There are two primary sources of error in this process that result in small misalignments: (1) the MOLA point cloud is sparse and so alignment of a dense DTM point cloud to a sparse MOLA point cloud inevitably has error and (2) each MOLA spot is not an infinitesimally small physical point on the ground, but a large circular polygon. The larger that spot on the surface the more the DTM point can 'bounce' around inside the MOLA spot.