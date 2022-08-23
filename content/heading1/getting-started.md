---
title: Getting Started
weight: -20
---

This page describes this template, which is compliant with:

- [USGS OCAPs digital identity requirements](https://atthecore.usgs.gov/science-support/ocap-digital-services/web-applications-vis-id)
- [US Digital Analyics Program (DAP) requirements](https://github.com/digital-analytics-program/gov-wide-code)
- [USWDS Banner requirements](https://designsystem.digital.gov/components/banner/) as described by the previously linked OCAPS page.

Since this page is making use of the USWDS3.0 banner, it is also able to make sure of any of the other components within the pages. To make use of those components, ensure that the paths are properly set. The `gulp.js` file documents the output paths for the files.

{{< toc >}}

## Install requirements
This project makes use of `npm`. To setup, run `npm install`. After installation of dependencies, one can run:

- `npm run serve` to start the development server (http://localhost:1313)
- `npm run build` to build the project for deploy
- `npm run clean` to remove the build, resources, and public directories.

