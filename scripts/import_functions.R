# Install the released version from CRAN
install.packages("roxyglobals")
install.packages("cli")
install.packages("dplyr")
install.packages("janitor")
install.packages("magrittr")
install.packages("readr")
install.packages("readxl")
install.packages("rlang")
install.packages("stringi")
install.packages("tibble")
install.packages("testthat")
install.packages("devtools")
install.packages("askpass")
install.packages("usethis")

# Import functions from packages
usethis::use_import_from(
  "readr",
  c(
    "read_csv",
    "cols",
    "col_integer",
    "col_datetime",
    "col_logical",
    "col_character"
  )
)
usethis::use_import_from("tibble", "tribble")

usethis::use_import_from(
  "rlang",
  c(
    "list2",
    "is_empty",
    "sym"
  )
)
usethis::use_import_from("askpass", "askpass")
usethis::use_import_from("cli", "cli_abort")
usethis::use_import_from("magrittr", "%>%")
usethis::use_import_from(
  "dplyr",
  c(
    "filter",
    "select",
    "pull",
    "rename_with",
    "mutate"
  )
)
usethis::use_import_from("stringi", "stri_replace_all_fixed")
usethis::use_import_from("readxl", "read_excel")
usethis::use_import_from("janitor", "clean_names")
