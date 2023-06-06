---
title: "Galileo Controlled DTMs Created by the USGS"
date: 2023-06-04T12:21:06-07:00
draft: false
bibFile: "content/bibliography.json"
collection: "galileo_usgs_photogrammetrically_controlled_dtms"
---


### Access the Data
{{< access-the-data >}}

### Overview
Knowledge of a planetary surface’s topography is necessary to understand its geology and enable landed mission operations. The Solid State Imager (SSI) on board NASA’s Galileo spacecraft {{< cite "Belton:1996" >}} acquired more than 700 images of Jupiter’s moon Europa. Although moderate- and high-resolution coverage is extremely limited, repeat coverage of a small number of sites enables the creation of digital terrain models (DTMs) via stereophotogrammetry. Here we provide stereo-derived DTMs of five sites on Europa. The sites are the bright band Agenor Linea, the crater Cilix, the crater Pwyll, pits and chaos adjacent to Rhadamanthys Linea, and ridged plains near Yelland Linea. We generated the DTMs using BAE’s SOCET SET® software and each was manually edited to correct identifiable errors from the automated stereo matching process {{< cite "Bland:2021a" >}}. Additionally, we used the recently updated image pointing information provided by the U.S. Geological Survey {{< cite "Bland:2021" >}}, which ties the DTMs to an existing horizontal datum and enables the DTMs to easily be used in coordination with that globally controlled image set. The DTMs are of the highest quality achievable with Galileo data and are therefore suitable for most scientific analysis. However, there are inherent uncertainties in the DTMs including horizontal resolutions that are typically 1–2 km (~10x the image pixel scale) and expected vertical precision (the root mean square (RMS) uncertainty in a point elevation) of 10s–100s of m. The DTMs and their uncertainties are discussed in detail in {{< cite "Bland:2021a" >}}.

### Processing
Raw images were downloaded from NASA’s Planetary Data System (PDS) in .img format and converted to ISIS (Integrated Software for Imagers and Spectrometers) image cubes using the ISIS command gllssi2isis. Position and pointing information (i.e., Navigation and Ancillary Information Facility Spacecraft, Planet, Instrument, Camera-matrix, Events (NAIF SPICE)) was applied, including the updated pointing kernels (CK) and associated planetary constants kernels (PCK) provided by the USGS for Europa Galileo images {{< cite "Bland:2021" >}}. Radiometric calibration was applied (ISIS’ gllssical), and then the images were transferred to BAE’s SOCET SET® software where an additional bundle adjustment was performed using SOCET SET®’s Multi-Sensor Triangulation (MST). In MST, tie-points, and in some cases “z” (or height) constrained ground control points are measured, followed by iterative bundle adjustment to achieve a solution with sub-pixel accuracy. The DTMs were then extracted using the known camera orientation and automated high-density area and feature-based matching using SOCET SET®’s Next Generation Automatic Terrain Extraction (NGATE) {{< cite "Zhang:2006" >}} algorithm with a low smooth option. In cases that used multiple images, the DTM from each stereo model was extracted separately and then merged. We assessed each DTM to ensure that proper alignment with the globally controlled image set of {{< cite "Bland:2021" >}} was maintained. Each DTM was then manually edited to remove artifacts and other errors. In the manual editing process, a technician uses a stereo viewer to manually identify errors due to incorrect automated stereo-matching and adjust the height of those posts closer to the actual three-dimensional surface. This significantly improves the DTM accuracy where errors due to incorrect matching have occurred.  

The only significant procedural difference between the five DTMs was in the details of how MST was run. For the pits and chaos near Rhadamanthys Linea and for Cilix crater (single stereo pairs), the nadir-most image was “held” (prevented from adjusting its position in space), resulting in a so-called “dependent-relative solution” using only tie-points.  Pwyll crater (three images, two stereo pairs) was similarly controlled using only tie points while holding the single overlapping image and allowing the remaining two images to adjust. The DTM of ridged terrain near Yelland Linea (three images, two stereo pairs) required establishing three XYZ-control points in a wide triangle pattern across the stereo model mosaic in addition to a set of tie-points. The coordinates for the control points (longitude, latitude, height) were obtained from the a priori position and pointing of the updated images directly upon import into SOCET SET®. For Agenor Linea (nine images, seven stereo pairs), we applied four XYZ-control points using a priori image coordinates from the updated images. We established these four control points near the edges of the stereo model mosaic in addition to a set of tie-points. For both the ridged terrain near Yelland Linea and Agenor Linea all images were allowed to adjust, resulting in a so-called “independent relative solution.”

