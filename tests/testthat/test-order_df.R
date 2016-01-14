context("order_df")

set.seed(42)
df <- data.frame(Col1 = rep(letters[1:3], 3), 
                 Col2 = rnorm(9), 
                 Col3 = 1:9, 
                 stringsAsFactors = FALSE)
df$Col2[3] <- NA

## mean: c > a > b

test_that("order_df works with order_col", {
  out <- order_df(df, target_col = "Col1", value_col = "Col2", fun = mean)
  expect_equal(levels(out$Col1), c("b", "a", "c"))
  expect_equal(out$Col1, structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), 
                                .Label = c("b", "a", "c"), class = c("ordered", "factor")))
  expect_equal(round(out$Col2, 3), 
               c(-0.565, 0.404, -0.095, 1.371, 0.633, 1.512, NA, -0.106, 2.018))
  expect_equal(out$Col3, c(2L, 5L, 8L, 1L, 4L, 7L, 3L, 6L, 9L))
  expect_equal(dim(out), c(9, 3))
  
  out <- order_df(df, target_col = "Col1", value_col = "Col2", fun = mean, na.rm = TRUE)
  expect_equal(levels(out$Col1), c("b", "c", "a"))
  expect_equal(out$Col1, structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), 
                                .Label = c("b", "c", "a"), class = c("ordered", "factor")))
  expect_equal(round(out$Col2, 3), 
               c(-0.565, 0.404, -0.095, NA, -0.106, 2.018, 1.371, 0.633, 1.512))
  expect_equal(out$Col3, c(2L, 5L, 8L, 3L, 6L, 9L, 1L, 4L, 7L))
  expect_equal(dim(out), c(9,3))
})

test_that("order_df works with factor_order", {
  out <- order_df(df, target_col = "Col1", factor_order = c("c", "b", "a"))
  expect_equal(levels(out$Col1), c("c", "b", "a"))
  expect_equal(out$Col1, structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), 
                                .Label = c("c", "b", "a"), class = c("ordered", "factor")))
  expect_equal(round(out$Col2, 3), 
               c(NA, -0.106, 2.018, -0.565, 0.404, -0.095, 1.371, 0.633, 1.512))
  expect_equal(out$Col3, c(3L, 6L, 9L, 2L, 5L, 8L, 1L, 4L, 7L))
  expect_equal(dim(out), c(9, 3))
})

test_that("order_df works with order_col and factor_order specified", {
  out <- suppressWarnings(order_df(df, target_col = "Col1", value_col = "Col2", 
                                   fun = mean, factor_order = c("a", "b", "c")))
  expect_equal(levels(out$Col1), c("b", "a", "c"))
  expect_equal(out$Col1, structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), 
                                   .Label = c("b", "a", "c"), class = c("ordered", "factor")))
  expect_equal(round(out$Col2, 3), 
               c(-0.565, 0.404, -0.095, 1.371, 0.633, 1.512, NA, -0.106, 2.018))
  expect_equal(out$Col3, c(2L, 5L, 8L, 1L, 4L, 7L, 3L, 6L, 9L))
  expect_equal(dim(out), c(9, 3))
})

test_that("desc works", {
  out <- order_df(df, target_col = "Col1", value_col = "Col2", fun = mean, desc = TRUE)
  expect_equal(levels(out$Col1), c("c", "a", "b"))
  expect_equal(out$Col1, structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 3L), 
                                   .Label = c("c", "a", "b"), class = c("ordered", "factor")))
  expect_equal(round(out$Col2, 3), 
               c(NA, -0.106, 2.018, 1.371, 0.633, 1.512, -0.565, 0.404, -0.095))
  expect_equal(out$Col3, c(3L, 6L, 9L, 1L, 4L, 7L, 2L, 5L, 8L))
  expect_equal(dim(out), c(9, 3))
})

test_that("order_df fails correctly", {
  expect_error(order_df(df, target_col = "foo", value_col = "Col2", fun = mean), 
               "specified target_col is not a column in df")
  expect_error(order_df(df, target_col = "Col1", value_col = "foo", fun = mean), 
               "specified value_col is not a column in df")
  expect_error(order_df(df, target_col = "Col1", value_col = "Col2"), 
               "You have specified a value_col without specifying fun")
  expect_error(order_df(df, target_col = "Col1", value_col = "Col2", fun = "foo"), 
               "fun is not a valid function")
  expect_error(order_df(df, target_col = "Col1", factor_order = c("d", "e", "f")), 
               "specified values in factor_order are not the same as those in target_col")
  expect_warning(order_df(df, target_col = "Col1", value_col = "Col2", fun = mean, factor_order = c("a", "b", "c")), 
                 "both value_col and factor_order were specified. Using value_col...")
})
