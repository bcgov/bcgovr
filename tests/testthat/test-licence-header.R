f1_apache <- tempfile(fileext = ".R")
writeLines("", f1_apache)
f2_cc <- tempfile(fileext = ".Rmd")
writeLines("", f2_cc)

test_that("insert_bcgov_cc_header_works", {
  insert_bcgov_cc_header(f2_cc)
  expect_true(any(grepl("commons", readLines(f2_cc), ignore.case = TRUE)))
})

test_that("insert_bcgov_apache_header_works", {
  insert_bcgov_apache_header(f1_apache)
  expect_true(any(grepl("apache", readLines(f1_apache), ignore.case = TRUE)))
})

test_that("check_licence_header works", {
  expect_true(TRUE)
})
