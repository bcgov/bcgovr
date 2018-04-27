context("use")

test_that("use_readme works with projects", {
  make_test_proj()
  capture.output(use_bcgov_readme())
  expect_true(file.exists(proj_file("README.md")))
  
  # Rmd
  capture.output(use_bcgov_readme_rmd())
  expect_true(file.exists(proj_file("README.Rmd")))
  
  # Check licence info gets written
  lapply(c("README.md", "README.Rmd"), function(x) {
    expect_true(check_file_contents("apache", x))
  })
  
  # Check Creative Commons licence
  unlink(proj_file("README.*"))
  capture.output(use_bcgov_readme(licence = "cc-by"))
  capture.output(use_bcgov_readme_rmd(licence = "cc-by"))
  lapply(c("README.md", "README.Rmd"), function(x) {
    expect_true(check_file_contents("creative commons", x))
  })

})

test_that("use_readme works with packages", {
  make_test_pkg()
  capture.output(use_bcgov_readme())
  expect_true(file.exists(proj_file("README.md")))
  expect_true(check_file_contents("description of package", "README.md"))
  
  capture.output(use_bcgov_readme_rmd())
  expect_true(file.exists(proj_file("README.Rmd")))
  expect_true(check_file_contents("description of package", "README.Rmd"))
})

test_that("use_bcgov_licence works", {
  make_test_proj()
  capture.output(use_bcgov_licence("apache2"))
  expect_true(file.exists(proj_file("LICENSE")))
  expect_true(check_file_contents("apache", "LICENSE"))
  unlink(proj_file("LICENSE"))
  capture.output(use_bcgov_licence("cc-by"))
  expect_true(file.exists(proj_file("LICENSE")))
  expect_true(check_file_contents("creative commons", "LICENSE"))
})

test_that("use_bcgov_contributing works", {
  make_test_proj()
  capture.output(use_bcgov_contributing())
  expect_true(file.exists(proj_file("CONTRIBUTING.md")))
})

test_that("use_bcgov_code_of_conduct works", {
  make_test_proj()

  # With no email set
  output <- capture.output(use_bcgov_code_of_conduct())
  expect_true(any(grepl("No contact email has been added", output)))
  expect_true(file.exists(proj_file("CODE_OF_CONDUCT.md")))
  unlink(proj_file("CODE_OF_CONDUCT.md"))
  
  # With email supplied explicitly
  capture.output(use_bcgov_code_of_conduct(coc_email = "me@gov.bc.ca"))
  expect_true(check_file_contents("me@gov.bc.ca", "CODE_OF_CONDUCT.md"))
  unlink(proj_file("CODE_OF_CONDUCT.md"))

  # With email as an option
  options("bcgovr.coc.email" = "metoo@gov.bc.ca")
  capture.output(use_bcgov_code_of_conduct())
  expect_true(check_file_contents("metoo@gov.bc.ca", "CODE_OF_CONDUCT.md"))
})

test_that("use_bcgov_req works", {
  # orig_wd <- getwd()
  # setwd(tempdir())
  # use_bcgov_req()
  # expect_true(all(file.exists(proj_file(
  #   c("README.Rmd", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "LICENSE")
  # ))))
  # setwd(orig_wd)
  make_test_proj()
  use_bcgov_req()
  expect_true(all(file.exists(proj_file(
    c("README.Rmd", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "LICENSE")
  ))))
})

test_that("use_bcgov_git works", {
  dir <- make_test_proj()
  expect_false(git2r::in_repository(dir))
  capture.output(use_bcgov_git())
  expect_true(git2r::in_repository(dir))
  
  expect_true(all(file.exists(proj_file(
    c(".gitignore", "README.Rmd", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "LICENSE")
  ))))
  
  git2r::config(repo = git2r::repository(dir), user.email = "metoo@abcxyz123.foo")
  expect_warning(use_bcgov_git(), "You have a non-bcgov email address")
})
