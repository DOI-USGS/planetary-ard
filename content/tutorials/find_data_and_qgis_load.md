---
title: "Search for Data Using Python and Loading Images into QGIS"
date: 2023-04-26
draft: false
weight: 21
---

 {{< figure src="/images/tutorials/search_and_qgis_load/qgis_loaded.png" alt="A PNG showing the 86 color observations loaded into QGIS." title="The results of this tutorial, 86 false color HiRISE images streamed from the Amazon Registry of Open Data into QGIS." >}}

{{< hint type=warning title="Draft" >}}
This is an in progress draft example. Please feel free to test, but use with caution!
{{< /hint >}}

In this tutorial, you will learn how to:
- searching for HiRISE data using the [STAC API](https://stac.astrogeology.usgs.gov/api) in a Jupyter notebook
- subset discovered data based on some criteria
- use the QGIS python terminal to load the discovered data

This tutorial is demonstrating data discovery and visualization. In this tutorial 86 individual images are dynamically streamed into QGIS.

## Prerequisites
This tutorial requires that you have the following tools installed on your computer:

| Software Library or Application | Version Used |
| ------------------------------- | ------------ |
| [QGIS](https://www.qgis.org/en/site/forusers/download.html) | 3.30.1 |
| [pystac-client](https://pystac-client.readthedocs.io/en/stable/) | 0.6.1 |
| [geopandas](https://geopandas.org/en/stable/) | 0.13.0 |
| [pandas](https://pandas.pydata.org/) | 2.0.1 |
| [shapely](https://shapely.readthedocs.io/en/stable/manual.html) | 2.0.1 |

## 1. Setup a Jupyter Notebook
Over Mars Reconnaissance Orbiter (MRO) High Resolution Science Experiment (HiRISE) observations have been [released as Analysis Ready Data]. These data offer a spectacular high resolution view of the surface of Mars. Since it is not realistic to stream every pixel of the over 100 TB of data, the first step is to select a region of interest. For this tutorial, [Gale Crater](https://en.wikipedia.org/wiki/Gale_(crater)) will be the focus.


To start, [launch a jupyter notebook](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/execute.html). In the first cell, all of the necessary libraries will be imported. Copy / paste the following into the first cell.

```python
from pystac_client import Client
import pandas as pd
import geopandas as gpd
from shapely.geometry import shape
pd.set_option("display.max_colwidth", 150)

# set pystac_client logger to DEBUG to see API calls
import logging
logging.basicConfig()
logger = logging.getLogger('pystac_client')
logger.setLevel(logging.INFO)
```

And [execute the cell](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/execute.html#executing-a-notebook).

{{< hint type=Note title="Advanced Feature" >}}
To see the API calls that make this work, adjust the log level (last line above) from `logging.INFO` to `logging.DEBUG`.
{{< /hint >}}

## 2. Connect to the API and Get the Available Collections
Next, setup the connection to the api. In a new cell, below the imports in step 1, paste:

```python
catalog = Client.open("https://stac.astrogeology.usgs.gov/api/")
```

and execute the cell.

The root of the API is a catalog. A catalog contains some number of collections. To see what collections are available, paste the following into the next empty cell:

```python
collections = [(c.id, c.title) for c in catalog.get_collections()]
df = pd.DataFrame(collections, columns=['id', 'title'])
df
```

and execute the cell. 

The result will be a nicely rendered pandas Dataframe with the first column being the name of the collection and the second column being the description as reported by the server. The figure below shows the output that was returned when this tutorial was written.

 {{< figure src="/images/tutorials/search_and_qgis_load/available_collections.png" alt="A PNG showing the collections advertised by the API." title="The results generated when executing the above command. These are the collections that are advertised by the API at the time of writing." >}}

## 3. Search a Collection for Data
The `catalog` object has a `search` method that can be used to search for data in the API. (See the [PySTAC-Client documentation](https://pystac-client.readthedocs.io/en/stable/quickstart.html#python) for more information.) In the next empty cell, paste the following:

```python
results = catalog.search(collections=['mro_hirise_uncontrolled_observations'],
                    bbox=[137.25,-5, 137.5, -4.4], max_items=200)
```

and execute the cell.

This code will search the `mro_hirise_uncontrolled_observations` collection, that contains the MRO HiRISE Reduced Data Record (RDR) observations. The search is constrained to only return items in the bounding box defined by the `bbox` argument. The `bbox` is in the form [`minimum longitude`, `minimum latitude`, `maximum longitude`, `maximum latitude`]. The search is limited to the first 200 returned elements. By default, the search will return 10 elements.

{{< hint type=warning title="API Limits" >}}
The API limits responses to 10,000 items or 500MB of total data returned. This is a hard limited imposed by the backend architecture. In order to return more data, one must use pagination. This is an advanced topic that is described in the [stac-client ItemSearch documentation](https://pystac-client.readthedocs.io/en/stable/usage.html#itemsearch).
{{< /hint >}}

### 4. Convert the API Response into a GeoDataframe  
Data frames are a performant, tabular data structure that is widely used in data science and analysis. What then is a [GeoDataframe](https://geopandas.org/en/stable/docs/user_guide/data_structures.html)? A GeodDataframe is simply a spatially enabled data frame.  By spatially enabling the dataframe one can ask and answer spatial questions such as which observations overlap with other observations. 

The API returns JSON. The following code converts the JSON response into a GeoDataframe.  Into the next empty cell paste:

```python
# Get all items as a dictionary
items_dict = results.get_all_items_as_dict()['features']
for i in items_dict:
    i['geometry'] = shape(i['geometry'])

# Create GeoDataFrame from Items
items_gdf = gpd.GeoDataFrame(pd.json_normalize(items_dict))

print(f"{len(items_dict)} items found")
```

and execute the cell.

The result will be a print out of the number of rows or observations that have been added to the GeoDataframe.

 {{< figure src="/images/tutorials/search_and_qgis_load/togdf.png" alt="A PNG showing the resulting GeoDataframe" title="The results generated when executing the above command. This is a simple print response that 181 observations are in the GeoDataframe." >}}

 ### 5. Plot the footprints
 Because the Geodataframe is sptially enabled, one can plot the footprints. In this region of interest (ROI), there are many footprints. This makes sense because this is a landing site that was heavily imaged. If one were to alter the ROI, the density of footprints would likely be far less.

 To plot the footprints simply paste and execute the following in the next empty cell:

 ```python
 items_gdf.boundary.plot()
 ```

 The results are shown in the figure below.

{{< figure src="/images/tutorials/search_and_qgis_load/footprints_all.png" alt="A PNG showing the discovered footprints." title="The results generated when executing the above command. This is a plot of the footprints of the discovered images." >}}

### 6. Subset for All Color Images
For this tutorial, only the color images will be visualized. To do this, the GeoDataframe will be subset based on the product name. Copy, paste, and execute the following in the next empty cell:

```python
color_gdf = items_gdf[items_gdf['id'].str.contains('COLOR')]
print(f'Found {len(color_gdf)} observations.')
color_gdf.boundary.plot()
```

This code makes a boolean (True, False) mask of the data based on whether or not the `id` contains the string `COLOR`, `items_gdf['id'].str.contains('COLOR')`. The mask is then used to select only the items that contain the string `COLOR`, `items_gdf[MASK]`. Once the dataframe is subset, the footprints are plotted as above. The result is shown below.

{{< figure src="/images/tutorials/search_and_qgis_load/footprints_color.png" alt="A PNG showing the footprints for data with the string COLOR in the id." title="The results generated when executing the above command. This is a plot of the footprints where the data `id` contains the string `COLOR`." >}}

### 7. Generate a list of the Filenames For QGIS 
Unfortunately, QGIS does not have an easy way to bulk load many remote raster datasets. To get the data into QGIS we will make a list of the data and then use the [QGIS python terminal](https://docs.qgis.org/latest/en/docs/user_manual/plugins/python_console.html) to load the layers.

To create the list: copy, paste, and execute the following in the next empty Jupyter notebook cell:

```python
print([('/vsicurl/' + name, id_) for name, id_ in color_gdf[['assets.image.href', 'id']].values.tolist()])
```

This code iterates over all of the rows in the GeoDataframe and extracts the URL for the image (`assets.image.href`) and the item's ID (`id`). When executed, you will see a large blob of text written to the cell's output. The output will start with `[('/vsicurl...` and end with `..._COLOR')]`. In total, this is a list with 86 entries. Each entry contains the URL and the ID. 

Highlight and copy the entire output.

Now open QGIS and select *Plugins* -> *Python Console*. In the console, type: `toload = ` and then paste the copied text. The GIF below demonstrates this.

{{< figure src="/images/tutorials/search_and_qgis_load/toload.gif" alt="A GIF showing the copy/paste of the file list." title="A GIF showing the python console, the creation of the `toload = ` variable and pasting the file list." >}}

Next, paste `layers = [QgsRasterLayer(href, name) for href, name in toload]` into the QGIS python console and execute the code. This code takes a few minutes to run (we are looking into why, but believe it has to do with setting some GDAL environment variables.) This code creates a layer for each of the 86 remote files.

{{< figure src="/images/tutorials/search_and_qgis_load/make_layers.gif" alt="A GIF showing the creation of the layers in QGIS." title="A GIF showing the python console and the creation QGIS layer objects." >}}

Finally, paste `QgsProject.instance().addMapLayers(layers)` into the python console and hit return. Almost immediately, data should start appearing in your QGIS window. The 86 color HiRISE images in our ROI (bbox) are streaming from S3 and loading for visualization and analysis. Since all of the data are present, one can blink them on and off to look for changes, apply different stretches, and perform any other analysis one can think of!

 {{< figure src="/images/tutorials/search_and_qgis_load/qgis_loaded.png" alt="A PNG showing the 86 color observations loaded into QGIS." title="The results of this tutorial, 86 false color HiRISE images streamed from the Amazon Registry of Open Data into QGIS." >}}

## Conclusion
That's it! You now have loaded 86 individual iamges into QGIS. Those data have been discovered using the STAC search API, loaded into a GeoDataFrame, subset based on the observation ID, and finally loaded into QGIS.

If you have questions, comments, or a visualization to share, consider chatting below.

## Discuss this Tutorial
{{< comments >}}

-----------------------------------------

### Disclaimers
> Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.