Five DTMs are included in this release: 
- Cilix crater
- Chaos and pits near Rhadamanthys Linea
- Pwyll crater
- Ridged plains near Yelland Linea
- A portion of Agenor Linear
- 
The image and stereo criteria for each DTM is shown in Table 1. Each DTM is accompanied by a figure of merit (FOM) and colorized confidence map (ClrCONF), which are described below under Accuracy, Issues, and Errors.

### Available Assets
- DTM: The USGS created DTM
- Hillshade: A shaded-relief image derived from the DTM
- FOM: Figure of merit image showing pixel provenance for each pixel in the DTM.
- Confidence: Confidence images that group FOM classes into qualitative classes.

### Accuracy, Errors, and Issues
The following description is based on the analysis described in {{< cite "Bland:2021a" >}}; however, the five DTMs provided here are not identical to those described in that work. Subsequent to publication of that work, updated image locations were made available for Galileo images of Europa that substantially improve the horizontal registration of that dataset {{< cite "Bland:2021" >}}. We therefore re-generated the DTMs provided here using the updated image locations so that the DTMs are co-aligned with the image data. These DTMs incorporate small improvements in our processing approach and are thus effectively version 2 (whereas those released alongside {{< cite "Bland:2021a" >}} are version 1). The tweaks to our technical approach and the manual editing processes result in modest differences in pixel values between version 1 and 2. However, the general findings of {{< cite "Bland:2021a" >}} regarding DTM accuracy and errors, which we summarized next, still hold. The version 2 DTMs provided here should be comparable or superior to version 1. The descriptions of DTM quality below are therefore conservative. 

DTM accuracy is summarized in Table 1. For each DTM, we provide the minimum effective resolution based on the smallest observable features in the DTM and hillshade. However, we emphasize that this measure of resolution does not indicate that all surface features at that scale can be observed. For example, in several cases (especially Pwyll crater) the “smallest” observable features are double ridges that are just two DTM pixels wide, but extend across large sections of the DTM. We also show two different values for the expected vertical precision (EP). One, which we simply designate EP, was calculated from Root Mean Square (RMS) ground sample distance (GSD), the image pair’s base-height ratio, and assuming a pixel matching accuracy (ρ) of 0.3 (i.e., this is the “formal” EP). The other, designated EPderived, is based on a detailed evaluation of the DTMs themselves and does not assume ρ is 0.3 pixels. {{< cite "Bland:2021a" >}} showed that ρ~1 for Galileo images of Europa, so we consider EPderived a better indication of the vertical precision. We emphasize that in either case EP (or EPderived) is not an “uncertainty.” Rather, it is the RMS uncertainty in a point elevation sampled from the DTM. That is, it is a statistical measure of the quasi-normally distributed error. Thus errors several times larger than EP are expected for some small fraction of points. In no case should EP be thought of as an upper bound on the error within a given DTM. Although errors are often close to normally distributed such that EPRMS is similar to the standard deviation, this is not always the case. For example, the error distribution for the Pwyll crater DTM has extremely long tails and the standard deviation is much larger than EPRMS. While no obvious DTM blunders or gaps occur (they are removed by the manual editing process), it is likely that textures near the resolution limit are artifacts rather than a reflection of Europa’s topography. 

