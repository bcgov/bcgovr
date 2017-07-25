# Copyright 2016 Province of British Columbia
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

#' Returns a url, or a markdown or html-formatted link to one of several B.C. or Canadian licences
#'
#' @param license Which license? One of:
#' \itemize{
#'   \item ogl-bc Open Government Licence - British Columbia
#'   \item bc-crown B.C. Crown Copyright
#'   \item ogl-canada Open Government Licence - Canada
#'   \item statscan Statistics Canada Open Licence Agreement
#' }
#' @param what What do you want returned? One of
#' \itemize{
#'   \item md_link A markdown-formatted link (default)
#'   \item html_link An HTML-formatted link
#'   \item url The url of the license
#' }
#'
#' @return character containing the desired output
#' @export
#'
#' @examples
#' get_data_license("ogl-bc", "url")
#' 
#' get_data_license("ogl-canada")
#' 
#' get_data_license("statscan", "html_link")
get_data_license = function(license = c("ogl-bc", "bc-crown", "ogl-canada", "statscan"), 
                            what = "md_link") {
  what <- match.arg(what, c("url", "md_link", "html_link"))
  licenses <- list("ogl-bc" = c(name = "OGL-BC", 
                                href = "http://www2.gov.bc.ca/gov/content?id=A519A56BC2BF44E4A008B33FCF527F61"),
                   "bc-crown" = c(name = "B.C. Crown Copyright", 
                                  href = "http://www2.gov.bc.ca/gov/content?id=1AAACC9C65754E4D89A118B875E0FBDA"),
                   "ogl-canada" = c(name = "Open Government License - Canada", 
                                    href = "http://open.canada.ca/en/open-government-licence-canada"),
                   "statscan" = c(name = "Statistics Canada Open Licence Agreement", 
                                  href = "http://www.statcan.gc.ca/eng/reference/licence"))
  lic <- licenses[[license]]
  switch(what, 
         url = lic["href"], 
         md_link = paste0("[", lic["name"], "](", lic["href"], ")"),
         html_link = paste0("<a href='", lic["href"], "'>", lic["name"], "</a>"))
}
