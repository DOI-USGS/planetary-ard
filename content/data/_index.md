+++
title = "Data"
date = 2021-08-28T05:40:13-07:00
weight = 100
chapter = true
+++

This section describes the analysis ready data currently available. Each data product follows a consistent descriptive format, described below. The goal of these data descriptions is to ensure all data users are comfortable assessing the fitness for use of the data (i.e., making data driven decisions) and building comfort in asking data specific questions.

In the data section, larger topics, that span multiple different data sets (e.g., spacecraft jitter and the effect on data) may be mentioned and then linked into the [learning](({{< ref "/learning/_index.md" >}})) section of the site. Be on the lookout for link to the more general topics that should help build a solid knowledge base when using these data.

Each description of a data product contains the following information:

- Overview: Description of the data set available. 
- Processing: Information on how the data set was generated, including calibration, geometric, and other processing that was performed. The intent is that one could regenerate these data with the information provided. 
- Available Assets:  Describes the additional data products available under the “Assets” tab in the data area that are available for download. The assets available will be specific to each dataset and are described in this field. 
- Accuracy, Errors, and Issues: Information regarding the accuracy of the products available (e.g., horizontal accuracy relative to an accepted base standard), and known errors or issues in the dataset. Examples of known errors or issues might include dropped data in the original dataset, data gaps, or the presence of jitter. 
- General Usability:  Qualitative metadata and cautionary statements for the user to consider. 
- Related Data: Other data products that may be of interest to a user, such as other available datasets that overlap the product of interest. 

## Links to the Data and Search API

| Release Date | Description | Link |
| :------: | --------------------- | :--------------: |
| May 2022 | The STAC compliant search API is now live and available for use. All previously released data sets are loaded into the search API. [Tutorials]({{< ref "/tutorials/_index.md" >}}) and [examples]({{< ref "/examples/_index.md" >}}) are published demonstrating usage via the command line and inside of Jupyter notebooks. | [API LINK](https://stac.astrogeology.usgs.gov/api) |
| June 2022 | USGS produced [absolutely controlled](https://fdp.astrogeology.usgs.gov/fdp/) Mars Odyssey Thermal Emission Imaging System (THEMIS). Data documentation is available [here]({{< ref "/data/mars/themis.md" >}}). | [Observations in STAC Browser](https://stac.astrogeology.usgs.gov/browser-dev/#/collections/themis_usgs_photogrammetrically_controlled_observations) |
| July / August 2022 | Kaguya/SELENE terrain camera (TC) images are being incrementally uploaded and added to the search API. | [Monoscopic Observations in Stac Browser](https://stac.astrogeology.usgs.gov/browser-dev/#/collections/kaguya_monoscopic_uncontrolled_observations)