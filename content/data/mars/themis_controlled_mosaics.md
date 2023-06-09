---
title: "Thermal Emission Imaging System (THEMIS) USGS Controlled Mosaics"
date: 2023-02-28
weight: 3
bibFile: "content/bibliography.json"
---

### Overview
The THEMIS controlled mosaics were generated to correct mis-registrations between individual THEMIS images using rigorous photogrammetric methods and to create a seamless, accurate basemap for Mars. The 2001 Mars Odyssey Thermal Emission Imaging System (THEMIS) {{< cite "Christensen:2004" >}} began operation in 2001, and covers nearly 100 percent of the Mars’ surface and often several times. The spacecraft’s near-polar orbit results in images that are oriented close to north-south and at a consistent local time and spatial resolution. These criteria make THEMIS images ideal for generating controlled data products (Figure 1). This process creates an accurate basemap of Mars and allows infrared data to be accurately integrated with other data sets (such as topography or composition) to enable addressing more complex scientific questions.

Some common use cases for THEMIS controlled mosaics include (see also [General Usability]({{< ref "#General Usability" >}})) include the following: 
    - Geologic context of the region of interest for more detailed analyses using higher resolution data sets (e.g., visible images, topography, compositional data) 
    - Basemaps for geologic, surface morphology, or other thematic mapping 
    - Positional ground truth for registering with other data sets
    - Assessing the offsets between another data set and the position of the Mars Orbiter Laser Altimeter (MOLA; the current ‘truth’) 
    - Nighttime image mosaics can be used as a unique dataset to gain insight into the physical properties of the surface

