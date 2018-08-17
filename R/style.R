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

done <- function(...) {
  cat(paste0(crayon::green(clisymbols::symbol$tick), " ", ...), 
      "\n", sep = "")
}

not_done <- function(...) {
  cat(paste0(crayon::red(clisymbols::symbol$cross), " ", ...), 
      "\n", sep = "")
}

congrats <- function(...) {
  cat(paste0(crayon::yellow(clisymbols::symbol$star), " ", ...), 
      "\n", sep = "")
}

colour_string <- function(...) {
  crayon::blue(encodeString(paste0(...), quote = "'"))
}
