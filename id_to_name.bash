#/usr/bin/bash

this_dir=`dirname -- "$( readlink -f -- "$0"; )";`
pushd $this_dir/ > /dev/null

#
declare -A id_name
while IFS=" " read -r function_id function_name
do
  id_name[$function_id]=$function_name
done < "$this_dir/all_functions"

#
paths_name=$this_dir/paths_name
false > $paths_name
while read -ra line
do
  for id in "${line[@]}"
  do
    echo -n "${id_name[$id]} " >> $paths_name
  done
  echo >> $paths_name
done < "$this_dir/paths_id"

sed -i 's/\s\+$//' $paths_name

popd > /dev/null

