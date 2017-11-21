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

df = read.csv(file = args[1], header = T, stringsAsFactors = F, sep = '\t')

## Store Taxonomy for row names later
taxonomy = df$X.OTU.ID
df$X.OTU.ID = NULL

## Convert to numeric 
df = as.data.frame(sapply(df, as.numeric))

## Sum Columns and create low abundance vector
x = colSums(df)
LowAbundance = 10000 - x

## Bind low abundance row
test = rbind(df, LowAbundance)

## Add taxonomy
row.names(test) = c(taxonomy, "LowAbundance")
test = cbind(X.OTU.ID= rownames(test), test)

write.table(test, file = "Low_Abundance_Filtered_Merged_OTU_Table.txt", sep = '\t', quote = F, row.names = F)

