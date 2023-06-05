# USGS Analysis Ready Data Website
This is the website for the USGS analysis ready data offerings. The rendered site is available for browsing [here](https://stac.astrogeology.usgs.gov/docs). 

Issues and pull requests are absolutely welcome in this repository. The intention behind having publicly available source code is to engage with the community.

#### To install dependencies:
Execute `npm install` from the root directory.

#### To run locally:
Execute `npm run serve` from the root directory. The site will then run at `http://localhost:1313/docs`

#### To create a new data product entry:
Execute `hugo new data/<body>/<product_name>.md` where `body` is the name of the target body (e.g., `mars`) or a two part path if the body is a moon of a major body (e.g., `jupiter/europa`), and `product_name` is a unique descriptive name for the data product (e.g., `myinstitution_uncontrolled_senorname_observations`).

In the newly created file make sure to:
- Add the STAC collection id to the `collection` parameter in the head material.
- Add a citation in the cite these data section.
- Complete the other sections to keep the documentation structure inline with other ARD docs.

#### To create a new tutorial:
Execute `hugo new tutorials/<tutorial_name>.md` where `<tutorial_name>` is a unique name for the tutorial. Once the template is created, please check the inline comments that described areas that we would like to maintain to keep a consistent feel to all tutorials. For example, providing an image of the final product of the tutorial at the head of the file.