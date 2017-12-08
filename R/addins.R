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
    txt <- devex_badge(badge, cat = FALSE)
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
      p("Choose a project state, which is intended to give a rough indication of where the project is at in its development."),
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


license_header_addin <- function() {
  txt <- make_license_header_text(year = format(Sys.Date(), "%Y"), copyright_holder = "Province of British Columbia")
  rstudioapi::insertText(location = c(1,1), text = txt)
}

skeleton_addin <- function(path, package, git_init, repo, CoC, coc_email, apache, copyright_holder, readme_type) {
  
  if (nzchar(repo))  {
    git_init <- FALSE
    if (!nzchar(path)) {
      # this doesn't actually do anything because user can't not put anything into the 'Directory'
      # text box, which is where the 'path' value comes from. But I'm leaving it here because I'd like
      # to be able to do this ;)
      path <- gsub("\\.git$", "", basename(repo))
    }
  }
  
  args <- list(path = path, 
               git_init = git_init, 
               git_clone = if (nzchar(repo)) repo else NULL, 
               apache = apache, 
               rstudio = TRUE, 
               CoC = CoC, 
               coc_email = coc_email,
               copyright_holder = copyright_holder,
               rmarkdown = ifelse(readme_type == "README.Rmd", TRUE, FALSE))
  
  fun <- switch(as.character(package), "TRUE" = package_skeleton, "FALSE" = analysis_skeleton)
  
  do.call(fun, args)
}
