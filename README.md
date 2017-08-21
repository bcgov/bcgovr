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

If you have not already installed R itself or RStudio on a BC Government computer, you can follow these [installation instructions](https://github.com/bcgov/bcgovr/blob/master/Install_Instructions.md) to get set up using R.

Once you have R & RStudio installed on your machine, open up RStudio so you can install the `bcgovr` package directly from this repository. To do so, you will first need the [devtools](https://github.com/hadley/devtools/) package:

``` r
install.packages("devtools")
```

Next, install the `bcgovr` package using `devtools::install_github()`:

``` r
devtools::install_github("bcgov/bcgovr")
```

------------------------------------------------------------------------

### Usage

#### analysis\_skeleton

The analysis\_skeleton function auto-populates a new R-based open source data analysis project with folders & files that encourage best practice in scientific computing and including all of the [required bcgov items](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md).

**Step 1: Set up a [remote repository](https://help.github.com/articles/about-remote-repositories/)**

For a remote in [github.com/bcgov](github.com/bcgov), click on the green **New** button to create a new repository. [Choose a repository name](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Naming-Repos.md)---our example repository name is `bcgovr_analysis`. You can open an empty repository---without initializing a README, a .gitignore file or a license--- as `bcgovr` will take care of all of that for you later. Copy the URL of the repository, you'll need it to set up your local repository in the next step.

**Step 2: Set up and populate local repository using `bcgovr`**

*RStudio GUI users:* Open a fresh session of RStudio where you will open your New Project. By default, RStudio will create any New Project in the current working directory. You can check the working directory using `getwd()`. Set your preferred local working directory in the R console (e.g. `setwd(C:/_dev)`) or using the RStudio navigation tools (Session -&gt; Set Working Directory -&gt; Choose Directory...). Now open your New Project: Select Version Control from the Create Project menu -&gt; Select Git -&gt; Paste the URL of the github.com/bcgov repository from step 1 in Repository URL -&gt; Click 'Create Project'. The local project name will be inherited from the remote repository, and your local project is now "connected" to your remote in [github.com/bcgov](github.com/bcgov).

You can now run `analysis_skeleton()` to create a 'ready-to-go' set of folders & files in your local repository that encourage best practice in scientific computing and include all of the [required bcgov items](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Cheatsheet.md).

``` r
bcgovr::analysis_skeleton() ## directly calls the function from `bcgovr` library
## OR
library(bcgovr)
analysis_skeleton()
```

*R/RStudio Console Users:* You can set your local working directory in the R/RStudio Console (e.g. `setwd(C:/_dev)`) or you can use the `path` argument in `analysis_skeleton` to set the path where you want your local repository to exist. Supply the remote location using the `clone_git` argument.

``` r
bcgovr::analysis_skeleton(path = "C:\_dev\bcgovr_analysis", clone_git = "url of remote repository") 
```

This should result in a [bcgov](https://github.com/bcgov) 'ready-to-go' local directory for a new data analysis project:

![](img/analysis_skeleton_output.PNG)

**Step 3: Stage, Commit & Push local repository folders & files to remote repository**

*RStudio GUI users:* Now you are ready to Stage, Commit & Push changes in your local repository to the remote repository in [github.com/bcgov](github.com/bcgov). Using the functions in the Git tab in RStudio, you can Stage your changes by selecting files, Commit the staged changes---including informative commit messages---and Push the changes to the remote repository. Remember to make use of the .gitignore file for files & folders you do *not* want to keep under version control (e.g. outputs or source data sets), and to use the Pull function before you start work to ensure your local repository is up-to-date with the remote repository.

*Git Command Line Users:* Stage, Commit & Push changes in your local repository to the remote repository in [github.com/bcgov](github.com/bcgov) using the Command Line (e.g. [Git Bash](https://git-scm.com/downloads) or Terminal).

    ``` sh
    git add README.md # stage the README file OR
    git add . # stage all the changes in the local repo
    git commit -m "First commit of analysis_skeleton files" # commit the files with an informative message
    git push origin master # pushes the changes in your local repository up to the remote repository
    ```

You can use the Command Line to [confirm or add the remote url for an existing local project](https://help.github.com/articles/adding-a-remote/). Checkout [GitHubHelp](https://help.github.com/) for more resources for using Git and the Command Line.

    ``` sh
    git remote -v # verifies the new remote URL
    git remote add origin https://github.com/bcgov/bcgovr_analysis.git # sets the remote
    ```

#### package\_skeleton

The `package_skeleton()` function is used the same way as `analysis_skeleton()` but will create all the files & folders to get started on creating an R package. The [R packages](http://r-pkgs.had.co.nz/) book by Hadley Wickham is an incredible resource if you are looking to create packages.

#### Options

-   **Code of Conduct contact email address:** To avoid having to always edit your Codes of Conduct to add contact email addresses you can add this line to your `.Rprofile` file:

``` r
if (interactive()) options("bcgovr.coc_email" = "my.email@gov.bc.ca")
```

#### RStudio Addins

Using RStudio and need to add that Apache 2.0 license header in new .R file or a project state badge? Just click twice:

![](img/bcgovr_addin_example.gif)

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
