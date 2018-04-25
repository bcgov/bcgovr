
<!-- README.md is generated from README.Rmd. Please edit README.Rmd (this file) -->
bcgovr <img src="img/logo.png" align="right" />
===============================================

<a rel="Delivery" href="https://github.com/BCDevExchange/assets/blob/master/README.md"><img alt="In production, but maybe in Alpha or Beta. Intended to persist and be supported." style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/delivery.svg" title="In production, but maybe in Alpha or Beta. Intended to persist and be supported." /></a>[![Travis-CI Build Status](https://travis-ci.org/bcgov/bcgovr.svg?branch=master)](https://travis-ci.org/bcgov/bcgovr)

Overview
--------

An [R](http://r-project.org) package to set up bcgov R projects & packages following [bcgov GitHub guidelines](https://github.com/bcgov/BC-Policy-Framework-For-GitHub).

All B.C. Government employees are responsible for determining whether bcgov R source code can be shared on [bcgov GitHub](https://github.com/bcgov) following the [BC-Policy-Framework-For-GitHub](https://github.com/bcgov/BC-Policy-Framework-For-GitHub).

Features
--------

### Functions

`use_bcgov_github` Open a new bcgov R project with [git version control](https://git-scm.com/), a [bcgov GitHub repository](https://github.com/bcgov), and add files that ensure the project meets [bcgov GitHub requirements](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md).

`use_bcgov_git` Open a new bcgov R project with [git version control](https://git-scm.com/) and add files that ensure the project meets [bcgov GitHub requirements](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md).

`create_bcgov_project` & `create_bcgov_package` Create a new—or populate an existing—R project or package with folders & files that encourage best practice in scientific computing *and* with files that ensure the project meets [bcgov GitHub requirements](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md). These functions can also be used by selecting the [*bcgovr Project Template*](#analysis-and-package-templates) in the [RStudio](https://www.rstudio.com/) New Project dialog box.

`use_bcgov_req` Add files to a new or existing R project that ensure the project meets [bcgov GitHub requirements](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md). You can also add the [required files](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md) individually using `use_bcgov_contributing`, `use_bcgov_licence`, `use_bcgov_readme`, `use_bcgov_code_of_conduct`.

### Addins

The `bcgovr` package installs a set of [RStudio Addins](https://rstudio.github.io/rstudioaddins/):

1.  Insert the [boiler-plate Apache 2.0 license header](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Open-Source-Development-Employee-Guide/Licenses.md) into the comments header of a source file (uses `insert_bcgov_apache_header`).
2.  Insert the [boiler-plate Creative Commons Attribution 4.0 International License header](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Open-Source-Development-Employee-Guide/Licenses.md) into the comments header of a source file (uses `insert_bcgov_cc_header`).
3.  Insert a [BCDevExchange project state badge](https://github.com/BCDevExchange/assets/blob/master/README.md) into an .Rmd or .md file (uses `insert_bcgov_devex_badge`).

Installation
------------

You can install `bcgovr` directly from this GitHub repository. To do so, you will need the [remotes](https://cran.r-project.org/web/packages/remotes/index.html) package:

``` r
install.packages("remotes")
```

Next, install and load the `bcgovr` package using `remotes::install_github()`:

``` r
remotes::install_github("bcgov/bcgovr")
library(bcgovr)
```

Usage
-----

### I WANT TO...

<details><summary><strong>Open a new bcgov R project using git & GitHub</strong></summary>

<br />

some text here

<br />

</details>

<details><summary><strong>Open a new bcgov R project using git (<i>without</i> GitHub)</strong></summary>

<br />

some text here

<br />

</details>

<details><summary><strong>Create a new—or populate an existing—bcgov R project or package with a 'ready-to-go' folder & file structure</strong></summary>

<br />

Start a New Project in RStudio: New Project -&gt; New Directory -&gt; BC Gov Project/Package. Confirm the local location of the project in the *Directory Name* field. Check/uncheck and fill in the other fields as relevant to the project, and click 'Create Project'. The template `bcgovr` files and folders will be created in the new directory. For using different project templates, see the [Options](#options) section below.

![](img/bcgovr_proj_templat.gif)

The result is a 'ready-to-go' local directory for a new R project:

![](img/analysis_skeleton_output.PNG)

As an alternative to using the 'New Project -&gt; ...' dialogue box in RStudio, you can use the R console and `bcgovr::create_bcgov_project()` to create a new local project. Be sure to either specify your local directory using the `path` argument, or `setwd("C:/my_bcgov_analysis")` before running `create_bcgov_project()`. Type `?create_bcgov_project` in the R console for help.

``` r
bcgovr::bcgovr::create_bcgov_project(path = "C:\_dev\bcgovr_analysis") 
```

The `create_bcgov_package()` function is used the same way as `create_bcgov_project()` but will create all the files & folders to get started on creating an R package. Type `?create_bcgov_package` in the R console for help. The [R packages](http://r-pkgs.had.co.nz/) book by Hadley Wickham is an incredible resource if you are looking to create packages.

<br />

</details>

<details><summary><strong>Add all or some of the required GitHub files to my bcgov R project or package</strong></summary>

<br />

Add the [bcgov GitHub required](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md) files—a LICENSE, a README, a CODE OF CONDUCT and a CONTRIBUTING file—to any new or existing bcgov R project or package using `use_bcgov_req()`. Type `?use_bcgov_req` in the R console for help.

You can use the `licence`, `coc_email` & `rmarkdown` arguments to change the default Apache 2.0 licence, add your contact details to the Code of Conduct, or decline a README.Rmd file—maybe you only want a README.md?

``` r
use_bcgov_req(licence="cc-by", rmarkdown=FALSE, coc_email="my.email@gov.bc.ca")
```

You can also add the individual required files as needed using:

``` r
use_bcgov_licence()
use_bcgov_readme()
use_bcgov_contributing()
use_bcgov_code_of_conduct(coc_email="my.email@gov.bc.ca")
```

<br />

</details>

<details><summary><strong>Insert a licence header to a source file</strong></summary>

<br />

Need to insert that Apache 2.0 or Creative Commons licence header to a source file? Just click-click:

![](img/bcgovr_addin_example.gif)

You can also use `insert_bcgov_apache_header()` or `insert_bcgov_cc_header()`.

<br />

</details>

<details><summary><strong>Insert a BCDevExchange project state badge to a README file</strong></summary>

<br />

Need to add a Project State Badge to your README file? Just click-click-click:

![](img/bcgovr_addin_example2.gif)

You can also use `insert_bcgov_devex_badge("inspiration")`. Type `?insert_bcgov_devex_badge` in the R console for the list of badge options and other help.

</details>

### Options

There are several options you can specify in your `.Rprofile` file to customise the default behaviour when using the `create_bcgov_` and `use_bcgov_` functions in `bcgovr`.

-   `bcgovr.coc.email`: Code of Conduct contact email address
-   `bcgovr.dir.struct`: Alternative project directory structure for `create_bcgov_project()`. This should be specified as a character vector of directory and file paths (relative to the root of the project). Directories should be identified by having a trailing forward-slash (e.g., `"dir/"`).

    The default is: `c("out/", "graphics/", "data/", "01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", "internal.R", "run_all.R")`.

To make use of these options, there should be a section in your `.Rprofile` file that looks something like this:

``` r
if (interactive()) {
    options("bcgovr.coc.email" = "my.email@gov.bc.ca")
    options("bcgvor.dir.struct" = c("doc/", "data/", "results/", "src/01_load.R", "src/02_clean.R",
            "src/03_analysis.R", "src/04_output.R", "src/runall.R"))
} 
```

Project Status
--------------

This package is under active development.

Getting Help or Reporting an Issue
----------------------------------

To report bugs/issues/feature requests, please file an [Issue](https://github.com/bcgov/bcgovr/issues/).

How to Contribute
-----------------

If you would like to contribute to the package, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

License
-------

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
