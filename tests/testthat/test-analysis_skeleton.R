context("analysis_skeleton")

expected_files <- c(".git/config", ".git/description", ".git/HEAD", 
                    ".git/hooks/README.sample", ".git/info/exclude", 
                    ".gitignore", "01_load.R", "02_clean.R", "03_analysis.R", 
                    "04_output.R", "CONTRIBUTING.md", "internal.R", 
                    "LICENSE", "README.md", "run_all.R")

name_incrementer <- function(name) {
  i <- 0
  function() {
    i <<- i + 1
    paste0(name, i)
  }
}

increment_foo <- name_incrementer("foo")

test_that("analysis_skeleton works with dot path and git_init", {
  base_dir <- increment_foo()
  dir <- tempdir()
  dir.create(file.path(dir, base_dir))
  setwd(file.path(dir, base_dir))
  ret <- analysis_skeleton()
  expect_equal(ret, ".")
  files <- list.files(recursive = TRUE, all.files = TRUE, full.names = TRUE)
  expect_equal(files, file.path(".", expected_files))
})

test_that("analysis_skeleton works with relative path and git init", {
  base_dir <- increment_foo()
  dir <- tempdir()
  setwd(dir)
  ret <- analysis_skeleton(base_dir, git_init = TRUE)
  expect_equal(ret, base_dir)
  files <- list.files(base_dir, recursive = TRUE, all.files = TRUE, full.names = TRUE)
  expect_equal(files, file.path(base_dir, expected_files))
})

test_that("analysis_skeleton works with absolute path and git init", {
  base_dir <- increment_foo()
  dir <- file.path(tempdir(), base_dir)
  ret <- analysis_skeleton(dir, git_init = TRUE)
  expect_equal(ret, dir)
  files <- list.files(dir, recursive = TRUE, all.files = TRUE, full.names = TRUE)
  expect_equal(files, file.path(dir, expected_files))
})

bare_repo_path <- file.path(tempdir(), "bare_test_repo.git")
dir.create(bare_repo_path, recursive = TRUE)
bare_repo <- init(bare_repo_path, bare = TRUE)

test_that("analysis_skeleton works with dot path and git clone", {
  base_dir <- increment_foo()
  dir <- tempdir()
  dir.create(file.path(dir, base_dir))
  setwd(file.path(dir, base_dir))
  ret <- analysis_skeleton(git_clone = bare_repo)
  expect_equal(ret, ".")
  files <- list.files(recursive = TRUE, all.files = TRUE, full.names = TRUE)
  expect_equal(files, file.path(".", expected_files))
})

test_that("analysis_skeleton works with relative path and git clone", {
  base_dir <- increment_foo()
  dir <- tempdir()
  setwd(dir)
  ret <- analysis_skeleton(base_dir, git_clone = bare_repo)
  expect_equal(ret, base_dir)
  files <- list.files(base_dir, recursive = TRUE, all.files = TRUE, full.names = TRUE)
  expect_equal(files, file.path(base_dir, expected_files))
})

test_that("analysis_skeleton works with absolute path and git init", {
  base_dir <- increment_foo()
  dir <- file.path(tempdir(), base_dir)
  ret <- analysis_skeleton(dir, git_clone = bare_repo)
  expect_equal(ret, dir)
  files <- list.files(dir, recursive = TRUE, all.files = TRUE, full.names = TRUE)
  expect_equal(files, file.path(dir, expected_files))
})
