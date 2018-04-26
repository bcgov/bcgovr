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
  coc_email <- getOption("bcgovr.coc.email")
  
  # With no email set
  options("bcgovr.coc.email" = NULL)
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
  
  options("bcgovr.coc.email" = coc_email)
})