{{< table title="Image and Stereo Criteria for DTMs provided here (after Table 1 in  Bland, et al. 2021a)." number="1" id="europa_dtm_table">}}
<table>
    <tr>
        <td></td>
        <td>Image<sup>a</sup></td>
        <td>GSD<br>(m/pixel)</td>
        <td>GSD<sub>RMS</sub><sup>b</sup><br>(m/pixel)</td>
        <td>i<sup>c</sup></td>
        <td>e<sup>d</sup></td>
        <td>DST<sup>e</sup></td>
        <td>(p/h)<sup>f</sup></td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td rowspan="2">Cilix crater</td>
        <td>s0449965000</td>
        <td>110</td>
        <td rowspan="2">90</td>
        <td>31.8°</td>
        <td>25.9°</td>
        <td rowspan="2">0.044</td>
        <td rowspan="2">1.18</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0449967535</td>
        <td>63</td>
        <td>36.8°</td>
        <td>29.9°</td>
    </tr>
    <tr>
        <td rowspan="2">Chaos and pits</td>
        <td>s0449961826</td>
        <td>232.1</td>
        <td rowspan="2">170</td>
        <td>79.8°</td>
        <td>38.8°</td>
        <td rowspan="2">0.14</td>
        <td rowspan="2">1.32</td>
    </tr>
    <tr>
        <td>s0484888726</td>
        <td>63.3</td>
        <td>79.9°</td>
        <td>47.6°</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td rowspan="3">Pwyll crater</td>
        <td>s0383715500</td>
        <td>243.8</td>
        <td rowspan="3">194</td>
        <td>76.2°</td>
        <td>40.3°</td>
        <td rowspan="3">4.1</td>
        <td rowspan="3">1.8</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td style="border-bottom: 1px dashed black;">s0383715504</td>
        <td>244.7</td>
        <td>80.0°</td>
        <td>43.9°</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0426268700</td>
        <td>125.8</td>
        <td>57.9°</td>
        <td>48.3°</td>
    </tr>
    <tr>
        <td rowspan="3">Ridged Plains</td>
        <td>s0426272642</td>
        <td>14</td>
        <td rowspan="3">21</td>
        <td>29.8°</td>
        <td>37.8°</td>
        <td rowspan="3">0.004</td>
        <td rowspan="3">0.55</td>
    </tr>
    <tr>
        <td style="border-bottom: 1px dashed black;">s0426272646</td>
        <td>14</td>
        <td>29.8°</td>
        <td>37.8°</td>
    </tr>
    <tr>
        <td>s0426272821</td>
        <td>25.6</td>
        <td>29.9°</td>
        <td>47.7°</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td rowspan="9">Agenor Linea</td>
        <td>s0466669500</td>
        <td rowspan=7>50</td>
        <td rowspan=9>156</td>
        <td rowspan=7>75-80°</td>
        <td rowspan=7>37-39°</td>
        <td rowspan=9>2.2</td>
        <td rowspan=9>0.88</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466669513</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466669526</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466669539</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466669552</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466669565</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td style="border-bottom: 1px dashed black;">s0466669578</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466664665</td>
        <td rowspan="2">210-223</td>
        <td rowspan=2>71-80°</td>
        <td rowspan=2>31-40°</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
        <td>s0466664326</td>
    </tr>
</table>
{{< /table >}}
<sup>a</sup>Image number based on the spacecraft clock start count (keyword SpacecraftClockStartCount). Horizontal dashed line separates images that formed each pair when more than two images were used. <br>
<sup>b</sup>GSDRMS is the root mean square (RMS) ground sample distance (GSD) or pixel scale. <br>
<sup>c</sup>i is the incidence angle <br>
<sup>d</sup>e is the emission angle <br>
<sup>e</sup>DST is shadow tip difference. Low values are preferable and indicate similar illumination. See {{< cite "Becker:2015" >}}. <br>
<sup>f</sup>(p/h) is the base-height ratio. Ideal values are from 0.4 to 0.6, which correspond to convergence angles of 20– 30o. <br>


For each DTM, we also provide a “Figure of Merit” and a colorized confidence map. The FOM is a map of numerical values generated by SOCET SET® that indicates one of three things for a given post measurement:
- It may be an error flag value (e.g., for poor automatic measurement).
- It may indicate a successful measurement.
- It may be an edit flag value, indicating the type of editing used.
FOM values ranging from 0 to 39 indicate error or edit flags. FOM codes greater than 40 indicate a successful automatic correlation, with larger values indicating a better measurement. Table 3 lists the meaning of each FOM value.

