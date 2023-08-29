---
title: "Kaguya Terrain Camera"
date: 2021-10-10T05:44:09-07:00
weight: 3
draft: false
---

### Access the Data
Data were collected in three observing modes. Each mode is separated into a different collection.
| Observing Mode | Access Mechanism |
| -------------- | ---------------- |
| Monoscopic | [Via a search API](https://stac.astrogeology.usgs.gov/api/collections/kaguya_terrain_camera_monoscopic_uncontrolled_observations/) |
| Monoscopic | [Via a data browser](https://stac.astrogeology.usgs.gov/browser-dev/#/api/collections/kaguya_terrain_camera_monoscopic_uncontrolled_observations) |
| Monoscopic | [Via a web map](https://stac.astrogeology.usgs.gov/geostac/) |
| Stereoscopic | To be released. |
| Stereoscopic| To be released. |
| Stereoscopic | To be released. |
| Spectral Profiler Support | To be released. |
| Spectral Profiler Support | To be released. |
| Spectral Profiler Support | To be released. |

### Overview
The Japan Aerospace EXploration Agency (JAXA) SELenological and ENgineering Explorer (SELENE) mission’s Kaguya spacecraft was launched on September 14, 2007 and science operations around the Moon started October 20, 2007. The primary mission in a circular polar orbit 100-km above the surface lasted from October 20, 2007 until October 31, 2008. An extended mission was then conducted in lower orbits (averaging 50km above the surface) from November 1, 2008 until the SELENE mission ended with Kaguya impacting the Moon on June 10, 2009 \cite{Kato:2010ssr}

Among the multiple instruments onboard Kaguya was the Terrain Camera (TC). The TC was a pushbroom or linescan stereo imager looking ~15° forward and backward (Fig. 1). It acquired each of the paired images one line at a time as the spacecraft moved in its orbit around the Moon. The two images are acquired effectively simultaneously, greatly simplifying the stereogrammetric processing to calculate elevations from the images. The TC was also capable of acquiring only one of the two images in “monoscopic” imaging mode. The camera has a single panchromatic band, using photons between 0.43 to 0.85 um in wavelength to produce the monochromatic (black and white) images. The detectors were both 4096 pixels wide but nominal imaging used 3504 pixels and some images were acquire using only 1752 pixels. From the primary 100-km orbit, the pixels have a 10 m/pixel ground sampling distance; the TC typically produced 35-km wide image strips that were >100 km long. The extended mission has a ~5 – 8 m/pixel ground sampling distance. Since the orbit was polar (90° inclination), the orbit tracks and images are oriented essentially north-south. The orbits were spaced so the sequential images strips would have some modest east-west overlap, allowing a global mosaic to be constructed. During the primary mission over 99% of the lunar surface was mapped in stereo \cite{Haruyama:2012lpsc}.

{{< figure src="/images/data/moon/kaguyatc/viewing_geometry.png" alt="Kaguya TC stereo viewing geometry image." caption="Kaguya TC Stereoscopic observing mode viewing geometry and flight altitude for the nominal mission. Note that flight altitude decreased to ~50km during the extended mission." >}}

Kaguya TC data are released in three distinct collections. The smallest, the monoscopic collection includes observations from the nominal and extended mission that were collected when the sensor was in a monoscopic obseration mode. The stereoscopic collection, which was used to derived lunar topography, includes over 200,000 observations collected while the sensor was in a stereoscopic observing mode. Finally, the spsupport collection includes observations captures as context for Kaguya Spectral Profiler observations. These data have co-registered spot spectrometer observations available via the [JAXA DARTS]( https://darts.isas.jaxa.jp/planet/project/selene/data.html) archive.

The Kaguya Terrain camera imaged over 99% of the lunar surface. As seen in Figure 2 monoscopic data were collected during low illumination, high incidence angle (morning/evening) conditions. Observations collected at these time help accentuate the topographic relief. 

{{< figure src="/images/data/moon/kaguyatc/coverage.png" alt="Image showing nominal and extended mission coverage maps." caption=" Kaguya Terrain Camera coverage maps for stereo and monoscopically collected data. Credit \cite{Sato:2021}." >}}

Data collected during the extended mission generally have a higher ground sample distance (~5-8 m/pixel) due to lower spacecraft orbit (~50km). Unfortunately, these data also have significantly higher orbital errors due to increased spacecraft perturbation, spacecraft attitude control issues, and reduces spacecraft tracking \cite{Goosens:2020}\cite\cite{Goosens:2020}improved the orbital determination of the Kaguya/SELENE spacecraft during much, but not all, of the extended mission from kilometers to tens of meters, resulting in significantly improved geometric accuracy. Users of the dataset are cautioned that the improvements, while tremendous, are not universal and positional errors measurable in kilometers are still present in the data.
### Processing
Data were processed from the level 2B0 archive hosted by DARTS. These data have had (1) dark-level correction, (2) flat-field correction, (3) and a transformation to radiance ($W/m^{2}/μm/sr$) performed before being archived \cite{Haruyama:2008asr}. No radiometric calibration has been performed on the L2B0 data though \cite{Haruyama:2008asr}. provide a description of the processing that could be done.

Across all three collections the L2B0 data are ingested into the Integrated Software for Imagers and Spectrometers (ISIS), version 7.2.0 \cite{isis7.2.0}. During the ingest, DN values identified by the LISM product format description \cite{LISM:2010} as being invalid are mapped to a logical no-data-value. NAIF Spice data are attached to every image, using the improved extended mission kernels \cite{Goosens:2020}, for all data collected during the extended mission. Once ingested, the TC data are map projected to an equirectangular projection (all data between 65˚S / 65˚N) or appropriate polar stereographic (pole centered) projection for data storage. Finally, the Geospatial Data Abstration Library (GDAL) was used to convert the ISIS cube into a Cloud Optimized GeoTIFF (COG) and metadata were generated. These data maintain the 16bit input data type and use a scaling value to convert from the stored DN to radiance.

### Available Assets
- JPEG thumbnail browse image
- 16-bit Cloud Optimied GeoTIFF (COG) with scale and offset defined. Some tools will automatically apply the scale/offset to the pixel value to recover the original DN.
- Provenance tracking the processing done during the creation of the product.
- Original JAXA generated PDS3 label.
### Accuracy, Errors, and Issues
As described above, the extended mission data have been generated using improved orbital information (Spice SPKs). These improvement are large, but do not guarantee inter- or intra-data set alignment. For example, in Figure 3, we illustrate the offsets between the LRO WAC base map and two extended mission Kaguya TC observations. Here we measure an offset of approximately 10km. Offsets at this magnitude are rare, but do exist in the data set.

{{< figure src="/images/data/moon/kaguyatc/offsets.png" alt="Image showing offsets present in some data." caption="Offsets seen between images in the same, extended mission, orbit and a hillshade created from the SLDEM 2015 / LOLA merged product." >}}

### General Usability
These data provide terrific context for other lunar data sets. This includes not only observations from the Kaguya/SELENE Spectral Profiler mission, but also other observing instruments such as the Lunar Reconnaissance Orbiter (LRO) Narrow Angle Camera (NAC). See \cite{Hurwitz:2013, Qiao:2020} for such usages. The stereoscopically collected TC data are terrific candidates for the create of lunar elevation models using tools such as the NASA Ames Stereo Pipeline \cite{Beyer:2018ess}. Additionally, the polar TC data can be of interest for lunar landing and operations (e.g., \cite{Restrepo:2021}). Further, combining these data with other lunar data sets has been used to support geologic mapping efforts (e.g., \cite{Asada:2010}).

Users of these data should be aware of several considerations. First, these data are map projected. It is important to note that map projection inherently alters pixel values. For these products, the default ISIS cubic convolution interpolation was used. This results in the most visually pleasing products but also allows the greatest changes in the pixel values. In areas with sharp contrast the interpolation can produce values that are outside the range of the input pixel values. This is most likely to be an issue in images with steep sun-facing slopes adjacent to dark shadows. In particular, the values in the shadowed regions, which start small, are most susceptible to significant alteration. 

Next, these data are not photometrically or geometrically corrected. The lack of a photometric correction means that observations of the same surface at different times will likely have different observed brightness; no correction for the topography and sun illumination has been applied. We hope to add a photometrically corrected product as an asset in the future. These data are radiometrially corrected. As described above, process to L2B0 includes dark-level and flat-field corrections. Finally, these data are not geometrically corrected. There is neither a guarantee that observations within this dataset will align with one another nor that observations from this dataset will align with other datasets. 

### Related Data

 A wide variety of other lunar data sets can be used in conjunction with these data. The Kaguya / SELENE spacecraft also flow the Multiband-Imager (MI) and Spectral Profiler (SP) instruments. These data sets offer multi- and hyper-spectral observations of the lunar surface with varying swath widths.

 {{< figure src="/images/data/moon/kaguyatc/observing_size.png" alt="Image showing observation widths for different Kaguya instruments" caption=" Kaguya TC, SP, and MI data spatial and spectral coverages. Credit: JAXA https://global.jaxa.jp/press/2007/12/20071214_kaguya_e.html" >}}