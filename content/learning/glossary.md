---
title: "Glossary"
---

Albedo
: The fraction of incoming light that is reflected from the surface. Related to, but not identical to, I/F. 

Bundle adjustment
: The process of updating estimates of camera and image position and pointing during image registration to bring images into alignment. All such estimates from raw SPICE data have some uncertainty; comparing multiple images can improve them.    
 
Camera model
: See [Sensor Model]({{< ref "#sensor-model" >}}).

CCD
: Charge-Coupled Device, a type of detector used in many planetary sensors to record image data. 

Control, geodetic control, photogrammetric control, control network
: Controlling images refers to registering images to each other (relative control) and/or to an established reference surface (absolute control). This is accomplished via a control network that may include control points (links between the images and the reference surface) and/or tie points (links between images).  

DN
: Digital Number, the numeric value of a pixel in a raster image. 

DTM/DEM
: Digital Terrain Model or Digital Elevation Model, a data set giving surface topography. For planetary data, these terms are generally used interchangeably; on Earth, Terrain indicates the ground surface while Elevation my include trees and buildings.  

Ellipsoid
: The shapes of planetary bodies are commonly described to first order as bi- or tri-axial ellipsoids, particularly for bodies that are large enough for gravity to create a rounded shape. Bi-axial ellipsoids typically account for flattening of the body due to spin, while tri-axial ellipsoids often result from tidal deformation leading to a long axis aligned towards the source of the tide.  

Emission angle
: The angle between a vector pointing to the camera and the local vertical direction.  

Ephemeris
: A table of the position of a spacecraft, planet, or other solar system body over time.  

Framing camera
: A framing camera is one that takes an image from all pixels in the field of view simultaneously.  

Geodetic Reference system, coordinate system, reference frame
: Terms for a set of information that defines position on a planetary body, which includes the definition of north and the equator which define the latitude system, the prime meridian (defined by some surface feature) which sets the zero point for longitude, and the shape of the body, which defines the vertical reference system.  

Geoid, datum
: A geoid is a surface of constant gravity (equipotential surface) which is always normal to the local gravitational acceleration. It may serve as the datum used as a reference for the elevation of the surface on a planetary body. This is the appropriate surface against which to reference topographic models, rather than a sphere or ellipsoid.  

I/F
: Intensity/flux, a measure of reflectance. This is the ratio of the radiance observed by an imager with the radiance expected from a Lambertian reflector (one that reflects light evenly in all directions) that is both viewed and illuminated from directly overhead and that reflects 100% of incoming light. Related to, but not identical to, albedo.  

Incidence angle
: The angle between a vector pointing to the Sun and the local vertical direction.  

Jitter
: High-frequency variations in spacecraft pointing which is not resolved by the SPICE kernels that describe the pointing history. This can be caused by moving parts on the spacecraft, such as gimbals. This is a common source of error in some DTMs from pushbroom-type cameras.  

Phase angle
: The angle between a vector pointing to the Sun and another vector pointing to the camera.     

Pushbroom/line-scan camera
: A pushbroom or line-scan camera is one that captures only one line (a row of pixels) at a time, and builds up a larger image as the surface moves under the spacecraft.  

Reseau marks
: Markings on camera optics used to correct geometric distortions of images, used in cameras for older planetary missions.  
 
[Sensor Model](@)
: A camera model is a mathematical model (a set of equations, usually implemented in software) that relates the geometry of a three-dimensional object to the two-dimensional image data. These are a subset of sensor models, which include other sensors (like radar) that are not cameras.  

SPICE, SPICE kernel, kernel
: SPICE stands for Spacecraft ephemeris, Planet ephemeris, Instrument information, C-matrix, Events. SPICE kernels are files containing information on the position and orientation of spacecraft, instruments, and various planets, moons, asteroids, and comets. These kernels are provided by the Navigation and Ancillary Information Facility (NAIF) at the Jet Propulsion Laboratory.  

Level 1, etc.
: Descriptions of the processing level of camera data, following the typical flow of image processing. Level 0 is raw camera data. Level 1 data has been radiometrically calibrated, and Level 2 data has been map-projected. 

Map Projection
: (1) A projected format (described by equations) that transforms the curved surface of a planetary body into a flat, two-dimensional form that can be easily represented on a computer screen or a sheet of paper. All such projections have some distortion (i.e., the shape of features is changed from its 3-D shape) which can be more or less severe depending on the specific projection and the size and position of the image. For example, simple cylindrical projection, where latitude and longitude are treated as XY coordinates, produces little distortion near the equator but severely deforms the shape of features near the poles. (2) The act of converting data (such as a camera image) from the raw collected form to one that conforms to the projection, using the size and shape of the planet and the camera pointing information and camera model.   

Orthorectification, orthoimage
: An orthorectified image or orthoimage is one that has been projected onto a DTM, so that each pixel appears as it would if viewed from directly overhead. This removes parallax distortion from topography and oblique viewing. Ideally, the post spacing and resolution of the DTM are close to that of the image, allowing such distortion to be fully removed.  
 
Parallax
: The phenomenon where an object looks different, or a foreground object appears to move relative to a distant one, when seen from different angles. This is the key phenomenon that allows stereogrammetry to work, and also a source of distortion and mis-registration in images that have not been orthorectified.

Photometry, photometric correction
: In planetary science, photometry is the study of how light interacts with and reflects off surfaces. The most basic application of this is that different amounts of light are reflected in different directions, in ways that vary depending on the surface properties. Photometric correction refers to efforts to compensate for these effects by adjusting images to uniform viewing conditions. 

Radiometric calibration
: (1) The process of calibrating an image to convert from the raw values output from the camera electronics to physically meaningful units and correct for flaws or variable response patterns in the detector. (2) The process of collecting camera data and deriving equations that are used in the first sense. 

 Registration
: Image registration is the alignment of images so that the same features in two or more different images are at the same place.  
 
Resolution, pixel scale, ground sampling distance (GSD), post spacing, instantaneous field of view (IFOV)
: The instantaneous field of view (IFOV) is the angular size of the scene that inputs signal into a single detector element in a sensor such as a camera. Pixel scale refers to the size of a pixel in an image at the surface in question; if data have not been resampled, it is the width of the IFOV at the distance from the spacecraft to the target. Ground sample distance is more or less equivalent to pixel scale, although if an image has been significantly resampled relative to the raw camera data then pixel scale may be more precise wording. Post spacing is the same quantity for a DTM: the horizontal distance between adjacent elevation posts in the XY plane. All three essentially describe the physical size of a single element of raster data. For images that cover large areas, and especially with oblique views, they may vary across the raster. Resolution is often used in the same sense as pixel scale or post spacing; however, an alternate definition of resolution is the smallest feature that can be separated from other features and measured; this lacks a sharp definition but three pixels is a common estimate, as a two-pixel feature could actually be a small sub-pixel feature straddling the pixel boundary. The latter definition of resolution is distinct in an important way: it relates to the real quality of the data, independent of whether it is over-sampled (either within the camera or during later processing).  
 
Stereo, stereogrammetry, photogrammetry
: Stereo or stereogrammetry are terms generally used to describe collection of image data from two different viewing angles and use of those data to derive the surface topography (DTMs or point clouds) using parallax. Photogrammetry is a broader term for making measurements based on photos or images.  

Tie point
: An identified common point (same spot or feature on the surface) in two or more images, used to register and control images.  