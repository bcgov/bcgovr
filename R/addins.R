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

lifecycle_badge_addin <- function() {
  badge <- lifecycle_gadget()
  
  if (!is.null(badge)) {
    txt <- insert_bcgov_lifecycle_badge(badge, cat = FALSE)
    rstudioapi::insertText(text = txt)
  }
  
  invisible(NULL)
}

lifecycle_gadget <- function() {
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Choose a Project State"), 
    
    miniUI::miniContentPanel(
      shiny::p("Choose a project state, which is intended to give an indication of where the project is at in the development cycle."),
      shiny::radioButtons(
        "stateRadio", "Project State", 
        choiceNames = list(
          shiny::span(
            shiny::img(src = "https://img.shields.io/badge/Lifecycle-Experimental-339999"), 
            shiny::p("The project is in the very early stages of development. The codebase will be changing frequently.")), 
          shiny::span(
            shiny::img(src = "https://img.shields.io/badge/Lifecycle-Maturing-007EC6"),
            shiny::p("The codebase is being roughed out, but finer details are likely to change.")),
          shiny::span(
            shiny::img(src = "https://img.shields.io/badge/Lifecycle-Stable-97ca00"), 
            shiny::p("The project is in a reliable state and major changes are unlikely to happen.")), 
          shiny::span(
            shiny::img(src   = "https://img.shields.io/badge/Lifecycle-Dormant-ff7f2a"), 
            shiny::p("The project is currently not under active development, but there are plans to redevelop.")),
          shiny::span(
            shiny::img(src = "https://img.shields.io/badge/Lifecycle-Retired-d45500"), 
            shiny::p("The project is no longer being used and/or supported."))), 
        choiceValues = c("experimental", "maturing", "stable", "dormant", "retired")),
      shiny::p("Click 'Done' above once you have made your selection, and it will insert the appropriate HTML code at your cursor location.")
    )
  )
  
  server <- function(input, output, session) {
    shiny::observeEvent(input$done, {
      shiny::stopApp(input$stateRadio)
    })
    shiny::observeEvent(input$cancel, {
      shiny::stopApp(NULL)
    })
  }
  
  viewer <- shiny::dialogViewer("bcgov GitHub Project State Picker", width = 400, height = 640)
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

create_project_addin <- function(path, readme_type, licence, coc_email, git_init) {
  create_addin(path = path, readme_type = readme_type, 
               licence = licence, coc_email = coc_email, git_init = git_init, 
               fun = create_bcgov_project)

}

create_package_addin <- function(path, readme_type, coc_email, git_init) {
  create_addin(path = path, readme_type = readme_type, 
               licence = NULL, coc_email = coc_email, git_init = git_init, 
               fun = create_bcgov_package)
}

create_addin <- function(path, readme_type, licence, coc_email, git_init, fun) {
  # if (nzchar(repo))  {
  #   git_init <- FALSE
  #   if (!nzchar(path)) {
  #     # this doesn't actually do anything because user can't not put anything into the 'Directory'
  #     # text box, which is where the 'path' value comes from. But I'm leaving it here because I'd like
  #     # to be able to do this ;)
  #     path <- gsub("\\.git$", "", basename(repo))
  #   }
  # }
  
  if (!nzchar(coc_email)) coc_email <- get_coc_email()
  
  rmarkdown <- ifelse(readme_type == "README.Rmd", TRUE, FALSE)
  
  if (is.null(licence)) {
    licence_type <- NULL
  } else {
    licence_type <- ifelse(licence == "Apache 2.0", "apache2", "cc-by")
  }
  
  # If repo populated, use usethis::create_from_github first
  args <- list(path = path, 
               rmarkdown = rmarkdown,
               licence = licence_type,
               coc_email = coc_email, 
               open = FALSE)
  args <- Filter(Negate(is.null), args)
  
  do.call(fun, args)
  
  if (git_init) {
    check_git_committer_address()
    git2r::init(path)
    congrats("If you want to push to GitHub, use bcgovr::use_bcgov_github()")
  } else {
    congrats("If you want to use Git, use bcgovr::use_bcgov_git(), then optionally
             use bcgovr::use_bcgov_github()")
  }
}
