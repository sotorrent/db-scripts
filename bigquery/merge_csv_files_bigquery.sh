#!/bin/bash

prefix="PostReferenceGH"

first_file="$prefix$(printf "%012d" 0).csv"

echo "Merging CSV files..."
gunzip "$first_file.gz"
# ensure newline add end of file
sed -i'' -e '$a\' ${first_file}
mv ${first_file} "$prefix.csv"

for i in {1..70}
do
  current_file="$prefix$(printf "%012d" ${i}).csv"
  gunzip "$current_file.gz"  
  sed -i'' -e '$a\' ${current_file}
  tail -n +2 ${current_file} >> "$prefix.csv"
  rm ${current_file}
done

# remove all empty lines
echo "Removing empty lines from CSV file..."
sed -i'' -e '/^\s*$/d' "$prefix.csv"

echo "Compressing CSV file..."
gzip -k "$prefix.csv"
