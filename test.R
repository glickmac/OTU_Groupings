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

## Assumes Biom Tables has been converted to tsv
df = read.csv(file = args[1], header = T, stringsAsFactors = F, sep = '\t')
otu_names = read.csv(file = args[2], header = T, stringsAsFactors = F, sep = '\t')

df$taxonomy = NULL
df$X.OTU.ID = otu_names$X.OTU.ID
write.table(df, file = "removed_semi_colons.txt", sep = '\t', row.names = F, quote = F)