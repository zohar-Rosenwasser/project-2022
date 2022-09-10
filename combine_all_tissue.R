library(dplyr)
library(readr)
library(ggplot2)
library(tidyverse)
library(tibble)

# get an argiments
# 1 - /private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/REDItoolKnown.out.combined
# 2 - /private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/REDItoolKnown.out.combined_all_tissue.csv
# 3 - 30 
args = commandArgs(trailingOnly=TRUE)
input_csv <- args[1]
output_csv <- args[2]
coverage <- as.integer(args[3])

data_all <- list.files(path = input_csv ,  # Identify all CSV files
                       pattern = "*.csv", full.names = TRUE) %>% 
  lapply(read_csv) %>%                              # Store all files in list
  bind_rows  

data_filter_ferquency <- data_all %>% filter(CoverageAG > 30)
data_filter_ferquency$tissue <- "tissue"


tissue <- unlist(tissue <- str_split(data_filter_ferquency$Sample[1], "_"))[2]


for (row in 1:nrow(data_filter_ferquency)) {
  tissue <- unlist(tissue <- str_split(data_filter_ferquency$Sample[row], "_"))[2]
  data_filter_ferquency$tissue[row] <- tissue
}

write.csv(data_filter_ferquency,output_csv, row.names = FALSE)


