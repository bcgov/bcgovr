<a rel="Exploration" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="Being designed and built, but in the lab. May change, disappear, or be buggy." style="border-width:0" src="http://bcdevexchange.org/badge/2.svg" title="Being designed and built, but in the lab. May change, disappear, or be buggy." /></a>

---

# envreportutils

A few functions that the Environmental Reporting BC team uses to be more
efficient in the code we write. Most of the functions relate to plotting with 
the [ggplot2](http://ggplot2.org/) plotting package by Hadley Wickham.

### Features

Currently there are five main functions:

#### Plotting

- `multiplot()` - combine multiple `ggplot2` plots into one
- `theme_soe()` - our default theme for the graphs we make
- `theme_soe_facet()` - default theme for plots using facetting

#### Miscellaneous

- `roxygen_template()` - Add boilerplate documentation to a function using
  [Roxygen2](https://github.com/klutometis/roxygen) syntax.
- `analysis_skeleton()` - Set up the folder structure for a new analysis

### Installation

You can install the package directly from this repository. To do so, you will 
need the [devtools](https://github.com/hadley/devtools/) package:

```R
install.packages("devtools")
```

Next, install the `envreportutils` package using `devtools::install_github()`:

```R
library("devtools")
install_github("bcgov/envreportutils")
```

### Project Status

This package is under continual development.

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [issue](https://github.com/bcgov/envreportutils/issues/).

### How to Contribute

If you would like to contribute to the package, please see our 
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

### License

    Copyright 2015 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at 

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
