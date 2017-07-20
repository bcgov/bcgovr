# Copyright 2017 Province of British Columbia
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

#' @importFrom rstudioapi insertText getActiveDocumentContext

devex_badge_addin <- function() {
  txt <- "
```{r echo=FALSE, results='asis'}
## Insert 'inspiration', 'exploration', or 'delivery'
bcgovr::devex_badge('')
```
"
  rstudioapi::insertText(text = txt)
}

license_header_addin <- function() {
  txt <- make_license_header_text()
  rstudioapi::insertText(location = c(1,1), text = txt)
}


