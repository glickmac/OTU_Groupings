#!/usr/bin/env Rscript
# make this script executable by doing 'chmod +x test.R'
help =
  "
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Help text here
Arguments in this order:
1) Path to TSV Biom Table

./test.R /Path/to/TSV/Biom/Table
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\n\n"

# Read options from command line
args = commandArgs(trailingOnly = TRUE)
if(is.element("--help", args) | is.element("-h", args) | is.element("-help", args) | is.element("--h", args)){
  cat(help,sep="\n")
  stop("\nHelp requested.")
}

## Load required libraries
options(warn = -1)
library(plyr)
library(dplyr)

df = read.csv(file = args[1], header = T, stringsAsFactors = F, sep = '\t')

## Group by name and count occurences
df_count = df %>% 
  group_by(X.OTU.ID) %>%
  tally()

## group by name and sum row counts
df_merged = ddply(df, "X.OTU.ID", numcolwise(sum))

df_merged$merged_counts = df_count$n

y = df_merged %>%
  select(merged_counts, everything())


write.table(y, file = "merged_OTU_taxonomy.txt", sep = '\t', quote = F, row.names = F)


