---
title: "Barker et al. LOLA South Polar Digital Terrain Models"
date: 2026-09-24T05:44:09-07:00
weight: 4
draft: true
bibFile: "content/bibliography.json"
collection: "lro_lola_barker_south_pole_dems"
---

<!--
  DRAFT — not yet in production.
  - draft: true until the release is pushed to the prod stac-server and the DOI is publicized.
  - Figures: add browse imagery under static/images/data/moon/barker_lola_dtms/ and swap the
    placeholder {{< figure >}} block below for real ones (a coverage map + a sample DTM
    hillshade + a slope/total-error example).
  - Accuracy values are taken from Barker et al. 2021 (Planetary and Space Science 203, 105119):
    ~10-20 cm horizontal / ~2-4 cm vertical geolocation per 16x16 km region; median RMS height
    error ~0.30-0.50 m; median RMS slope error ~1.5-2.5 deg. Confirm against the per-site
    total_error / slope_error grids before review if you want site-specific numbers.
  - Cite these data: confirm the ARD release author list (currently "Barker et al.").
  - Mosaic item: PGDA product 81 "South Pole LOLA DEM Mosaic" (87-90 S, 5 m/pix) is planned as
    an additional item in this collection — note it in Overview/Related Data once it is pushed.
-->

### Access the Data
These data can be accessed in three ways:
- [Via a search API](https://stac.astrogeology.usgs.gov/api/collections/lro_lola_barker_south_pole_dems)
- [Via a data browser](https://stac.astrogeology.usgs.gov/browser-dev/#/api/collections/lro_lola_barker_south_pole_dems)
- [Via a web map](https://stac.astrogeology.usgs.gov/geostac/)

{{< figure src="/images/data/moon/barker_lola_dtms/coverage.png" alt="Coverage of the 27 Barker LOLA south polar DTM sites." caption="Figure 1: The 27 Barker et al. LOLA-derived 5 m/pixel south polar DTM sites, shown over a LOLA hillshade. The sites ring the lunar south pole, which is why the collection's longitude extent wraps the antimeridian." >}}

### Overview
This analysis-ready data (ARD) release provides 27 site-level digital terrain models (DTMs) of the lunar south pole derived from the Lunar Orbiter Laser Altimeter (LOLA; {{< pcite "Smith:2011" >}}) by Barker and colleagues. Each DTM is a 5 meter/pixel grid reporting height above the lunar reference sphere, together with companion slope, error, and point-cloud products. The 27 sites are located in and around the permanently shadowed regions of the south pole, including the rims of Shackleton, de Gerlache, Amundsen, Nobile, and Malapert, the Leibnitz beta plateau, the Malapert and de Gerlache-Kocher massifs, and the connecting ridges between them (see the site list in [Available Assets](#available-assets)).

The data were generated from the original LOLA Reduced Data Records (RDRs) made available through the NASA Goddard Space Flight Center Planetary Data Archive (PGDA). The source observations and the derived DTMs are described in {{< cite "Barker:2021" >}}. The DTMs in this release are the final, adjusted products; this release is a packaging and metadata effort that makes those existing DTMs discoverable and usable through the standard ARD access points (search API, data browser, and web map).

The sites are small, high-value regions of the south pole selected for their scientific interest (e.g., potential water-ice deposits in permanently shadowed craters). Because the sites are compact and near-polar, each is represented as a single square grid in south polar stereographic projection rather than as a lat/lon tile.

### Processing
The DTMs were derived from LOLA RDRs by Barker and colleagues using the methodology described in {{< cite "Barker:2021" >}}. The per-site products released here are the final, adjusted outputs of that process. The steps below describe how the existing per-site products were prepared for this ARD release on the USGS Hovenweep supercomputer; they are provided so that the release can be regenerated from the source files.

#### Input Products
For each of the 27 sites, the following input products were available: a height grid (`_surf`), a LOLA count-per-band grid (`_ldec`), a slope grid (`_slp`), a slope error grid (`_slperr`), a total error grid (`_toterr`), a raw point table (`_final_adj.xyzi`), and a set of region-of-interest (ROI) polygons. The height, count, slope, and error grids are single-band, 3200 by 3200 pixel, 5 meter/pixel rasters. The raw point table stores, for each point, the south polar stereographic x and y coordinates, the height above the sphere, and the originating LOLA RDR identifier.

#### Coordinate Reference System
All input grids carry an unnamed south polar stereographic projection referenced to the lunar sphere of radius 1,737,400 meters. During this release each grid was assigned the IAU 2015 code **30135** (Moon (2015) - Sphere / South Polar), which is the south polar stereographic system with a center latitude of -90 degrees and a center longitude of 0 degrees. This step forces a proper, named coordinate reference system so that the products are correctly described by their metadata.

#### Raster Preparation
Each of the five input grids (height, count, slope, slope error, and total error) was written as a Cloud Optimized GeoTIFF (COG) preserving the original 32-bit floating point (Float32) data type, with DEFLATE compression and BigTIFF enabled. A hillshade was derived from the height grid using a sun azimuth of 315 degrees and a sun altitude of 45 degrees, and was also written as a COG. A small JPEG browse thumbnail was generated from the height grid.

#### Point Cloud
The raw point table (XYZI format) for each site was converted to a compressed LAZ point cloud (LAS 1.4). The source coordinates are stored in kilometers and were scaled to meters during conversion. Because the originating LOLA RDR identifiers exceed the range of the standard 16-bit point source id, they are carried in an additional `RDR_ID` dimension so that any point can be traced back to its source observation. The LAZ is tagged with the IAU 2015 code 30135.

#### Footprints
The geographic footprint (extent) of each STAC item was derived from the site's region-of-interest polygons, unioned and expressed in the IAU 2015 code 30100 (geodetic latitude/longitude) system. For the four sites where the ROI polygons were available, the footprint is the union of those polygons. For the remaining 23 sites the ROI polygons were not available at the time of this release, so the footprint is the georeferenced extent of the height grid itself. This means 23 of the 27 footprints are square raster boxes rather than the irregular ROI shapes.

#### Metadata and Quality Assurance
Spatio-Temporal Asset Catalog (STAC) metadata were generated for each site using the automated metadata generation (amg) library, combining the raster metadata of the height grid, the footprint geometry, and release-level overrides (including the projection code and the data citation). Each item was validated before release: the file count per site, the coordinate reference system of the height grid, a read-back of the LAZ point cloud (point count, the `RDR_ID` dimension, and that coordinates fall within the stated bounds), and the STAC item (projection code, collection, asset count, and that each asset link resolves).

### Available Assets
Each of the 27 sites is a separate STAC item. The 27 sites are: Site01 (Connecting ridge), Site04 (Shackleton rim), Site06 (Nobile rim 1), Site07 (Peak near Shackleton), Site11 (de Gerlache rim), Site20 and Site20v2 (Leibnitz beta plateau; v2 has extended boundaries), Site23 (Malapert massif), Site42 (de Gerlache-Kocher massif), Haworth, Shoemaker, DM1 (Amundsen rim), DM2 (Nobile rim 2), SL2 (de Gerlache rim), SL3 (Connecting ridge extension), NPA (Cabeus exterior wall 1), NPB (Amundsen 1), NPC (Idel'son L crater 1), NPD (Malapert crater 1), LM1 (Shackleton Rim B), LM2-LM6 (Shoemaker Rim A-E), LM7 (Faustini Rim A), and LM8 (Shoemaker Rim F).

The assets available for each site are:
- Digital Terrain Model (DTM) reporting height above the lunar reference sphere in meters, as a Cloud Optimized GeoTIFF (COG), Float32, 5 m/pixel
- LOLA count per band, as a COG (the number of contributing LOLA observations per pixel)
- Slope, as a COG
- Slope error, as a COG
- Total error, as a COG
- Hillshade derived from the DTM, as a COG
- Compressed LAZ point cloud (LAS 1.4) with the originating LOLA RDR identifier carried in an `RDR_ID` dimension
- JPEG browse thumbnail of the DTM hillshade
- A provenance file recording the processing commands used to produce the product

### Accuracy, Errors, and Issues
The DTMs in this release are the final, adjusted products of Barker et al. {{< cite "Barker:2021" >}}. In that work the individual LOLA tracks were iteratively adjusted to the LOLA-based digital elevation model (LDEM) in a self-consistent fashion, reducing the orbital geolocation errors by more than a factor of ten. As a result, the new ground-track geolocation uncertainty is on the order of 10 to 20 centimeters horizontally and 2 to 4 centimeters vertically over each 16 by 16 kilometer region. The LDEM surface height and slope uncertainties have typical (median) RMS values of approximately 0.30 to 0.50 meters and 1.5 to 2.5 degrees, respectively. These values assume a fractal behavior for the short-scale topography when estimating the interpolation error, and they account for the reduced orbital errors.

Two companion error products are provided with each DTM so that users can assess fitness for use locally. The **total error** grid reports the estimated total surface height uncertainty of the DTM at each pixel. The **slope error** grid reports the estimated slope uncertainty at each pixel. Because the uncertainty in a laser altimeter DTM increases with surface slope and roughness, and because the per-site values vary, these grids should be consulted for any use case that depends on the absolute or relative accuracy of the elevation or slope. Users are encouraged to visualize the total error product in a GIS over their region of interest and to assess whether the error is acceptable for the intended analysis. Barker et al. {{< cite "Barker:2021" >}} also show how these height uncertainties propagate to near-field horizon elevation and thus to predicted illumination conditions, which is the primary motivation for these south polar products.

Known issues:
- The footprints of 23 of the 27 sites are the square extent of the height grid rather than the irregular region-of-interest shape, because the ROI polygons for those sites were not available at the time of this release (see [Processing](#processing)). The data themselves are unaffected; only the stated extent is a bounding box.
- The grids report height above the lunar reference sphere (radius 1,737,400 m) and are not geoid-adjusted.
- The source 5 m/pixel LDEM is sparse near the south pole (data in only a fraction of pixels), so the gridded products involve interpolation between laser returns. Users deriving additional products (e.g., further mosaics) should account for and report any interpolation-related artifacts.

### General Usability
These data provide high-resolution (5 m/pixel) topography of 27 selected south polar sites, with companion slope and error products and the underlying point cloud. They are well suited for detailed analysis of the permanently shadowed regions and their rims, for engineering and landing-site studies, and as a high-resolution reference for aligning other south polar products.

Users should consider the following. First, the products are in south polar stereographic projection (IAU 2015 code 30135), not geodetic latitude/longitude. Tools that assume a geographic (lat/lon) coordinate system will need the data reprojected. Second, the error products (total error and slope error) are the authoritative guide to local accuracy; a low mean error does not guarantee that a sub-region is fit for a given purpose, so the error grids should be inspected spatially. Third, the LAZ point cloud carries the originating LOLA RDR identifier in the `RDR_ID` dimension, which can be used to trace any point back to its source observation in the PGDA archive.

These DTMs are a higher-resolution, site-specific complement to the global [LOLA spot observations](lola.md) and the near-global [Kaguya TC USGS DTMs](kaguyatc_dtms.md) described in the related data section.

### Related Data
Several analysis-ready data sets are directly related to these DTMs. First, the [Lunar Orbiter Laser Altimeter (LOLA) spot observations](lola.md) are the same instrument's global point cloud, in geodetic coordinates, and are the foundational lunar reference data product; these Barker DTMs are a higher-resolution, site-specific derivation of the same LOLA measurements. Second, the [Kaguya Terrain Camera USGS Generated DTMs](kaguyatc_dtms.md) provide near-global, medium-resolution lunar topography that can be used alongside these higher-resolution south polar products. Third, the [Kaguya Terrain Camera](kaguyatc.md) observations provide the at-resolution imagery for the broader lunar surface. A south pole LOLA DEM mosaic (87-90 degrees south, 5 m/pixel) is also planned to be added to this collection as an additional item, providing a continuous regional context for the individual sites.

### Cite these data
These data are released under the [CC0-1.0 license](https://creativecommons.org/publicdomain/zero/1.0/), meaning you can copy, modify, and distribute these data without permission. We ask that you cite these data if you make use of them. The citation to be used is:

> Barker, M.K., Mazarico, E., Neumann, G.A., Smith, D.E., Zuber, M.T., Head, J.W., 2021. Improved LOLA elevation maps for south pole landing sites: Error estimates and their impact on illumination conditions. Planetary and Space Science 203, 105119. [https://doi.org/10.1016/j.pss.2020.105119](https://doi.org/10.1016/j.pss.2020.105119)

For this analysis-ready data release specifically, please also cite:

> Laura, J.R., 2026. Barker et al. Improved LOLA Elevation Maps, Analysis Ready Data Release. [https://doi.org/10.5066/P13YV93V](https://doi.org/10.5066/P13YV93V)

Please also consider citing the source LOLA data {{< cite "Smith:2011" >}}.

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
