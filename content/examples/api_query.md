---
title: "Query the API using sat-search"
date: 2021-10-20T11:55:21-07:00
geekdocHidden: true
---

In this example, we will walk through a number of different queries that can be submitted to the USGS STAC API in order to discover and download data. This example is organized in order of what see as increasing complexity. First, we will walk through funding data for a single body. Then we will add a spatial filter. Finally, we will layer on a more complex attribute query in order to find data that meets a series of criteria. In terms of plan language questions, we will show how to answer the following using the command line tool sat-search.

1. What Europa data are available?
1. What Europa data are available in my area of interest?
1. What Europa data are available in my area of interest that have a pixel resolution less than X?
1. What Europa data are available in my area of interest that have a pixel resolution less than X and viewing geometry parameters in some range?

Let's get started!

{{% notice note %}}
If you are wondering what sat-search is and what this example is all about, head over to our tutorial [Discovering and Downloading Data via the Command Line]({{< ref "/tutorials/cli.md" >}}).
{{% /notice %}}

## What Europa data are available?

Two options exist for finding body specific information. The first option is to know the computer name of the STAC collection that you wish to search. For this example, we actually want to search over two different (at the time of writing) STAC collections. Here is an example of such a query:

### Questions or Comments?
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