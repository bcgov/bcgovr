usethis::proj_set(original_proj)
if (tmp_here) unlink(".here")
setwd(original_wd)

options("bcgovr.coc.email" = coc_email)
