context("bgc_colours")

test_that("bgc_colours works", {
  expect_equal(bgc_colours(), c(BAFA = "#E5D8B1",
                                SWB  = "#A3D1AB",
                                BWBS = "#ABE7FF",
                                ESSF = "#9E33D3",
                                CMA  = "#E5C7C7",
                                SBS  = "#2D8CBD",
                                MH   = "#A599FF",
                                CWH  = "#208500",
                                ICH  = "#85A303",
                                IMA  = "#B2B2B2",
                                SBPS = "#36DEFC",
                                MS   = "#FF46A3",
                                IDF  = "#FFCF00",
                                BG   = "#FF0000",
                                PP   = "#DE7D00",
                                CDF  = "#FFFF00"))
  expect_equal(bgc_colours(c("BAFA", "CWH")), c(BAFA = "#E5D8B1", CWH = "#208500"))
  expect_error(bgc_colours(c("BAFA", "foo")), "Unknown Biogeoclimatic Zone")
})
