---
title: "Setting QGIS Environment Variables for Performant Streaming"
date: 2023-04-26
draft: false
weight: 21
---

{{< hint type=warning title="Draft" >}}
This is a work in progress. Please feel free to test, but use with caution!
{{< /hint >}}

In this tutorial, you will learn how to:
- set QGIS environment variables for performant data streaming

This tutorial describes how to setup QGIS for faster data streaming from remote resources. This tutorial has drawn heavily from the terrific work done by the TiTiler team and their dynamic tiler [performance tuning guide](https://developmentseed.org/titiler/advanced/performance_tuning/#recommended-configuration-for-dynamic-tiling).

## Prerequisites
This tutorial requires that you have the following tools installed on your computer:

| Software Library or Application | Version Used |
| ------------------------------- | ------------ |
| [QGIS](https://www.qgis.org/en/site/forusers/download.html) | 3.30.1 |

## 1. QGIS Setup
First, launch QGIS and open *Settings* -> [*Options*](https://docs.qgis.org/3.28/en/docs/user_manual/introduction/qgis_configuration.html?highlight=environment%20variables#options) dialog.


 {{< figure src="/images/tutorials/qgis_environment_variables/settings.png" alt="A PNG showing general settings dialog." title="The *General* settings page visible when opening the *Options* dialog." >}}

Next select *System* on the left side of the *Options* dialog. Scroll to the *Environment* section. To add an environment variable, click the large green plus sign. For each, variable added, set the *Apply* to *Overwrite*. The table below shows the variables to be set.

| Variable | Value | Rationale |
| -------- | ----- | --------- |
| CPL_VSIL_CURL_ALLOWED_EXTENSIONS| .tif,.TIF,.tiff | Attempt to read only TIF files remotely using VSI. This limits the scanning done by QGIS for other file types. |
| GDAL_CACHEMAX | 200 | Sets the cache for GDAL to be 200MB. (Optionally increase the size further). |
| CPL_VSIL_CURL_CACHE_SIZE | 200000000 | Sets the VSI cache to be 200MB. (Optionally increase the size further). |
| GDAL_BAND_BLOCK_CACHE | HASHSET | See [here](https://gdal.org/development/rfc/rfc26_blockcache.html) |
| GDAL_DISABLE_READDIR_ON_OPEN | EMPTY_DIR | Very important to reduce the number of get requests on the remote resources. |
| GDAL_HTTP_MERGE_CONSECUTIVE_RANGES | YES | Tells GDAL to merge consecutive GET requests. |
| GDAL_HTTP_MULTIPLEX | YES | Improved performance if files are proxied through cloudfront. |
| GDAL_HTTP_VERSION | 2 | Improved performance if files are proxied through cloudfront. |
| VSI_CACHE | TRUE | Enable VSI caching |
| VSI_CACHE_SIZE | 5000000 | Increase the VSI cache size |

 {{< figure src="/images/tutorials/qgis_environment_variables/environment.png" alt="A PNG showing environment variables filled in." title="The *Environment* section of the *Options* dialog showing some of the above environment variables populated." >}}

Once each of these environment variables has been added, restart QGIS.

## Conclusion
That's it! Your QGIS application is now setup for more efficient use of remote resources. If you have questions or comments consider chatting below.

## Discuss this Tutorial
{{< comments >}}

-----------------------------------------

### Disclaimers
> Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.