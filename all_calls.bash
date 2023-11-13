#/usr/bin/bash

this_dir=`dirname -- "$( readlink -f -- "$0"; )";`

pushd $this_dir/all_source_copy > /dev/null
find -not -name .gitignore -delete
popd > /dev/null

pushd / > /dev/null
find $SME_GIT_ROOT -name *.c -o -name *.h | \
  \grep -v \
    -e ${SME_GIT_ROOT}\[^/]*/include \
    -e ${SME_GIT_ROOT}\[^/]*/cgc_ver \
    -e ${SME_GIT_ROOT}\[^/]*/build_cfg > $this_dir/all_source_copy/all_source_files
popd > /dev/null

pushd $this_dir/all_source_copy > /dev/null
echo "    Cleaning \"all_source_copy\" directory."
#find -not -name .gitignore -not -name all_source_files -delete
echo "    Copying all source files into \"all_source_copy\" directory."
cp --parents `cat all_source_files` .
echo "    Using CTAGS to identify every function."
ctags -x --c-types=f -R --languages=C . |\
  cut -d" " -f1 | sort | uniq | awk '{print NR-1,$0}' > $this_dir/all_functions

echo "    Removing all #if-#el-#end directives."
pushd / > /dev/null
find $this_dir/all_source_copy -name *.c -o -name *.h > $this_dir/all_source_copy/cscope.files
popd > /dev/null
for fl in `cat cscope.files`;
do
  sed -i '/^ *# *\(if\|el\|end\|[[:digit:]]\)/d' ${fl}
done

echo "    Building CSCOPE database in \"all_source_copy\" directory."
cscope -b -R -k -q

# Prepare to read the database.
declare -A id_name
declare -A name_id
while IFS=" " read -r function_id function_name
do
  # NOTE: IFS means Internal Field Separator.
  id_name[$function_id]=$function_name
  name_id[$function_name]=$function_id
done < "$this_dir/all_functions"

# Read the database and build an associative file(s).
echo "    Building call hierarchy."
call_tree_down="$this_dir/call_tree_down" && false > $call_tree_down
for i in "${name_id[@]}"
do
  function_name=${id_name[$i]}
  called_list_id=
  for l in `cscope -d -L -2 "$function_name" | cut -d" " -f2 |sort|uniq`; do
    called_list_id="$called_list_id ${name_id[$l]}"
  done
  len=`wc -w <<< $called_list_id`
  echo "$i $len $called_list_id" >> $call_tree_down
done

# Sort by first column (bash does not do by default)
sort -k1 -n -o ${call_tree_down}_tmp < $call_tree_down

# Drop first column (should be assending)
cut -d" " -f2- ${call_tree_down}_tmp  > $call_tree_down

# Remove trailing spaces (optional)
sed -i 's/\s\+$//' $call_tree_down

unset id_name
unset name_id

popd > /dev/null

