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
  badge <- devex_gadget()
  
  if (!is.null(badge)) {
    txt <- insert_bcgov_devex_badge(badge, cat = FALSE)
    rstudioapi::insertText(text = txt)
  }
  
  invisible(NULL)
}

#' @import shiny
#' @import miniUI
devex_gadget <- function() {
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Choose a Project State"), 
    
    miniContentPanel(
      p("Choose a project state, which is intended to give an indication of where the project is at in the development cycle."),
      radioButtons("stateRadio", "Project State", 
                   choiceNames = list(
                     span(img(src="https://assets.bcdevexchange.org/images/badges/inspiration.svg"), 
                          p("An idea being explored and shaped. Open for discussion, but may never go anywhere.")), 
                     span(img(src="https://assets.bcdevexchange.org/images/badges/exploration.svg"),
                          p("Being designed and built, but in the lab. May change, disappear, or be buggy.")),
                     span(img(src="https://assets.bcdevexchange.org/images/badges/dormant.svg"), 
                          p("Not currently being worked on, but with plans to come back to the work in the future.")), 
                     span(img(src = "https://assets.bcdevexchange.org/images/badges/delivery.svg"), 
                         p("In production, but maybe in Alpha or Beta. Intended to persist and be supported.")),
                     span(img(src="https://assets.bcdevexchange.org/images/badges/retired.svg"), 
                          p("No longer being used or supported, recommend not using an alternative option."))), 
                   choiceValues = c("inspiration", "exploration", "dormant", "delivery", "retired")),
      p("Click 'Done' above once you have made your selection, and it will insert the appropriate HTML code at your cursor location.")
    )
  )
  
  server <- function(input, output, session) {
    observeEvent(input$done, {
      stopApp(input$stateRadio)
    })
    observeEvent(input$cancel, {
      stopApp(NULL)
    })
  }
  
  viewer <- shiny::dialogViewer("BCDevExchange Project State Picker", width = 400, height = 615)
  shiny::runGadget(shiny::shinyApp(ui, server), viewer = viewer,
                   stopOnCancel = FALSE)
}


apache_header_addin <- function() {
  txt <- make_licence_header_text(year = format(Sys.Date(), "%Y"), licence = "apache2")
  write_licence_header(txt, rstudio = TRUE)
}

ccby_header_addin <- function() {
  txt <- make_licence_header_text(year = format(Sys.Date(), "%Y"), licence = "cc-by")
  write_licence_header(txt, rstudio = TRUE)
}

create_project_addin <- function(path, readme_type, repo, licence, coc_email, git_init) {
  
  if (nzchar(repo))  {
    git_init <- FALSE
    if (!nzchar(path)) {
      # this doesn't actually do anything because user can't not put anything into the 'Directory'
      # text box, which is where the 'path' value comes from. But I'm leaving it here because I'd like
      # to be able to do this ;)
      path <- gsub("\\.git$", "", basename(repo))
    }
  }
  
  if (!nzchar(coc_email)) coc_email <- getOption("bcgovr.coc.email", default = NULL)
  
  rmarkdown <- ifelse(readme_type == "README.Rmd", TRUE, FALSE)
  licence <- ifelse(licence == "Apache 2.0", "apache2", "cc-by")
  
  # If repo populated, use usethis::create_from_github first
  create_bcgov_project(path, 
                       rmarkdown = rmarkdown,
                       licence = licence,
                       coc_email = coc_email, 
                       open = FALSE)
  
  if (git_init) {
    check_git_committer_address()
    git2r::init(path)
  }
}
