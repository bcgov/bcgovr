# Copyright 2018 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

.onAttach <- function(libname, pkgname) {
  good_lib <- win_rlib_is_good()
  if (!good_lib$good)
    packageStartupMessage(
"It looks like your R library location is set to somewhere other than your C:/ drive.

  Output of .libPaths():\n    ", 
      paste(good_lib$libs, collapse = "\n    "), "\n\n",
"This can cause problems; it is better to have it on your C:/ drive.
See https://github.com/bcgov/bcgov-data-science-resources/wiki/Installing-R-&-RStudio."
    )
}

win_rlib_is_good <- function() {
  if (.Platform$OS.type != "windows") return(list(good = TRUE))
  list(good = grepl("^[Cc]", .libPaths()[1]),
       libs = .libPaths())
}
