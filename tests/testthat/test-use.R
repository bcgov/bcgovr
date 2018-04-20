context("use")

increment_foo <- name_incrementer("foo")

test_that("use_readme works", {
  base_dir <- increment_foo()
  dir <- tempdir()
  dir.create(file.path(dir, base_dir))
  setwd(file.path(dir, base_dir))
  file.create(".here")
  use_bcgov_readme()
  expect_true(file.exists("README.md"))
})