These are not recommended use cases for the THEMIS controlled mosaics:
    - Quantitative analysis or for drawing relative scientific conclusions outside of a regional area. These mosaics are 8-bit (i.e., qualitative) products where image have been blended across seams to create an aesthetically pleasing product.
    - For quantitative analyses, see the individual controlled images. These images maintain the same positional accuracy as these mosaics and retain 32-bit, quantitative information appropriate for scientific or engineering use.

 {{< figure src="/images/data/mars/themis/themis_mosaics/figure1.png" title="Figure 1: Syrtis Major mosaic example. The projection is simple cylindrical with a longitude domain of 0 to 360 degrees. (a) THEMIS daytime infrared (IR) controlled mosaic example.  (b) THEMIS nighttime IR controlled mosaic example. (c) THEMIS daytime IR controlled mosaic of Nili Patera. (d) THEMIS nighttime IR controlled mosaic of Nili Patera.">}}

 The analysis ready THEMIS mosaics are created from geodetically controlled THEMIS daytime infrared and nighttime infrared images and the associated control network. These data are a [foundational data product](http://fdp.astrogeology.usgs.gov/) for Mars. The THEMIS ARD mosaics are absolutely controlled to the Mars Orbiter Laser Altimeter (MOLA) {{< cite "Zuber:1992;Smith:2001" >}} digital elevation model and are generated from orthoprojected daytime infrared and nighttime infrared mosaics of Mars at 100 m/pixel scale for the ±65˚ latitude region of Mars. These mosaics enhance our knowledge of image placement (position, precision, and accuracy) and the location of small-scale surface features. These products can serve as a 100 m/pixel basemap for Mars.  

Daytime infrared images look similar to visible images, because surface topography is a large factor in the surface radiance or temperature during the day.  For example, cooler areas shaded by local topography and not exposed to direct sunlight mimic shadowed areas observed in visible images and are often the same surfaces.  Surface albedo is also a factor in determining surface radiance or temperature during the day.  Darker surfaces in visible images – such as dark sand – will absorb more of the sun’s energy during the day. This additional absorption relative to surrounding surfaces will results in a higher pixel value and will appear “brighter” in daytime infrared images.

On the other hand, nighttime infrared images provide a unique view of the Martian surface.  On Mars, surface radiance or temperature at night is controlled by the conductivity of surface materials themselves and the rate at which the surface emits infrared energy that was absorbed during the previous day.  Generally, finer-grained materials (e.g., loose dust, silt, or fine-grained sand) release energy very quickly and will have a lower pixel value, or appear “darker”, at the pre-dawn times these nighttime images were acquired.  Bedrock, ice (at higher Martian latitudes, and not typically observed at the latitudes included in these mosaics), or indurated materials release energy more slowly and have higher pixel value, or “brighter” appearance, at night.  

### Processing
THEMIS infrared data are acquired using a multispectral microbolometer array with 320 cross-track pixels and 240 down-track pixels. Thus, the smallest THEMIS image that can be acquired contains 240 rows.  However, the THEMIS instrument is commanded such that images longer than 240 rows are typical, and that image length can be customized to meet the goals of the observation.  It has an instantaneous field of view (IFOV) of ~100 m per pixel and an image width of ~32 km. Spectral differentiation in the infrared is achieved with ten narrowband stripe filters that produce ~1-μm wide bands at nine separate wavelengths from 6.78 to 14.88 μm (Table 1). These bands include nine (9) surface-sensing wavelengths (bands 1 - 9), and one atmospheric wavelength (band 10) {{< cite "Christensen:2004" >}}.  Two filters (bands 1 and 2) cover the same wavelength range (centered at 6.78 μm) to improve the signal to noise in that spectral region. Standard THEMIS data processing consists of decompression, radiometric calibration, systematic noise removal, and were applied to these images. Images can also be geometrically corrected, and multiple images can then be mosaiced together {{< cite "Christensen:2004" >}}. 

|     Band    |     Center Wavelength   (µm)    |     Band Width (µm)     (Full Width Half   Max)    |     Signal-to-Noise   Ratio    |
|-------------|---------------------------------|----------------------------------------------------|--------------------------------|
|     1       |     6.78                        |     1.01                                           |     33                         |
|     2       |     6.78                        |     1.01                                           |     34                         |
|     3       |     7.93                        |     1.09                                           |     104                        |
|     4       |     8.56                        |     1.16                                           |     163                        |
|     5       |     9.35                        |     1.20                                           |     186                        |
|     6       |     10.21                       |     1.10                                           |     179                        |
|     7       |     11.04                       |     1.19                                           |     193                        |
|     8       |     11.79                       |     1.07                                           |     171                        |
|     9       |     12.57                       |     0.81                                           |     132                        |
|     10      |     14.88                       |     0.87                                           |     128                        |
Table 1. THEMIS infrared band characteristics {{< cite "Christensen:2004" >}}

We generated separate mosaics for the daytime and nighttime infrared images since these image products have a significantly different appearance and are often used for different scientific or other purposes. Our strategy for generating the global mosaics was to create regional networks and then merge those regional networks together as they were built. We incorporated all viable THEMIS infrared images into the control network that had been acquired when we began work on a given regional mosaic. Since the THEMIS instrument is still orbiting Mars and collecting data, not all THEMIS images are included in the control network (i.e., recently acquired images are not included). Images were also excluded from the network if they were of poor quality and the matching software or manual tie pointing methods were unsuccessful in obtaining match points. Often, and particularly at high latitudes and areas with a low thermal inertia surface, this poor image quality was due to cold surface temperatures resulting in a relatively low signal-to-nose ratio. Those images not included in the network do not have improved image information (i.e., [smithed kernels](https://naif.jpl.nasa.gov/naif/aboutspice.html).) 
  
THEMIS controlled products correct for mis-registration between images and georeference the THEMIS mosaic to MOLA using rigorous photogrammetric techniques. The USGS Integrated Software for Imagers and Spectrometers (ISIS; https://github.com/USGS-Astrogeology/ISIS3) version 3.5.3 software suite was used to generate the THEMIS daytime infrared and nighttime infrared control networks. This multi-step process was iterative and required human oversight to identify and correct errors.  Our process was specifically tailored for the THEMIS dataset and includes: 1) identify and download images from the Planetary Data System (PDS; https://pds-imaging.jpl.nasa.gov/volumes/ody.html); 2) ingest the THEMIS images into ISIS and initialize the geometric information (I.e., SPICE initialization); 3) obtain points and measures on images by using both existing points from adjacent tiles and creating new points and measures; 4) subpixel register measures and evaluate registration quality; 5) bundle adjust the network; 6) evaluate high residual measures and network health; 7) make appropriate adjustments and bundle adjust the modified network; 8) continue iterating over bundle adjustment, evaluating network health, and modifying the network until image-to-image residuals fell below sub-pixel accuracy; 9) tie the completed network to ground; and 10) generate mosaics for visual inspection. 
  
Following the steps above, we generated the THEMIS infrared controlled mosaics by first running the ISIS program spiceinit to obtain sensor ephemeris information, which provides the initial estimates of where the camera was as it was orbiting Mars and where it was pointed as each image was acquired (steps 1 - 2). This information was the starting point for generating the controlled image products. We then used multiple image-to-image tie point methods to identify matching features in images (steps 3), sub-pixel-registered these features using the ISIS program pointreg and evaluated the registration quality (step 4). We then ran the ISIS bundle adjustment program jigsaw (step 5) {{< cite "Archinal:2003;Archinal:2004" >}}. A least-squares bundle adjustment of the network solved for the latitude, longitude, and radius uncertainties on each point in the control network, the uncertainties for the exterior orientation of the images (i.e., pointing of the spacecraft and position of each image), and uncertainties associated with these measurements.  We then evaluated the network’s health, made appropriate adjustments and bundle adjusted the modified network. We continued to iterate over bundle adjustment, evaluating network health, and modifying the network until image-to-image residuals fell below sub-pixel accuracy (steps 6 - 8 above).
  
After image-to-image ties were completed, we then tied the THEMIS network to ground (step 9 above) using an improved [Viking MDIM 2.1 network](https://astrogeology.usgs.gov/maps/mdim-2-1) (Archinal et al., 2003; 2004). We chose Viking MDIM, rather than tying directly to MOLA, because it is challenging to register an image data set to altimeter shot points or topography information, as surface features may appear very different in each of these data sets.  We also incorporated new data into the [Viking MDIM 2.1 network](https://astrogeology.usgs.gov/maps/mdim-2-1). To take advantage of the high accuracy High/Super Resolution Stereo Camera (HRSC) {{< cite "Jaumann:2007" >}} data and the geometric strength of the global Viking MDIM 2.1, we reprocessed the original MDIM 2.1 network incorporating available HRSC level 4 data (which have been controlled to the MOLA reference frame) as additional ground control. Error propagation showed that 80 percent of the final enhanced MDIM 2.1 solution tie points have horizontal accuracies better than 200 meters. This methodology resulted in a control network and an orthorectified product that we could use as an intermediate tie to MOLA.  

Using this improved image pointing information, mosaics were generated using the Davinci software developed by Arizona State University (http://davinci.asu.edu/index.php?title=Main_Page) (step 10 above). These mosaics were generated following the procedure described in {{< cite "Edwards:2011" >}}.  Using Davinci allowed us to incorporate post-processing image techniques developed by the THEMIS team (e.g., uddw, rtilt, deplaid, and blend) to reduce image noise and seams between images {{< cite "Edwards:2011" >}}. This process resulted in a seamless, blended, 8-bit, qualitative mosaic product.

For release as Analysis Ready Data. Footprints are generated for each of mosaics using ISIS. Then the mosaics are converted to losslessly compressed Cloud Optimized GeoTiffs and Spatio-Temporal Asset Catalog (STAC) metadata are generated.
### Available Assets
Assets available with these data are:
  - THEMIS controlled mosaics: This product.
  - Image thumbnail: Browse product.
  - ISIS Label: The ISIS label from the cube formatted mosaic.

### Accuracy, Errors, and Issues
These mosaics have been visually inspected to identify mis-registrations between images in the mosaic and they are typically corrected by adding new points or removing poor quality images. We then continued to iterate over bundle adjustment, evaluating network health, and modifying the network until image-to-image residuals fell below sub-pixel accuracy. The quality evaluation of the THEMIS daytime and nighttime control networks was based on the average bundle adjustment residuals and provides information about the quality of the image registration. In the uncontrolled data, we found that errors in image position at the 2 - 4-pixel level (but as large as 30 pixels) are common (Figure 2).  The position of a single THEMIS image was most commonly adjusted by 2 - 7 pixels, which corresponds to 200-700 meters. These errors are primarily due to uncertainties in the THEMIS image start time. This uncertainty is random, and there are no current plans by the THEMIS mission team to improve the infrared ephemeris data (for example, by improving the sensor model). Photogrammetrically controlling the THEMIS images has enabled the correction of these errors and improves both the registration between images and registration to a known coordinate reference frame (e.g., MOLA) at known levels of precision and accuracy. The registration between THEMIS images in these products is better than a single pixel (or 100 m).  

We also visually compared each mosaic to the MOLA hillshade to assess the registration between the THEMIS mosaics and the established Mars datum (or ground “truth”). In addition, we overlaid MOLA contours onto each controlled mosaic and verified that the contours represented the topographic variations observed in the THEMIS images using ESRI’s ArcMap software package. The THEMIS mosaics are consistent with the MOLA topography at the scale of the THEMIS images (100 meters). 

 {{< figure src="/images/data/mars/themis/themis_mosaics/figure2.png" title="Figure 2: Comparison of uncontrolled (left) and controlled (right) image averaged mosaic products. Portion of the Elysium mosaic, 15.4° N, 162.4° E. The uncontrolled mosaic is blurry due to misalignment of the individual images that make up the mosaics. A 16-20-pixel shift was necessary to match features in this area. Once matched, the blur in the average mosaic is significantly reduced. The projection is simple cylindrical with a longitude domain of 0° to 360°.">}}

### General Usability
As described above, these mosaics were rigorously inspected to identify and correct mis-registrations between THEMIS images. However, no data product is perfect and minor mis-registrations between images exist in these controlled mosaics.  Mis-registrations between images indicate that the position of one or more images in that region has larger uncertainties.  These mis-registrations can be observed as features – such as craters or fissures – that do not align at THEMIS image boundaries (see Figure 2). 

These controlled products help meet a common need among researchers to accurately co-locate data sets of varying spatial scales and data types to aid in addressing multi-disciplinary questions and allow for precision science to be accomplished. For example, these products allow one to compare the registration between this thermal data set and higher-resolution visible data, topography, and composition data, as well as potentially improve the geometric registration between datasets.  Any data product, such as elevation, composition, or visible images, aligned with the Mars Orbiter Laser Altimeter (MOLA; Zuber et al., 1992; Smith et al., 2001) dataset will also be well-registered to the controlled THEMIS mosaics.  

As a global data set of intermediate spatial scale, the controlled THEMIS daytime infrared and nighttime infrared products also enable the accurate co-registration of higher-resolution Martian data sets, such as Context Camera (CTX) {{< cite "Malin:2007" >}} and HiRISE images. This accurate base is necessary to facilitate the co-location of data (e.g., data fusion) with known, quantifiable errors, and provides a foundation to which all other Martian data sets intersecting the network can then be registered.  In addition, the THEMIS controlled products can be used as an accurate ground “truth” dataset to control higher resolution data and is currently being used as the base for CTX controlled mosaics.
As a global data set of intermediate spatial scale, the controlled THEMIS daytime infrared and nighttime infrared products also enable the accurate co-registration of higher-resolution Martian data sets, such as Context Camera (CTX) {{< cite "Malin:2007" >}} and HiRISE images. This accurate base is necessary to facilitate the co-location of data (e.g., data fusion) with known, quantifiable errors, and provides a foundation to which all other Martian data sets intersecting the network can then be registered.  In addition, the THEMIS controlled products can be used as an accurate ground “truth” dataset to control higher resolution data and is currently being used as the base for CTX controlled mosaics.

### Related Data
Individual, 32-bit science ready images, that have been used to create these qualitative mosaics will be released in the future.

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