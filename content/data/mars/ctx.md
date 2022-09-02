---
title: "Photogrammetrically Controlled MRO Context Camera (CTX)"
date: 2021-08-28T05:44:09-07:00
weight: 3
geekdocHidden: true
---

### Overview
The Mars Reconnaissance Orbiter (MRO) Context Camera (CTX; Malin et al., 2007) began operations in 2006. It is a “pushbroom” imager that acquires images one line at a time as the spacecraft moves in its orbit around Mars. The CCD detector is 5,000 pixels wide and the images have a scale of approximately 6 m/pixel in the MRO mapping orbit. The MRO is in a near-polar orbit, so the orbit tracks are almost oriented south-north. Thus, individual CTX images are approximately 30 km wide (approximately east-west) and range in length from tens to hundreds of km (approximately north-south). CTX images cover nearly 100% of the surface of Mars, often more than once to acquire stereoscopic coverage or to search for changes on the surface. 
  
Stereo pairs of CTX images can be used to determine the surface topography at much higher resolution than global data sets. CTX Digital Terrain Models (DTMs) are local-scale topographic models. Each CTX DTM covers the area of overlap of two CTX images with a post spacing of 20 meters. They have been aligned to Mars Orbiter Laser Altimeter (MOLA) elevation data (Smith et al., 2003).  
 
The DTMs allow production of orthorectified images (“orthoimages”) with minimized geometric distortion. In effect, parallax is removed so the orthoimage is like looking straight down on the surface at every point. Images that have not been orthorectified (or have been orthorectified onto a low-resolution DTM) may have some parallax distortion even if they have been map-projected. In other words, if you look at a crater from different angles, it will have different shapes: slopes that face the camera are wider, whereas slopes facing away are foreshortened. Without control to a DTM that is close to the scale of the image, no projection can correct for this.  
 
 ![An animation blinking back and forth between two HiRISE images, showing the effects of parallax where the crater appears different from different angles.](https://code.chs.usgs.gov/asc/arc_docs/-/tree/main/static/images/data/mars/ctx/HiRISE_parallax.gif)  
**Animated GIF: Demonstration of the effects of parallax. These HiRISE images showing Victoria crater have only been orthorectified to a low-resolution DTM from MOLA, which is not sufficient to remove the parallax effects from poorly resolved small-scale topography. They were aligned by hand so that the rim approximately lines up in both images. The uncorrected parallax means that the lengths of the crater walls facing towards and away from the camera appear to change, depending on the viewing direction. (Reduced Data Record (RDR) images PSP_001414_1780 and PSP_001612_1780, credit: NASA/JPL/University of Arizona)** 

### Processing
The orthoimages are derived along with the DTMs using the Ames Stereo Pipeline. The _point2dem_ function is used to orthographically project a texture file (an ISIS cube file from earlier in the processing stages) onto the DTM.  

### Available Assets
JPEG thumbnail image 
FGDC metadata 
Provenance information

### Accuracy, Errors, and Issues
The units of the orthoimages are I/F (intensity/flux), which is a measure of reflectivity. The values are always greater than zero and are less than 1 except in unusual circumstances that should not exist in CTX data. 
 
The accuracy of these quantitative values is affected by the quality of the radiometric calibration of CTX. This has been estimated to be accurate to within 10–20% (Bell et al., 2013).  Complications in this estimate arise because orthoimages are resampled at several stages in their production, which partially averages any given pixel with adjacent pixels. Additionally, the values do not include topographic photometric correction, so the I/F of any pixel is due to a combination of its natural reflectivity, the distance to and position of the Sun, and topographic effects (the orientation of the surface relative to the camera).  
 
Perhaps the most important issue is that the I/F values are “top of atmosphere” measurements. In other words, the light received by CTX is a mix of light reflected from the surface and scattered light from the atmosphere, mostly due to dust in the air. This issue is very pronounced in dust storms, but severely dust-clouded images are not suitable for producing DTMs so this is rare in these data. However, dust is always present in the Martian atmosphere in some amount. Thus, the I/F of a rock outcrop observed by CTX from orbit is not the same as would be observed measuring the same rock at the surface at the same time. Since the amount of dust in the air varies, the I/F of a patch of surface can also be different in different images even if the lighting is the same.  

### General Usability
Orthorectified images have several important uses. They are aligned to the associated DTM when they are produced, so they are the optimal choice for DTM-image co-analysis, in which a user can map a feature using the image and then study its topographic properties using the DTM. It is always advisable to examine the quality of the DTM as discussed in the description of the DTMs prior to such analysis. In addition to DTM-image co-analysis, aligning different datasets is easiest when they are orthorectified, preferably to the same DTM. Orthorectified images are also excellent for change-detection studies because they are extremely well-aligned.  
 
Orthoimages controlled to the same DTM should register well with no effort. Artifacts or noise in the DTM may mean that the orthoimages have some remaining distortion relative to an orthoimage from a hypothetical perfect DTM; however, this distortion will be present in all images controlled to the same DTM and so relative comparisons (such as for change detection) are generally not much affected.  
 
Orthoimages will not necessarily align well with non-orthorectified data or with data that has been orthorectified to a different DTM which may have different resolution and/or different artifacts. Even within this dataset, orthoimages based on different CTX DTMs may have offsets relative to each other because the CTX DTMs have been individually controlled to MOLA and the alignment to the lower-resolution MOLA topography is uncertain at the scale of CTX images. However, these offsets should be much less severe than the offsets and distortion present in non-orthorectified images.  

### Related Data
Digital Terrain Models (DTMs) associated with the orthorectified images are available in this catalog.  
 
CTX data are often acquired simultaneously with higher-resolution observations from the High Resolution Imaging Science Experiment (HiRISE; McEwen et al., 2007) and near-infrared spectral images from the Compact Reconnaissance Imaging Spectrometer for Mars (CRISM; Murchie et al., 2007). Such coordinated observations can be particularly useful because the viewing geometry, surface illumination, and atmospheric conditions are the same. HiRISE and CRISM data are available from the PDS but have not been orthorectified at the level of the CTX DTMs and orthoimages. Therefore, they will not align precisely by default if they are imported into GIS software and there will be some geometric distortion of data orthorectified to lower-resolution MOLA data. 

### References
Bell J. F. et al. (2013). Calibration and performance of the Mars Reconnaissance Orbiter Context Camera (CTX). Int. J. Mars Sci. Explor. 8, 1-14. https://doi.org/10.1555/mars.2013.0001.  
Malin M. C. et al. (2007). Context Camera investigation on board the Mars Reconnaissance Orbiter. J. Geophys. Res., 112, E05S04. https://doi.org/10.1029/2006JE002808.  
McEwen A. S. et al. (2007). Mars Reconnaissance Orbiter’s High Resolution Imaging Science Experiment (HiRISE). J. Geophys. Res., 112, E05S02. https://doi.org/10.1029/2005JE002605.  
Murchie S. et al. (2007). Compact Reconnaissance Imaging Spectrometer for Mars (CRISM) on Mars Reconnaissance Orbiter (MRO). J. Geophys. Res., 112, E05S03. https://doi.org/10.1029/2006JE002682. 
