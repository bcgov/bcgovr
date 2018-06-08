context("create_bcgov_project")
# options(warn = 2)
exp_proj_files <- c("01_load.R", "02_clean.R", "03_analysis.R", "04_output.R", 
                    "CODE_OF_CONDUCT.md", "CONTRIBUTING.md", "data", 
                    "LICENSE", "out", "README.Rmd", "run_all.R")

exp_pkg_files <- c("CODE_OF_CONDUCT.md", "CONTRIBUTING.md", "DESCRIPTION", 
                   "LICENSE", "man", "NAMESPACE", "NEWS.md", "R", "README.Rmd", 
                   "vignettes")
 
 
test_that("create_bcgov_project works with default path ('.')", {
  dir <- unique_temp_dir(pattern = "create_foo")
  setwd(dir)
  ret <- capture.output(create_bcgov_project(coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))

  expect_true(file.exists(paste0(basename(dir), ".Rproj")))
  expect_true(all(file.exists(exp_proj_files)))
  expect_true(all(file.info(c("data", "out"))$isdir))
})

test_that("create_bcgov_project works with different path", {
  setwd("~")
  dir <- unique_temp_dir(pattern = "create_foo")
  ret <- capture.output(create_bcgov_project(dir, coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(file.path(dir, paste0(basename(dir), ".Rproj"))))
  expect_true(all(file.exists(file.path(dir, exp_proj_files))))
})

test_that("create_bcgov_project works with default path that already had project infra", {
  dir <- unique_temp_dir(pattern = "create_foo")
  setwd(dir)
  file.create(".here")
  ret <- capture.output(create_bcgov_project(coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(paste0(basename(dir), ".Rproj")))
  expect_true(all(file.exists(exp_proj_files)))
})

test_that("create_bcgov_project works with different path that already had project infra", {
  setwd("~")
  dir <- unique_temp_dir(pattern = "create_foo")
  file.create(file.path(dir, ".here"))
  ret <- capture.output(create_bcgov_project(dir, coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(file.path(dir, paste0(basename(dir), ".Rproj"))))
  expect_true(all(file.exists(file.path(dir, exp_proj_files))))
})

## Packages
test_that("create_bcgov_package works with default path ('.')", {
  dir <- unique_temp_dir(pattern = "foopkg")
  setwd(dir)
  ret <- capture.output(create_bcgov_package(coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(paste0(basename(dir), ".Rproj")))
  expect_true(all(file.exists(exp_pkg_files)))
  expect_true(all(file.info(c("man", "R", "vignettes"))$isdir))
})

test_that("create_bcgov_package works with different path", {
  setwd("~")
  dir <- unique_temp_dir(pattern = "foopkg")
  ret <- capture.output(create_bcgov_package(dir, coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(file.path(dir, paste0(basename(dir), ".Rproj"))))
  expect_true(all(file.exists(file.path(dir, exp_pkg_files))))
})

test_that("create_bcgov_package works with default path that already had project infra", {
  dir <- unique_temp_dir(pattern = "foopkg")
  setwd(dir)
  file.create(".here")
  ret <- capture.output(create_bcgov_package(coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(paste0(basename(dir), ".Rproj")))
  expect_true(all(file.exists(exp_pkg_files)))
})

test_that("create_bcgov_package works with different path that already had project infra", {
  setwd("~")
  dir <- unique_temp_dir(pattern = "foopkg")
  file.create(file.path(dir, ".here"))
  ret <- capture.output(create_bcgov_package(dir, coc_email = "me@gov.bc.ca", 
                                             rstudio = TRUE, open = FALSE))
  
  expect_true(file.exists(file.path(dir, paste0(basename(dir), ".Rproj"))))
  expect_true(all(file.exists(file.path(dir, exp_pkg_files))))
})


# test_that("create_bcgov_project works with relative path and git init", {
#   base_dir <- increment_foo()
#   dir <- tempdir()
#   setwd(dir)
#   ret <- create_bcgov_project(base_dir, git_init = TRUE, rstudio = FALSE)
#   
#   expect_equal(normalizePath(ret, winslash = "/"), 
#                normalizePath(file.path(dir, base_dir), winslash = "/"))
#   files <- list.files(file.path(dir, base_dir), all.files = TRUE, 
#                       full.names = TRUE, include.dirs = TRUE, no.. = TRUE)
#   
#   expect_equal(sort(normalizePath(files, winslash = "/")), 
#                sort(normalizePath(
#                  file.path(dir, base_dir, expected_files), 
#                  winslash = "/")))
# })
# 
# test_that("create_bcgov_project works with absolute path and git init", {
#   base_dir <- increment_foo()
#   dir <- file.path(tempdir(), base_dir)
#   ret <- create_bcgov_project(dir, git_init = TRUE, rstudio = FALSE)
#   
#   expect_equal(normalizePath(ret), normalizePath(dir))
#   files <- list.files(dir, all.files = TRUE, full.names = TRUE, 
#                       include.dirs = TRUE, no.. = TRUE)
#   
#   expect_equal(sort(normalizePath(files)), 
#   			   sort(normalizePath(file.path(dir, expected_files))))
# })
# 
# bare_repo_path <- file.path(tempdir(), "bare_test_repo.git")
# dir.create(bare_repo_path, recursive = TRUE)
# bare_repo <- init(bare_repo_path, bare = TRUE)
# 
# test_that("create_bcgov_project works with dot path and git clone", {
#   base_dir <- increment_foo()
#   dir <- tempdir()
#   dir.create(file.path(dir, base_dir))
#   setwd(file.path(dir, base_dir))
#   ret <- create_bcgov_project(git_clone = bare_repo, rstudio = FALSE)
#   
#   expect_equal(normalizePath(ret), normalizePath("."))
#   files <- list.files(all.files = TRUE, full.names = TRUE, 
#                       include.dirs = TRUE, no.. = TRUE)
#   
#   expect_equal(sort(normalizePath(files)), 
#   			   sort(normalizePath(file.path(".", expected_files))))
# })
# 
# test_that("create_bcgov_project works with relative path and git clone", {
#   base_dir <- increment_foo()
#   dir <- tempdir()
#   setwd(dir)
#   ret <- create_bcgov_project(base_dir, git_clone = bare_repo, rstudio = FALSE)
#   
#   expect_equal(normalizePath(ret, winslash = "/"), 
#   			   normalizePath(file.path(dir, base_dir), winslash = "/"))
#   files <- list.files(file.path(dir, base_dir), all.files = TRUE, 
#                       full.names = TRUE, include.dirs = TRUE, no.. = TRUE)
#   
#   expect_equal(sort(normalizePath(files, winslash = "/")), 
#   			   sort(normalizePath(
#   			     file.path(dir, base_dir, expected_files), 
#   			               winslash = "/")))
# })
# 
# test_that("create_bcgov_project works with absolute path and git clone", {
#   base_dir <- increment_foo()
#   dir <- file.path(tempdir(), base_dir)
#   ret <- create_bcgov_project(dir, git_clone = bare_repo, rstudio = FALSE)
#   
#   expect_equal(normalizePath(ret, winslash = "/"), 
#   			   normalizePath(dir, winslash = "/"))
#   files <- list.files(dir, all.files = TRUE, full.names = TRUE, 
#                       include.dirs = TRUE, no.. = TRUE)
#   
#   expect_equal(sort(normalizePath(files, winslash = "/")), 
#   			   sort(normalizePath(
#   			     file.path(dir, expected_files), 
#   			     winslash = "/")))
# })
# 
# test_that("rmarkdown argument works", {
#   base_dir <- increment_foo()
#   dir <- file.path(tempdir(), base_dir)
#   ret <- create_bcgov_project(dir)
#   
#   expect_true(file.exists(file.path(dir, "README.md")))
#   base_dir <- increment_foo()
#   dir <- file.path(tempdir(), base_dir)
#   ret <- create_bcgov_project(dir, rmarkdown = TRUE)
#   
#   expect_true(file.exists(file.path(dir, "README.Rmd")))
# })
# 
# test_that("add_code_of_conduct works", {
#   base_dir <- increment_foo()
#   dir <- file.path(tempdir(), base_dir)
#   dir.create(dir, showWarnings = FALSE)
#   expect_true(add_code_of_conduct(dir, coc_email = NULL))
#   expect_true(file.exists(file.path(dir, "CODE_OF_CONDUCT.md")))
# })
# 
# unlink(bare_repo_path, recursive = TRUE, force = TRUE)
