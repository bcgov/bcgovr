context("use")

test_that("use_readme works", {
  make_test_proj()
  use_bcgov_readme()
  expect_true(file.exists(proj_file("README.md")))
  use_bcgov_readme_rmd()
  expect_true(file.exists(proj_file("README.Rmd")))
})

test_that("use_bcgov_licence works", {
  make_test_proj()
  use_bcgov_licence("apache2")
  expect_true(file.exists(proj_file("LICENSE")))
  expect_true(grepl("apache", readLines(proj_file("LICENSE"), n = 1L), 
                    ignore.case = TRUE))
  unlink(proj_file("LICENSE"))
  use_bcgov_licence("cc-by")
  expect_true(file.exists(proj_file("LICENSE")))
  expect_true(grepl("creative", readLines(proj_file("LICENSE"), n = 1L), 
                    ignore.case = TRUE))
})
