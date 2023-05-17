---
title: "Mars Reconnaissance Orbiter (MRO) High Resolution Science Experiments (HiRISE) Uncontrolled Observations"
date: 2023-04-21T05:44:09-07:00
weight: 3
draft: false
bibFile: "content/bibliography.json"
---

### Access the Data
These data can be accessed in three ways:
- [Via a search API](https://stac.astrogeology.usgs.gov/api/collections/mro_hirise_uncontrolled_observations/)
- [Via a data browser](https://stac.astrogeology.usgs.gov/browser-dev/#/api/collections/mro_hirise_uncontrolled_observations)
- [Via a web map](https://stac.astrogeology.usgs.gov/geostac/)
 
### Overview
The High Resolution Imaging Science Experiment (HiRISE) is an imaging system on board the Mars Reconnaissance Orbiter (MRO) and is described in detail by {{< cite "McEwen:2007" >}}. We provide a basic description below. HiRISE is a “pushbroom” camera that builds up images of the surface by collecting data along a line of detectors as MRO moves in its orbit. Unlike classic line-scan cameras with a single row of detectors, HiRISE uses Time-Delay Integration (TDI) and integrates signal from up to 128 rows for better signal-to-noise ratio. 

The HiRISE focal plane includes fourteen CCD (charge-coupled device) detectors. Each individual CCD is 2048 pixels wide and 128 high (along-track) for TDI imaging. Ten of these CCDs have a broad filter generally referred to as the RED channel as the center wavelength is in the red part of the visible-light spectrum. The CCDs are not quite in a line, allowing the ends of the detectors to be overlapped and avoid coverage gaps. In most but not all cases, all CCDs are used for each observation; sometimes CCDs are turned off to reduce data volume, and CCD RED9 (on the western edge of the swath) has been inoperable since August 2011. 

Four additional CCDs are aligned with the two center RED CCDs and provide additional spectral information with blue-green (BG) and near-infrared (NIR) filters. Thus, the central ~20% of a typical image is in three colors. The RED products consist of all the red-channel CCDs, mosaicked together. The COLOR products consist of the six CCDs of the central swath, with NIR data assigned to the red color band, RED data assigned to the green color band, and BG data assigned to the blue color band, and thus are “enhanced” or “false” color. 

The CCDs can be commanded independently with different pixel scales and numbers of TDI lines, depending on various constraints. However, the most common modes have the RED CCDs in bin-1 or bin-2 mode, and the BG and NIR in bin-2 or bin-4. The binned modes improve signal-to-noise ratios at the cost of reduced resolution by summing 2x2 or 4x4 pixel areas. The pixel scale of raw bin-1 data is 25-30 cm depending on the position of MRO in its orbit. Typical RED products, once fully mosaicked, are 5-6 km wide (across-track, approximately east-west at low latitudes), and 10-20 km long, although lengths are highly variable. 

The Sun-synchronous orbit of MRO ensures that all images are acquired near 3 PM local time. This makes the lighting somewhat consistent, although at different latitudes and seasons the illumination at 3 PM varies substantially.  

The Reduced Data Records (RDRs) produced by the HiRISE team (NASA/JPL/University of Arizona) are described by {{< cite "Eliason:2007" >}} and {{< cite "McEwen:2010" >}}. They are radiometrically calibrated, and map-projected and orthorectified onto a smoothed version of the Mars Orbiter Laser Altimeter global Digital Terrain Model. They are created as losslessly-compressed JPEG2000 (JP2) files. The standard RDR map projections are equirectangular with a variable standard parallel at latitudes between 65ºS – 65ºN, and polar stereographic at higher latitudes. RDRs for images with bin-1 data are created at 25 cm/pix, while bin-2 and bin-4 data are at 50 cm/pix and 1 m/pix.   

This analysis-ready data set is derived from the RDRs (as of March 2023). The JP2s have been converted to Cloud-Optimized Geotiffs (COGs), and the non-polar observations have been reprojected to all use a latitude of true scale standard at the equator. The latitude of true scale defines where scale is not distorted. Additional technical details on the HiRISE instrument and RDR data processing are available in {{< cite "McEwen:2007;McEwen:2010" >}} and the Software Interface Specification documents {{< cite "Eliason:2007;Eliason:2012" >}}. Key points for users to be aware of are described below. However, this is only a brief introduction to the nature of this complex data set. 
### Processing
Data in this collection were processed from the HiRISE Team Reduced Data Record (RDR) release. The RDR data products are fully described by Eliason, et al. 2012. In brief, the input data are map projected and radiometrically corrected images released to the PDS in the JPEG2000 format. The RDR products are released using an equirectangular (where the latitude of true scale is binned every 5-degrees, e.g., 0, ±5, ±10, …, ±60), north-polar centered stereographic, or south-polar centered stereographic projections, as appropriate based upon the data coverage.

For this release, we take the RDR data, fix known issues with a subset of the JPEG2000 headers and convert into a 16-bit, uncompressed GeoTIFF. Once converted, the data, still projected in their original equirectangular using 5°-bins of latitude, are reprojected to a globally centered equirectangular projection (also known as simple cylindrical), where both the latitude of true scale and the central meridian are set to 0. All data are then assigned OGC adopted planetary spatial reference systems (SRS). These are:


- Mars (2015) – Sphere / Ocentric / Equirectangular, clon=0; 49910
- Mars (2015) – Sphere / Ocentric / North Polar; 49930
- Mars (2015) – Sphere / Ocentric / South Polar; 49935

Next, the data are converted to losslessly compressed Cloud Optimized GeoTIFF. These data have the corrected digital number (DN) scale and offset parameters assigned as metadata and can be used for scientific analysis in tools (e.g., ArcGIS or QGIS) that read and apply the offset (see more below). Finally, a browse thumbnail is created, and SpatioTemporal Asset Catalog (STAC) metadata are generated to support data discovery.

### Available Assets
- JPEG thumbnail browse image
- 16bit Cloud Optimized GeoTIFF image with scale and offset define which can be used to recover the original calculated reflectance (intensity/flux, or I/F) for scientific analysis. 
- Provenance tracking the processing done during the creation of the product
- PDS 3 Label of the original RDR data product

### Accuracy, Errors, and Issues
HiRISE RDRs and these ARD products are orthorectified to a smoothed version of the MOLA global DTM with positioning based on the initial reconstructed spacecraft position information from MRO {{< cite "McEwen:2010" >}}. They are not absolutely controlled to any other high-resolution data. This has two effects on the geospatial accuracy of the data. First, the absolute position is only known to within a few hundred meters. Images of the same location taken at different times may appear offset by tens to hundreds of meters. However, RED and COLOR observations acquired as part of the same observation are processed to register pixel-to-pixel. Second, orthorectification to the smoothed MOLA DTM removes very-long-baseline topographic distortions but leaves those due to smaller-scale topography. Therefore, there is parallax distortion in the images. In other words, a feature can be distorted because it is viewed from an angle. This effect is more severe for images acquired with larger off-nadir rolls and is most important in the cross-track direction since rolls are always approximately cross-track.  
 
Pixel values are given in digital numbers (DNs). In the RDRs, these are in the range 3-1021, with the values 0-2 and 1022-1023 representing various forms of saturation or otherwise invalid pixel values. In the analysis-ready data products, all these special pixel values have been redefined as 0 and set to nodata in the COG’s metadata. 
 
The DN in these data can be converted to a quantitative measure of reflectance (intensity/flux, or I/F) using the COG’s SCALE and OFFSET keywords. HiRISE radiometric calibration {{< cite "Becker:2022" >}} is estimated to have an absolute accuracy of ~20% and a relative accuracy within a single image of 1% {{< cite "Milazzo:2015" >}}. Changes in the camera over time may somewhat reduce the accuracy of the calibration as implemented in current processing. There are several additional important issues for quantitative I/F analysis discussed in the [General Usability](#general-usability) section below. 
 
A variety of errors or artifacts can be found in HiRISE data as well. Most obviously, many images have gaps or missing channels which appear as rectangular patches of missing data. These generally arise because of data dropouts during transmission, for instance due to bad weather at the ground station on Earth. These can also result in strange features in COLOR products where one or two color channels have valid data over an area while the others have nodata. Depending on the program used for display, these areas may appear to lack data or have unusual colors since one channel lacks valid data, but the others can be seen when individual bands are inspected or queried.   
 
Another common artifact arises at the boundaries between data from different CCDs. These CCDs are mosaicked in the RDR products by aligning the narrow overlap areas, but the alignment is not always perfect and can result in discontinuities, typically of no more than a few pixels. These discontinuities can easily be identified since they are linear and aligned with the direction of the image.      
 
HiRISE has had issues with bit flips, described by {{< cite "McEwen:2010" >}}, which have grown more common over time.Lesser forms of this issue add noise to images. In more severe instances, the bit flips may completely destroy the surface signal and appear as nodata pixels which may appear unusual in COLOR products. These can be widespread in severe cases. 
 
“Furrows” are another artifact found in linear areas along the center of individual CCDs where signal was too high, and result in discontinuous linear stripes of nodata where the furrowed line passes over bright surfaces. 
 
Smearing can occur if some motion on the spacecraft affected the uniform down-track advance rate required for TDI and accurate line-scan imaging. This usually results in cross-track bands of smeared pixels, which can be particularly obvious in COLOR products because the data from the three color channels is acquired at slightly different times and thus different parts of the surface are smeared in different colors. Somewhat similar effects can result from moving features on Mars: color fringes sometimes appear in dust devils or avalanche clouds, and have been used to measure their velocity {{< cite "Russell:2008" >}}.

A variety of other issues and artifacts may be found in some data. Pattern noise (regular patterns) and other electronic artifacts occasionally occur and are most visible in smooth, bland areas. Some images from 2017-2018 are blurred {{< cite "McEwen:2018" >}}. This blurring was eventually mitigated by more effective warming of the focal plane electronics. Cosmic ray hits on the CCD detectors can also create artifacts in the form of few-pixel bright features.   
### General Usability
The most straightforward use case for these analysis-ready products is for qualitative interpretation of the geology and geomorphology of Mars. HiRISE has better spatial resolution than any other past or present camera in Mars orbit and a very high signal-to-noise ratio. In most cases, where HiRISE data exist, they are the best-quality imaging data available. 

The products can also be used for quantitative analysis (such as measuring areas or distances) in many cases. There is always some geometric distortion from uncorrected parallax and incomplete orthorectification as discussed above, which is worst in areas of steep local topography; however, for many use cases and many images, this effect is small enough that useful measurements can be made. 

Images can also be registered with each other or with other data, for instance in Geographic Information System (GIS) software. Because of the incomplete control and orthorectification of these data (and because other data may be projected or orthorectified differently), pixel-level alignment is unlikely, and even translating or warping different data sets may not be able to achieve it except in small areas. 

Another use case when using multiple images is searching for changes on Mars. Mars is an active planet, especially when inspected at HiRISE scales {{< cite "Dundas:2021" >}}, and many HiRISE images are targeted specifically to look for such changes. However, apparent changes can also result from different lighting conditions, changes in the atmospheric opacity, or simply differences in the image stretch or radiometric calibration quality. In general, apparent changes that are widespread and/or diffuse are less likely to indicate real changes on the surface, although this can result from aeolian processes. Discrete, localized differences are more likely to be real changes, especially when the image lighting and viewing angles are well-matched and different surface features can be positively identified. Candidate changes generally must be assessed individually based on such factors. Changes are most easily found when images are well-registered. 

 
Users interested in quantitative analysis of I/F values should be aware of several factors that may make these products unsuitable depending on their specific goals:
- These are “top-of-atmosphere” values. In other words, they are the ratio of the energy received by HiRISE (above the atmosphere) to the solar radiation incident on Mars at the top of the atmosphere. The actual reflectance of the surface materials will be different because both incoming and outgoing light is partially scattered by dust (and sometimes clouds) in the atmosphere. The signal in a single pixel of a HiRISE observation is a combination of direct and scattered light reflected from the surface, incoming light reflected directly from the atmosphere, and light reflected from the surface and then scattered within the atmosphere, and therefore not the same as the reflectance that would be measured at the surface. Scattered light allows details to be seen in shadows. Atmospheric scattered light is also redder than direct light {{< cite "Thomas:1999" >}}, so its proportion affects apparent color. Thus, independent in the uncertainty of the absolute calibration, the brightness of a surface feature can change because the atmosphere changed between images. In most (but not all) cases, the atmospheric effects are effectively uniform within a single HiRISE image. 
- The RDRs include clipping of pixel values at the extremes, with the lowest value assigned to the minimum brightness of a 9x9 pixel down-sampled area, which can be particularly important for spectral ratios {{< cite "Rangarajan:2023" >}}. Additionally, the RDRs undergo a resampling during map projection, and the analysis-ready products between 65ºS–65ºN have a further resampling due to the change in map projection. Each resampling reduces the quantitative accuracy of each pixel. Color products also have additional filtering and resampling to match the BG and IR data (which are normally binned) to the RED {{< cite "McEwen:2010" >}}, which affects the ability to quantitatively assess color of single pixels. 
- The point-spread function of the HiRISE optics has a full-width half-maximum of 1.5 pixels, and time-delay integration also has the effect that the values in a given pixel include some contribution of light from adjacent pixels {{< cite "McEwen:2007" >}}. 
- The I/F values do not include any correction for surface topography. One pixel may be darker than another because it is naturally darker material, or because it is tilted away from the Sun. 

Thus, while the quantitative I/F values are physically meaningful, they do not directly measure the reflectance of surface materials. They are most appropriate for relative brightness comparisons within a single image for surfaces with similar slope and orientation. Quantitative analysis of color ratios is not recommended with these analysis-ready products.         

Although stereogrammetry allows derivation of DTMs from pairs of HiRISE images {{< cite "Kirk:2008" >}}, use of parallax or stereo analysis to infer topographic relief is not recommended with these data, because the orthorectification of the RDRs to the smoothed MOLA DTM removes the long-baseline component of the topography.  
 

### Related Data
A wide variety of additional data sets can be analyzed with HiRISE. The most closely related are data from the Compact Reconnaissance Imaging Spectrometer for Mars (CRISM; {{< cite "Murchie:2007" >}}) and the Context Camera (CTX; {{< cite "Malin:2007" >}}). CRISM is a hyperspectral imaging spectrometer with spectral channels covering visible and near-IR wavelengths and a pixel scale as small as 18 m for local areas, and CTX is a monochromatic imager with near-global coverage at 6 m/pix. Both instruments are onboard MRO with HiRISE and in many cases, data products covering the same area were collected simultaneously by two or three of the instruments as coordinated observations. The coordinated observations are particularly suitable for co-analysis because lighting and atmospheric conditions are identical. Users should note that projection approaches for CTX and CRISM data from various sources may be different, so even simultaneously collected data may not register perfectly.

### Cite these data
These data are released under the [CC0-1.0 license](https://creativecommons.org/publicdomain/zero/1.0/), meaning you can copy, modify, and distribution these data without permissions. We ask that you cite these data if you make use of them. The citation to be used is:

> Laura, J.R., Dundas, C.M., Fienen, M.N., Wakefield, B.F., and Hare, T.M. (2023) Analysis Ready Data: Uncontrolled Mars Reconnaissance Orbiter (MRO) High Resolution Science Experiment (HiRISE) Reduced Data Record (RDR)s. https://doi.org/10.5066/P944DLP8

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