#!/usr/bin/env bash

# Create a file which sorts data sizes by letter, so we can order the // jobs sensibly

data_dir="/whereyouputbigdatainputfiles"
config_dir="/Users/n581512/project/my_project/config"
tmp_file="data_density.txt"
ordering_file="letter_ordering.txt"

# Delete the old statistics file if it exists
if [[ -e ${config_dir}/${tmp_file} ]]
then
   rm ${config_dir}/${tmp_file}
fi

# Create a file with one line per letter:
#      Size    key
#      1223411 A
#      1231233 B
#
for x in {A..Z}
do
   data_sz=$(du -c ${data_dir}/${x}* | awk '/./{line=$0} END{print $1}')
   echo "${data_sz} ${x}" >> ${config_dir}/${tmp_file}
done

# Sort, extract the letters, and convert to a single row
sort -r -t " " -k 1 -g ${config_dir}/${tmp_file} | awk '{print $2}' | tr '\n' ' ' > ${config_dir}/${ordering_file}

rm ${config_dir}/${tmp_file}

# Now you can easily read the ordered keys into a bash array:
#        read -a ordering <<<$(head -n 1 ${config_dir}/${ordering_file})
