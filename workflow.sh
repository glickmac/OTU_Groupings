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

### Begin taxonomic processing

## Remove the word "Other"
sed 's/Other//g' biom_tsv.txt > removed_other.txt
rm biom_tsv.txt

## Remove level identifiers
sed 's/[a-z]__//g' removed_other.txt > removed_level.txt
rm removed_other.txt

## Remove multiple semi-colins
sed 's/[;]\{2,\}//g' removed_level.txt > multiple_semi.txt
rm removed_level.txt

## Remove single semi-colon at end
awk -F '\t' '{print $1}' multiple_semi.txt | sed 's/;$//g' > headers.txt

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
