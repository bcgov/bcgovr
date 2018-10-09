# bcgovr 1.0.3

* Fixed a bug where if a user supplied `""` to the `dir_struct` argument 
of `create_bcgov_project()` it would throw an error.

# bcgovr 1.0.2

* Bump minimum usethis and git2r version

# bcgovr 1.0.1

* Fixed bugs due to changes in `usethis` internal functions (#45, #46)

# bcgovr 1.0
### 🎉 NO FUNCTION LEFT STANDING 🎉
* Redesigned under-the-hood of `bcgovr`, all functions now wrap a subset of [`usethis`](https://cran.r-project.org/package=usethis) 📦 functions with the addition of bcgov-specific defaults & requirements
* Renamed **all** `bcgovr` functions, functions now start with verbs with easier look-up & auto-complete when using RStudio
* Added an RStudio Addin for inserting the boiler-plate Creative Commons Attribution 4.0 International License header

# bcgovr 0.1.7
* Added ability to start a new analysis or package skeleton via RStudio project templates 
  (New Project -> New Directory -> BC Gov Analysis/Package Skeleton)

# bcgovr 0.1.6
* Default `analysis_skeleton` behaviour doesn't open a new RStudio session

# bcgovr 0.1.5
* Utilized as many usethis functions as was reasonable for bcgov format
* removed devtools dependency
* add nicer messages for what is added to the repo
* removed add_rbuildignore

# bcgovr 0.1.4
* Add new [BCDevExchange Project State Badges](https://github.com/BCDevExchange/assets/blob/master/README.md) to `devex_badge()` and RStudio addin

# bcgovr 0.1.3
* More consistent provision of README files in `analysis_skeleton()` and `package_skeleton()` (#19)
* Tidy formatting of README files

# bcgovr 0.1.2
* Making use of rstudioapi functions
* fixed small bug in `analysis_skeleton()` tests
* Now depends on rstudioapi >=0.7.0

# bcgovr 0.1.1

* Updated README with better instructions (#12)
* Added the ability to customize directory structure in `analysis_skeleton()` (#13)
* Fixed a bug where the `git_clone` argument in `analysis_skeleton()` and `package_skeleton()` didn't work (#14)
* Enhanced the **Insert BCDevex Badge** RStudio Addin (#15)

# bcgovr 0.1

* Initial release.



