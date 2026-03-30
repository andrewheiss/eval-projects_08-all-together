# Get the data from GitHub since the eval project builds them
library(tidyverse)

base_url <- paste0(
  "https://raw.githubusercontent.com/andrewheiss/", 
  "evalsp26.classes.andrewheiss.com/refs/heads/main/", 
  "files/data/external_data/"
)

data_file <- "evaluation.dta"

dir.create("data", showWarnings = FALSE)

if (!file.exists(paste0("data/", data_file))) {
  download.file(
    paste0(base_url, data_file),
    paste0("data/", data_file)
  )
}

# Build answer key so that the plots to recreate exist in images/
quarto::quarto_render(
  "answers.qmd",
  output_format = c("html", "typst")
)
