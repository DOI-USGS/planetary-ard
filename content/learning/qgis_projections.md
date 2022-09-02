---
title: "QGIS Projections"
date: 2021-12-15T06:18:10-07:00
draft: true
---

{{% notice warning %}}
This is a draft learning page.
{{% /notice %}}

### Where to find projection strings
Finding projection information is also quite easy. The [spatialreference.org](http://spatialreference.org) website records thousands of spatial reference systems in a myriad of formats (OGC WKT, ESRI WKT, PROJ, etc.) For example, if one wished to find lunar coordinate reference systems (CRSs), use the search capability to find 'Moon'. This returns both spherical (e.g., Moon 2000) and rectangular (e.g., Moon Equidistant Cylindrical) coordinate reference systems.

Each subpage then provides the CRS string in a number of different formats. For use in QGIS, the OGC WKT string or Proj4 string are need. The former is preferred. 

### Adding a custom projection to QGIS
In QGIS, use the menu bar to open `Setting->Custom Projections...`.

![Add a custom projection](/images/learning/qgis_projections/qgis_add_custom_projection.png)

Now name the projection Moon2000 and paste the above WKT projection string into the Parameters box. Select 'Validate' if you like and then click Ok.

![Define projection](/images/learning/qgis_projections/qgis_moon2000.png)

The QGIS installation on your computer now has a custom Moon2000 projection! The final step is to set the project to use the custom coordinate reference system (CRS). From the menu bar, select `Project->Properties`. In the left hand TOC ensure that `CRS` is the selected page and then filter and search for Moon2000. Just before hitting 'Ok', the Project Properties - CRS window should look like the screen capture below.

![Set project projection](/images/learning/qgis_projections/qgis_set_projection.png)