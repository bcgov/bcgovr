
<!-- README.md is generated from README.Rmd. Please edit README.Rmd (this file) -->
<a rel="Delivery" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="In production, but maybe in Alpha or Beta. Intended to persist and be supported." style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/delivery.svg" title="In production, but maybe in Alpha or Beta. Intended to persist and be supported." /></a>

[![Travis-CI Build Status](https://travis-ci.org/bcgov/bcgovr.svg?branch=master)](https://travis-ci.org/bcgov/bcgovr)

------------------------------------------------------------------------

bcgovr
======

An [R](http://r-project.org) package to support development of R-based projects and packages following [bcgov open source guidelines and policies](https://github.com/bcgov/BC-Policy-Framework-For-GitHub).

------------------------------------------------------------------------

### Features

Currently there are two main functions for auto-populating a new R-based data analysis or package project directory with folders & files that encourage best practice in scientific computing and ensure the project has all the [required bcgov items](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md):

-   `analysis_skeleton()` \# starting a new data analysis project
-   `package_skeleton()` \# starting a new R package

The package also installs two [RStudio Addins](https://rstudio.github.io/rstudioaddins/) for adding:

1.  The [boiler-plate Apache 2.0 license header](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Open-Source-Development-Employee-Guide/Licenses.md) into the comments header of every source code file.
2.  A [BCDevExchange project state badge](https://github.com/BCDevExchange/Our-Project-Docs/blob/master/discussion/projectstates.md) to a README file.

------------------------------------------------------------------------

### Installation

Once you have R & RStudio [installed on your machine](https://github.com/bcgov/bcgovr/blob/master/Install_Instructions.md), open up RStudio so you can install the `bcgovr` package directly from this GitHub repository. To do so, you will first need the [devtools](https://github.com/hadley/devtools/) package:

``` r
install.packages("devtools")
```

Next, install and load the `bcgovr` package using `devtools::install_github()`:

``` r
devtools::install_github("bcgov/bcgovr")
library(bcgovr)
```

------------------------------------------------------------------------

### Usage

#### RStudio Addins

**Apache 2.0 License Header**

Need to add that Apache 2.0 license header to a new .R file? Just click-click:

![](img/bcgovr_addin_example.gif)

**BCDevExchange Project State Badge**

Need to add a project state badge to your .md or .Rmd file? Just click-click-click:

![](img/bcgovr_addin_example2.gif)

#### Functions

**analysis\_skeleton**

The analysis\_skeleton function auto-populates a new R-based open source data analysis project with folders & files that encourage best practice in scientific computing and including all of the [required bcgov items](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md).

**Step 1: Set up a [remote repository](https://help.github.com/articles/about-remote-repositories/)**

For a remote in [github.com/bcgov](github.com/bcgov), click on the green **New** button to create a new repository. [Choose a repository name](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Naming-Repos.md)—our example repository name is `bcgovr_analysis`. You should open an empty repository—without initializing a README, a .gitignore file or a license—as `bcgovr` will take care of all of that for you later. Copy the URL of the repository, you'll need it to set up your local repository in the next step.

**Step 2: Set up & populate local repository using `bcgovr`**

*RStudio GUI users:* Open a fresh session of RStudio. Start a New Project: File -&gt; New Project -&gt; Select Version Control from the Create Project menu -&gt; Select Git -&gt; Paste the URL of the github.com/bcgov repository from step 1 in Repository URL and confirm local location of your new project -&gt; Click 'Create Project'. The local project name will be inherited from the remote repository, and your local project is now "connected" to your remote in [github.com/bcgov](github.com/bcgov).

You can now run `analysis_skeleton()` to create a set of folders & files in your local repository.

``` r
bcgovr::analysis_skeleton() ## directly calls the function from `bcgovr` library
## OR
library(bcgovr)
analysis_skeleton()
```

The result is a [bcgov](https://github.com/bcgov) 'ready-to-go' local directory for a new data analysis project:

![](img/analysis_skeleton_output.PNG)

*R/RStudio Console Users:* As an alternative to using the 'New Project -&gt; Version Control...' dialogue in RStudio, you can use the R console and `bcgovr::analysis_skeleton()` to create a new local project. You can specify the URL of the remote repository (from step 1) using the `git_clone` argument. Be sure to either specify your new analysis local directory using the `path` argument, or `setwd("C:/my_bcgov_analysis")` before running `analysis_skeleton()`.

``` r
bcgovr::analysis_skeleton(path = "C:\_dev\bcgovr_analysis", git_clone = "url of remote repository") 
```

**Step 3: Stage, Commit & Push local repository folders & files to remote repository**

*RStudio GUI users:* Now you are ready to Stage, Commit & Push changes in your local repository to the remote repository in [github.com/bcgov](github.com/bcgov). Using the functions in the Git tab in RStudio, you can Stage your changes by selecting files, Commit the staged changes---including informative commit messages---and Push the changes to the remote repository. Remember to make use of the .gitignore file for files & folders you do *not* want to keep under version control (e.g. outputs or source data sets), and to use the Pull function before you start work to ensure your local repository is up-to-date with the remote repository.

*Git Command Line Users:* Stage, Commit & Push changes in your local repository to the remote repository in [github.com/bcgov](github.com/bcgov) using the Command Line (e.g. [Git Bash](https://git-scm.com/downloads) or Terminal).

``` sh
git status # see what file(s) are new or have changed
git add README.md # stage the README file
git commit -m "First commit of README file" # commit the file with an informative message
git push origin master # push the changes in your local repository up to the remote repository
```

You can use the Command Line to [confirm or add the remote url for an existing local project](https://help.github.com/articles/adding-a-remote/). Checkout [GitHubHelp](https://help.github.com/) for more resources for using Git and the Command Line. The [Happy Git and GitHub for the useR](http://happygitwithr.com/) e-book is a great, free resource for learning and using Git and GitHub with R.

``` sh
git remote -v # verifies the new remote URL
git remote add origin https://github.com/bcgov/bcgovr_analysis.git # sets the remote
```

**package\_skeleton**

The `package_skeleton()` function is used the same way as `analysis_skeleton()` but will create all the files & folders to get started on creating an R package. The [R packages](http://r-pkgs.had.co.nz/) book by Hadley Wickham is an incredible resource if you are looking to create packages.

#### Options

There are several options you can specify in your `.Rprofile` file to customise the default behaviour when creating analysis projects and packages with `bcgovr`:

-   `bcgovr.coc.email`: Code of Conduct contact email address
-   `bcgovr.dir.struct`: Alternative analysis directory structure. This should be specified as a character vector of directory and file paths (relative to the root of the project). Directories should be identified by having a trailing forward-slash (e.g., `"dir/"`).

    The default is: `c("R/","out/", "graphics/", "data/", "01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", "internal.R", "run_all.R")`.

To make use of these options, there should a section in your `.Rprofile` file that looks something like this:

``` r
if (interactive()) {
    options("bcgovr.coc.email" = "my.email@gov.bc.ca")
    options("bcgvor.dir.struct" = c("doc/", "data/", "bin/", "results/", "src/01_load.R", "src/02_clean.R",
            "src/03_analysis.r", "src/04_output.R", "src/runall.R"))
} 
```

------------------------------------------------------------------------

### Project Status

This package is under active development.

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [Issue](https://github.com/bcgov/bcgovr/issues/).

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
