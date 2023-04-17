---
title: "Photogrammetrically Controlled Galileo Individual Observation"
bibFile: "content/bibliography.json"
---

### Browse the data
- [STAC Browser](https://stac.astrogeology.usgs.gov/browser-dev/#/collections/galileo_usgs_photogrammetrically_controlled_observations)

### Overview
The Galileo spacecraft was deployed from NASA’s Space Shuttle Atlantis in October of 1989 and entered Jupiter’s orbit in December of 1995. The spacecraft was equipped with a framing camera (the Solid State Imager, or SSI) with a 1,500-mm nominal focal length, 8.1-mrad field of view, 10.16-µrad/pixel angular resolution, 800x800-pixel charge-coupled device detector, and 8 filter positions (mounted on a filter wheel) [Belton, 1992]. Over the course of the Galileo mission, the spacecraft acquired more than 700 images of Jupiter's moon, Europa, providing the only moderate- to high-resolution images of the moon's surface. Unfortunately, uncertainty in the position and pointing of the spacecraft, as well as the position and orientation of Europa, when the images were acquired resulted in significant errors in image locations on the surface. The result of these errors is that images acquired during different Galileo orbits, or even at different times during the same orbit, are significantly misaligned (errors of up to 100 km on the surface). Global photogrammetric control of nearly the entire Europa-Galileo image dataset (along with 221 Voyager 1 and 2 images) improved the relative and absolute location of the images. Here we provide 481 individual equirectangular projected (level 2) images in both photometrically trimmed and untrimmed version. Images that extend above or below ±5&deg;latitude are also provided in polar stereographic projection (a total of 1,104 products). The individual projected images provide an intermediate product that are suitable for those who want to use the data on an image-by-image basis, or who want to understand what each of the individual images that make up an observation look like.

### Processing
Raw Galileo images and labels were downloaded from the [Planetary Data System (PDS) archive](https://pds-imaging.jpl.nasa.gov/volumes/galileo.html) and ingested into the  Integrated Software for Imagers and Spectrometers (ISIS 3.10) as ISIS cubes (i.e., images in .cub format) using the application `gllssi2isis`. Reconstructed SPICE kernels (i.e., the default kernels) were applied using ISIS’ `spiceinit` application. A standard radiometric calibration (ISIS’ `gllssical` application) and noise filter (ISIS’ `noisefilter` application) was applied, and the edge of each image was then trimmed by 2 pixels (ISIS’ `trim` application). In some cases, image downlink was interrupted mid-transmission and had to be completed later, with the result that lines from a single frame are split into multiple image files. These images were reconstructed using ISIS’ `handmos` application, which combines two ISIS cubes by line/sample.

Although not included in this STAC, Voyager data was included in the photogrammetric control network used to create the mosaics. Voyager images ranged in scale from 1.63 km/pixel to 32 km/pixel, with the highest resolution images concentrated at 180&deg;E. Voyager images were ingested into ISIS (ISIS’ `voy2isis`) and reconstructed SPICE kernels were applied (we used the pck00010_msgr_v23.tpc planetary constants kernel (PCK)). In most cases, the reconstructed Voyager SPICE is so poor that the image lies completely off the body, and had to be manually adjusted using ISIS’ `deltack` application before the images could be used (see {{< cite "Bland:2021" >}} for details). Once the SPICE was corrected, we applied the standard Voyager radiometric calibration (ISIS’ `voycal`) and removed image reseaux (ISIS’ `findrx` and `remrx`). The highest resolution (smallest pixel scale) images redundantly cover the anti-Jovian hemisphere at pixel scales of 1.6 – 2 km.

In order to improve the locations of Galileo and Voyager images a global network of image tie points (a control network) was developed using ISIS. The control network is the input to the photogrammetric control process, in which a least-square bundle adjustment is performed to triangulate the ground coordinates (latitude, longitude, and radius) of each tie point and minimize location residuals globally. The ISIS application jigsaw was used to perform all the bundle adjustments. In order to create a global control network for Europa images, three independent networks were first generated: a Voyager-only network, a Galileo-only network, and a bridge network that included key Voyager and Galileo images. Each of these networks was bundle adjusted separately to ensure a clean network (i.e., free from image mis-registrations). The three clean networks were then merged into a single network and bundled together to update image locations. The final bundle adjustment solved for camera angles (including twist) using a priori constraints of 1 degree on camera angles and 500 m in radius. The orientation of Europa was then adjusted (parametrized as the prime meridian offset Wo) to ensure the data are aligned with the IAU-defined coordinate system for Europa (i.e., the longitude of the crater Cilix must be at 182&deg;W / 178&deg;E).
 
The final bundle solution included 694 Galileo and Voyager images, of which 481 were from Galileo and have pixel scale ranging from 5.7 m/pixel to 19,500 m/pixel. We then generated two versions of each image: one that is trimmed (ISIS’ `photrim` application) at high incidence and emission angles and one that is not. The trimmed versions used maximum emission and incidence angles of 90 degrees; however, 25 images were trimmed at maximum angles between 80 and 90 degrees to remove distorted data. This version provides the most aesthetically pleasing images as smeared regions at high emission are removed. However, the untrimmed version reveals the full extent of data acquisition. The images were then projected (ISIS’ cam2map) to an equirectangular projection with Europa’s mean radius of 1,560.8 km {{< cite "Archinal:2018" >}} and an east-positive, planetocentric 0–360&deg; coordinate system, for consistency with the upcoming Europa Clipper and JUICE missions. When images extended above or below 55&deg; north or south, a version in polar stereographic projection was also included. No photometric correction was applied to the images.


### Available Assets
Assets available with these data are:
- Galileo Solid State Imager Europa observation sequence mosaics.
- Galileo stereo DTMs spatially aligned with the image mosaics described here.
  
### Accuracy, Errors, and Issues
Final bundle adjustment yielded root mean square (RMS) uncertainties of 246.6 m, 307.0 m, and 70.5 m in latitude, longitude, and radius, respectively. The total RMS uncertainty (over all points) was 0.32 pixels. These values should be thought of as the uncertainty in the location of images relative to one another. The data are also tied to Europa’s geodetic reference system. We have confirmed that the center of the crater Cilix, which defines the reference system at 182&deg;W (178&deg;E), is located at 181.9991414&deg;W (178.0008586&deg;E) in the mosaic. The difference is approximately equivalent to 23 m. The highest resolution images of Cilix have a pixel scale of 63 m/pixel, so the location is “known” to a fraction of a pixel. The precision therefore exceeds that with which the center of Cilix (a 19-km-diameter crater) is known, especially given the natural irregularity of the crater rim. However, given that the data set is tied to the reference frame only at a single point, the certainty with which absolute coordinates are known degrades with distance from Cilix (generally as the sqrt(N) where N is the number of images away from Cilix).

### General Usability
The individual images provide the user with a simple means to use single images with updated image locations in, for example, a GIS environment or machine learning software. This includes analyses that combine multiple images from different observation sequences in a spatially consistent way. The individual images also enable users to better understand the data underlying the observation sequence mosaics, which are provided elsewhere in this STAC catalog. In particular, the observation sequence mosaics are average mosaics (each pixel DN value is the average of the calibrated but photometrically uncorrected I/F from each overlapping image). The individual projected images permit the user to create “on top” mosaics, for which the individual image DNs (as I/F) are shown. This also permits the creation of color products by appropriately combining images acquired with different filter settings, and also photometric analysis. The untrimmed images provide users with the opportunity to search for features beyond the terminator or just off the limb (e.g., due to high standing topography).

The user should be aware that many of the images were reconstructed from multiple files using ISIS’ `handmos` application, as described in the Processing section. These images can be identified by their naming convention, which includes an underscore that indicates two images were combined. For example, observation s0440948826_27 was reconstructed by including data held in the image files s0440948826 and s0440948827. In some cases, three data files were used to construct an image, as indicated by multiple underscores in the observation name.

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

### Related Data
Traditional, global mosaics are available [from the USGS](https://astrogeology.usgs.gov/search/map/Europa/Voyager-Galileo/Europa_Voyager_GalileoSSI_global_mosaic_500m) and [Dr. Paul Schenk](https://repository.hou.usra.edu/handle/20.500.11753/1412). 

### References
{{< bibliography cited>}}