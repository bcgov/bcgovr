<!-- README.md is generated from README.Rmd. Please edit that file -->
<a rel="Exploration" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="Being designed and built, but in the lab. May change, disappear, or be buggy." style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/exploration.svg" title="Being designed and built, but in the lab. May change, disappear, or be buggy." /></a>

[![Travis-CI Build Status](https://travis-ci.org/bcgov/bcgovr.svg?branch=master)](https://travis-ci.org/bcgov/bcgovr)

------------------------------------------------------------------------

bcgovr
======

An [R](http://r-project.org) package to support development of R-based projects and packages following [bcgov open source guidelines and policies](https://github.com/bcgov/BC-Policy-Framework-For-GitHub).

### Features

Currently there are two main functions for auto-populating a new R-based data analysis or package project directory:

-   `analysis_skeleton()` \# starting a new data analysis project
-   `package_skeleton()` \# starting a new R package

The package also installs two [RStudio Addins](https://rstudio.github.io/rstudioaddins/) for adding:

1.  the [boiler-plate Apache 2.0 license header](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Open-Source-Development-Employee-Guide/Licenses.md) into the comments header of every source code file.
2.  a [BCDevExchange project state badge](https://github.com/BCDevExchange/Our-Project-Docs/blob/master/discussion/projectstates.md) to a README file.

### Installation

You can install the package directly from this repository. To do so, you will need the [devtools](https://github.com/hadley/devtools/) package:

``` r
install.packages("devtools")
library("devtools")
```

Next, install the `bcgovr` package using `devtools::install_github()`:

``` r
install_github("bcgov/bcgovr")
```

### Usage

Auto-populate a new R-based open source data analysis or package project directory, including all of the [required bcgov items](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md), with `analysis_skeleton` or `package_skeleton`:

``` r
library(bcgovr)
analysis_skeleton(path = ".") # path = location to create new analysis. If path = "." the name of 
                              # the working directory will be taken as the analysis name. 
```

Resulting in a [bcgov](https://github.com/bcgov) 'ready-to-go' directory for a new data analysis project:

![](img/analysis_skeleton_output.PNG)

Using RStudio and need to add that Apache 2.0 license header in new .R file? Just click twice:

![](img/bcgovr_addin_example.gif)

### Project Status

This package is under active development.

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [issue](https://github.com/bcgov/bcgovr/issues/).

### How to Contribute

If you would like to contribute to the package, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

### License

    Copyright 2017 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at 

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

This repository is maintained by [Environmental Reporting BC](http://www2.gov.bc.ca/gov/content?id=FF80E0B985F245CEA62808414D78C41B). Click [here](https://github.com/bcgov/EnvReportBC-RepoList) for a complete list of our repositories on GitHub.
