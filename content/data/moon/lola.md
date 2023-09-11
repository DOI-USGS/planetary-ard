---
title: "Lunar Orbiter Laser Altimeter (Spot Observations)"
date: 2021-10-10T05:44:09-07:00
weight: 3
draft: false
bibFile: "content/bibliography.json"
---

{{< figure src="/images/data/moon/lola/lola_global_example.jpeg" alt="Image showing interpolated global LOLA." caption="Figure 1: Sample gridded data created using [PDAL](https://pdal.io). A browse thumbnail of each of the 288 tiles was created using QGIS. Artifacts (no data strips) between tiles are a product of the thumbnail creation and not indicative of missing data. Each thumbail is scaled independently, therefore color ramps vary by image tile." >}}

### Access the Data
These data can be accessed in three ways:
- [Via a search API](https://stac.astrogeology.usgs.gov/api/collections/lunar_orbiter_laser_altimeter)
- [Via a data browser](https://stac.astrogeology.usgs.gov/browser-dev/#/api/collections/lunar_orbiter_laser_altimeter)
- [Via a web map](https://stac.astrogeology.usgs.gov/geostac/)

### Overview
This cloud-optimized point cloud release provides data from the Lunar Orbiter Laser Altimeter (LOLA; {{< pcite "Smith:2011" >}}), an instrument on the National Aeronautics and Space Administration (NASA) Lunar Reconnaissance Orbiter (LRO) spacecraft {{< cite "Tooley:2010" >}}. The data consists of over 6.3 billion measurements gathered between July 2009 and February 2023, adjusted for consistency in the coordinate system described below, and then converted to lunar radii {{< cite "Mazarico:2012" >}}. Elevations above the sphere can be computed by subtracting the lunar reference radius of 1737.4 kilometers {{< cite "LROPLGCWG:2008;Archinal:2011;Archinal:2018" >}} from the surface radius measurements.  

The LOLA instrument, as described by {{< pcite "Smith:2011" >}}, is a multibeam laser altimeter that illuminates 5 spots on the ground with each spot having  a 5-meter diameter size (assuming nadir sensor orientation and no surface slope, and the initial nominal 50 km altitude for LRO). The center of each pulse in a 5-spot pulse is separated by approximately 20 m (and with a 5 m spot size, the true distance between spot edges is 10 m). The distance between 5-spot pulses is ~56 m.

The LRO spacecraft has always been in a near-polar orbit. Although the eccentricity of the orbit has changed several times over the mission to its current quasi-stable elliptical orbit varying the height of the spacecraft above the geoid between ~30 km to 200 km. For one year, during LRO’s primary mission phase, the spacecraft flew in a more circular orbit at a nominal height of 50 km above the geoid. 

{{< figure src="/images/data/moon/lola/spot_configuration.png" alt="Image showing LOLA spot configuration." caption="Figure 1: Five 5-pulese records (red boxes), with approximately 56 meters between each 5-pulse group, approximately 20 meters between each sub-pulse in a group. Each sub-pulse has a nominal, 5 meter diameter" >}}

### Processing
The original LOLA data [DOI:10.17189/1520640](https://doi.org/10.17189/1520640) was queried from the Planetary Data System (PDS) Geosciences Node's LOLA RDR Query Tool, Version 2.0. This tool provides access to individual observations from the [original LOLA archive](https://oderest.rsl.wustl.edu/GDSWeb/GDSLOLARDR.html). Data were downloaded in 15˚ x 15˚ (latitude/longitude) tiles. Once downloaded, the shots were converted from comma-separated value (CSV) format to the LAS file format. The LAS files were then compressed and converted to Cloud Optimized Point Cloud (COPC) using the [untwine](https://github.com/hobuinc/untwine) software tool. Once all processing was complete, Spatio-Temporal Asset Catalog (STAC) metadata were created for each tile. These data can and should be queried as a global data set, as tiling is a product of the incremental data download and for storage efficiencies.

#### About the File Formats
"A COPC file is a LAZ 1.4 file that stores point data organized in a clustered octree" (\cite{COPC}). LAZ is a compressed [LAS](https://github.com/ASPRSorg/LAS) file format defined by the ASPRS (American Society for Photogrammetry and Remote Sensing) storing LiDAR data as points. This COPC file uses the ASPRS LAS Point Data version 1.4, Record Format 6. COPC, like cloud-optimized GeoTIFFs, allows for streaming huge point-clouds using simple HTTPS range requests.

#### About the Coordinate Reference System
These data are made available in the 2015 IAU 30100, Moon/Sphere/Ocentric coordinate system, with a center longitude of 0 and a longitude domain of -180˚ to 180˚, referenced to IAU recommended reference ellipsoid (sphere, 1737.400 km). 

The LOLA data were initially referenced to an internally consistent inertial coordinate system, derived from tracking of the LRO spacecraft. By adopting appropriate values for the orientation of the Moon as defined by the International Astronomical Union {{< cite "Archinal:2011" >}}, these inertial coordinates were converted into the body-fixed body-centered (geocentric) XYZ coordinates. The coordinate system defined for this product is the mean Earth/polar axis (ME) system, sometimes called the mean Earth/rotation axis system. The ME system is widely used for cartographic products {{< cite "Davies:2000" >}}. Values for the orientation of the Moon were derived from the Jet Propulsion Laboratory Developmental Ephemeris (DE) 421 planetary ephemeris {{< cite "Williams:2008;Folkner:2009" >}} and rotated into the ME system.

### Available Assets
- COPC file for 15˚ x 15˚ (longitude/latitude) tile.

### Accuracy, Errors, and Issues
The Lunar Orbiter Laser Altimeter (LOLA) aboard the Lunar Reconnaissance Orbiter (LRO) has collected over 6.3 billion measurements. The average accuracy of each point after crossover correction is better than 20 meters (m) in horizontal position and ~1 m in radius/elevation{{< cite "Mazarico:2012" >}}. Note that these reported accuracies and precision are a function of surface slope and roughness. As described by {{< cite "Neumann:2011" >}} accuracy also decreases as the altitude of the spacecraft above the surface exceeds 50 km.  Gaps between tracks of 1–2 km are common, and some gaps of as much as 4 km occur near the equator (as measured in the current data release using QGIS and ellipsoidal distances).

### General Usability
The LOLA data set does not preclude some qualitative issues with the data. First, LOLA data are most dense at the poles and least dense at the equator. The figure below illustrates LOLA equatorial coverage, with gap between LOLA tracks as large as 4 kilometers.

{{< figure src="/images/data/moon/lola/lola_tracks.png" alt="Image showing LOLA tracks near the equator" caption="Figure 2: LOLA spot observations from this data set in the region -2˚ to 2˚N/S, and -2˚ to 2˚E/W. Gaps as large as 4km can be measured between LOLA tracks. While coordinates are stored in spherical degrees (Latitude/Longitude), QGIS uses a 2D equirectangular projection to display the LOLA tracks over an SLDEM2015/LOLA merge hillshade [DOI: 10.17189/1520642](https://doi.org/10.17189/1520642)." >}}

These gaps impact any gridded product that makes use of interpolation/extrapolation for fill. For example, the Figure below, 3, (generated using the [Point Data Abstraction Library](https://pdal.io/) shows both data gaps and telltale interpolation errors. The inset image shows along-track (N/S) striping where the crater rim is most prominent in spot of true data and the true topographic relief is reduced where interpolated. A selected interpolation method should be chosen with care {{< cite "Barker:2016" >}}. 

{{< figure src="/images/data/moon/lola/lola_gridded.png" alt="Image showing LOLA gridded product near the equator" caption="Figure 3: LOLA spot observations, gridded to a DTM, from this data set in the region -2˚ to 2˚N/S, and -2˚ to 2˚E/W. Interpolation artifacts are shown in the sub-image." >}}

The Figure below,4, illustrates this by superimposing the spot observations over the gridded data product.

{{< figure src="/images/data/moon/lola/lola_interpolation.png" alt="Image showing LOLA interpolation." caption="Figure 4: Inset image from Figure 3 showing the interpolation artifacts more clearly. Artifacts between tracks are created by interpolation." >}}

Any user making use of these products to generate gridded Digital Elevation Models (DEMs) must take care to account for and report interpolation related artifacts.

This data product is well suited for use with tools requiring spot elevation information. For example, the NASA Ames Stereo Pipeline {{< cite "Beyer:2018ess" >}}[`pc_align](https://stereopipeline.readthedocs.io/en/latest/tools/pc_align.html) tool can align a stereoscopically generated DTM to a sparse point cloud. These LOLA spot observations are well suited to be used as said reference DTM.

### Related Data
LOLA spot observations are the proxy product for the geodetic coordinate reference frame, [a foundational lunar data product]( https://fdp.astrogeology.usgs.gov/#foundational-data-products). Therefore, all other lunar data products which are geometrically (photogrammetrically and radargrammetrically) controlled should align (within reported errors of the LOLA data and the other data products themselves) with these LOLA spot observations. These spot observations are the inputs used for the derivation of many LOLA and LOLA-merge products. For example, the [LOLA 118 m DEM, DOI: 10.17189/1520642](https://doi.org/10.17189/1520642), [derived hillshades](https://astrogeology.usgs.gov/search/map/Moon/LMMP/LOLA-derived/Lunar_LRO_LOLA_Shade_Global_128ppd_v04),merged [ product, DOI: 10.17189/1520642](https://doi.org/10.17189/1520642). These products were all created using the LOLA spot observations available in this release.

### Cite these data
These data are released under the [CC0-1.0 license](https://creativecommons.org/publicdomain/zero/1.0/), meaning you can copy, modify, and distribution these data without permissions. We ask that you cite these data if you make use of them. The citation to be used is:

> Laura, J.R. and Hare, T.M., 2023. Lunar Orbiter Laser Altimeter (LOLA) Reduced Data Record (RDR) Cloud Optimized Point Cloud (COPC) Data Release. https://doi.org/doi:10.5066/P9V5JIWH

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

### References
{{< bibliography cited>}}