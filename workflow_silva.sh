#!/bin/bash
set -euo pipefail  # bash strict mode http://redsymbol.net/articles/unofficial-b$
IFS=$'\n\t'

outdir=""
biom=""
threshold=""
main_dir=$(pwd)
threads=2

usage(){ echo "$0 usage:" && grep " .)\ #" $0; exit 0; }
[ $# -eq 0 ] && usage

while getopts ":h:b:t:" option
do
case "${option}" in
        b) # The path to and including the biom table
		biom=${OPTARG};;
        t) # The numeric threshold amount for low abundance filtering
		threshold=${OPTARG};;
        h | *) # Display Help
                usage
                exit 0;;
esac
done

shift "$((OPTIND-1))"

## Convert Biom to TSV
biom convert -i $biom -o biom_tsv.txt --to-tsv --header-key taxonomy

## Remove first line of converted biom file
sed -i -e '1d' biom_tsv.txt
rm biom_tsv.txt-e

### Begin taxonomic processing

## Remove the word "Other"
sed 's/uncultured bacterium//g' biom_tsv.txt > removed_bac.txt
sed 's/uncultured archaeon//g' removed_bac.txt > removed_arch.txt
sed 's/Ambiguous_taxa//g' removed_arch.txt > removed_other.txt 
sed 's/uncultured//g' removed_other.txt > removed_all.txt 
rm biom_tsv.txt
rm removed_bac.txt
rm removed_arch.txt
rm removed_other.txt

## Remove level identifiers
sed 's/D_[0-9*]__//g' removed_all.txt > removed_end.txt
sed 's/D_[1][0-9]__//g' removed_end.txt > removed_level.txt
rm removed_all.txt
rm removed_end.txt

## Remove spaces in taxonomy column
tr -d ' ' < removed_level.txt > removed_spaced.txt
rm removed_level.txt

## Remove multiple semi-colins
sed 's/[;]\{2,\}//g' removed_spaced.txt > multiple_semi.txt
rm removed_spaced.txt

## Remove single semi-colon at end
awk -F '\t' '{print $(NF)}' multiple_semi.txt | sed 's/;$//g' > headers.txt

## Initialize R Script to remove taxonomy colons at end
./test.R multiple_semi.txt headers.txt
rm headers.txt 
rm multiple_semi.txt

## Remove brackets
sed 's/\[//g;s/\]//g' removed_semi_colons.txt > removed_brackets.txt
rm removed_semi_colons.txt

## Remove spacing
sed 's/ //g' removed_brackets.txt > preprocess_taxonomy.txt
rm removed_brackets.txt


### Group OTUs with Merging R Script
./Group_merging.R preprocess_taxonomy.txt
rm preprocess_taxonomy.txt

### Low Abundance 
biom convert -i OTU_taxonomy_for_biom_conversion.txt -o table.biom --table-type="OTU table" --to-hdf5
rm OTU_taxonomy_for_biom_conversion.txt

## Filter by one percent
filter_otus_from_otu_table.py -i table.biom -o filtered_table.biom --min_count_fraction 0.01
rm table.biom

## Convert to TSV
biom convert -i filtered_table.biom -o biom_tsv.txt --to-tsv
rm filtered_table.biom

## Remove first line of converted biom file
sed -i -e '1d' biom_tsv.txt
rm biom_tsv.txt-e

## Run Low Abundance Script
./Low_Abundance_Sums.R biom_tsv.txt
rm biom_tsv.txt