Because the FOM codes can be difficult to parse, we also provide a confidence map for each DTM. The confidence map is derived from the FOM and simply groups different types of FOM values together. For example, all nine types of edit flags are grouped together as simply “manually interpolated.” The map is especially useful for understanding which posts were edited, as well as the quality of the correlation. The confidence map legend is provided below.

<center>
 {{% figure src="/images/data/jupiter/europa/europa_controlled_usgs_dtms/fom.png" caption="Figure of Merit (FOM) legend. " alt="FOM" %}}
 </center>

The DTMs were generated from image data with improved locations relative to the global imaging data set {{< cite "Bland:2021" >}}. The relative and absolute horizontal accuracy of the DTMs is therefore identical to that of the image data set. That data set have an image-to-image (i.e., relatively alignment) RMS uncertainty of 246.6 m in latitude, 307.0 m in longitude, and 70.5 m in radius. The image data are also tied to Europa’s geodetic reference system. The center of the crater Cilix, which defines the reference system at 182º W (178º E), is located at 181.9991414ºW (178.0008586ºE). The difference is approximately equivalent to 23 m, which is less than the pixel scale of the highest resolution Galileo images of Cilix. The location is therefore “known” to a fraction of a pixel and actually exceeds the precision with which the center of Cilix (a 19-km-diameter crater) is known. However, given that the data set is tied to the reference frame only at a single point, the certainty with which absolute coordinates are known degrades with distance from Cilix (generally as the √N where N is the number of images away from Cilix).


### General Usability 
The manual editing process ensures that these DTMs are of extremely high quality with the vast majority of blunders corrected. They are generated from, and therefore well-aligned with, the improved Galileo and Voyager image data set of {{< cite "Bland:2021" >}}. We therefore consider them to be the highest quality possible from stereophotogrammetry of Galileo images, and they are therefore fit for most scientific uses, including geologic and morphometric analysis. However, the user should be aware of their inherent limitations. {{< cite "Bland:2021a" >}} found that the horizontal resolution is typically ~10x the DTM pixel scale (m/post), which is consistent with recent studies of DTMs generated for Mars ({{< cite "Kirk:2021" >}} found 10–20 km). Features below the resolution given in Table 2 (typically 1–2 km) are almost certainly present on Europa. Furthermore, evaluation of slopes are also limited by the DTM pixel scale (100s of m), and steeper slopes may be present at small scaler scales. The expected vertical precision given in Table 2 is a statistical measure of the DTMs error distribution, and the uncertainty at a single point may be several times larger. These issues are discussed at length in {{< cite "Bland:2021a" >}}, and we encourage the user of these DTMs to read that manuscript to obtain a better understanding of uncertainties inherent in these data products.    

{{< table title="Summary of DTM resolution and Accuracy. Modified from Table 2 of Bland, et al. 2021a" number="2" >}}
|DTM|Post Spacing|Resolution|EP|EPderived|
|:----|:----|:----|:----|:----|
|Cilix crater|250 m|1.1 km|23 m|36 m|
|Pwyll crater|750 m|1.5 km|32 m|112 m|
|Chaos and Pits|200 m|1.8 km|39 m|66 m|
|Ridged Plains|60 m|180 m|11 m|14–21 m|
|Agenor Linea|450 m|3.0 km|52 m|~100 m|
{{< /table >}}

### Related Data
The DTMs were generated from Galileo images with improved geometry {{< cite "Bland:2021" >}}. Those images and accompanying documentation are available via a SpatioTemporal Asset Catalog at https://psdi.astrogeology.usgs.gov/europa/data/data_products/.

### Cite these data
These data are released under the [CC0-1.0 license](https://creativecommons.org/publicdomain/zero/1.0/), meaning you can copy, modify, and distribution these data without permissions. We ask that you cite these data if you make use of them. The citation to be used is:

> Bland, M.T.; Kirk, R.L.; Galuszka, D.M.; Mayer, D.P.; Beyer, R.A.; Fergason, R.L. How Well Do We Know Europa’s Topography? An Evaluation of the Variability in Digital Terrain Models of Europa. Remote Sens. 2021, 13, 5097. https://doi.org/10.3390/rs13245097 

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