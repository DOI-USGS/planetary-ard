---
title: "Adding USGS WMS Base Layers to QGIS"
date: 2023-05-14T07:32:40-07:00
draft: false
weight: 30
---

{{< figure src="/images/tutorials/qgis_add_wms/europa_wms.png" alt="A screen capture of the Europa WMS." title="The USGS provided Europa Global Mosaic, loaded as a WMS." >}}

{{< hint type=warning title="Draft" >}}
This is an in progress draft example. Please feel free to test, but use with caution!
{{< /hint >}}

In this tutorial, you will learn how to:
- Add a connection to the USGS Europa WMS server
- add the Europa Global Mosaic WMS base layer to a QGIS project

This tutorial demonstrates how to connect the the USGS Astrogeology hosted Web Mapping Standard (WMS) server and stream a base layer into QGIS.

## Prerequisites
This tutorial requires that you have the following tools installed on your computer:

| Software Library or Application | Version Used |
| ------------------------------- | ------------ |
| [QGIS](https://www.qgis.org/en/site/forusers/download.html) | 3.30.1 |

## WMS URLs
The table below lists URLs for WMS layers for bodies that have analysis ready data available. For a complete listing see [here](https://astrowebmaps.wr.usgs.gov/webmapatlas/Layers/maps.html)

| Body | URL |
| ---- | --- |
| Europa | https://planetarymaps.usgs.gov/cgi-bin/mapserv?map=/maps/jupiter/europa_simp_cyl.map |
| Mars | https://planetarymaps.usgs.gov/cgi-bin/mapserv?map=/maps/mars/mars_simp_cyl.map |
| Moon | https://planetarymaps.usgs.gov/cgi-bin/mapserv?map=/maps/earth/moon_simp_cyl.map |

## Add a Connection to the USGS Europa WMS
To add a custom projection QGIS:

1. In the data source *Browser* (left side of the QGIS interface, above the Table of Contents) right click the *WMS/WMTS* section and select *New Connection...*
2. Name the connection *USGS Europa*
3. Paste the URL from above for the Europa WMS.
4. Click *Ok*

{{< figure src="/images/tutorials/qgis_add_wms/add_wms.gif" alt="A GIF showing how to connect to a WMS server." title="A GIF demonstrating creating a new WMS connection." >}}

### Add the Europa Global Mosaic to QGIS
To add the WMS to the project:

1. In the data source *Browser* expand the *WMS/WMTS* section and locate the *USGS Europa* connection added above.
2. Expand the drop downs until *Europa Global Mosaic* is visible.
3. Double click the *Europa Global Mosaic* layer or right-click and select *Add Layer to Project*.

{{< figure src="/images/tutorials/qgis_add_wms/add_layer.gif" alt="A GIF showing how to add a WMS base layer" title="A GIF demonstrating a WMS base layer to a QGIS project." >}}

## Discuss this Tutorial
{{< comments >}}

-----------------------------------------

### Disclaimers
> Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.