#/usr/bin/bash

this_dir=`dirname -- "$( readlink -f -- "$0"; )";`
pushd $this_dir/other_project_cscope_files_dir/ > /dev/null

# White down all functions in the project in $SME_GIT_ROOT.
ctags -x --c-types=f -R --languages=C $SME_GIT_ROOT |\
  cut -d" " -f1 | sort | uniq | awk '{print NR-1,$0}' > $this_dir/all_functions

# Generate cscope database and copy is over.
build_cscope_db_for_sme_func $SME_GIT_ROOT
cp --force $SME_GIT_ROOT/cscope.{files,in.out,out,po.out} .

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
call_tree_up="$this_dir/call_tree_up"
call_tree_down="$this_dir/call_tree_down"
false > $call_tree_up
false > $call_tree_down
for i in "${name_id[@]}"
do
  function_name=${id_name[$i]}

  call_list_id=
  for l in `cscope -d -L -3 "$function_name" | cut -d" " -f2 |sort|uniq`; do
    call_list_id="$call_list_id ${name_id[$l]}"
  done
  len=`wc -w <<< $call_list_id`
  echo "$i $len $call_list_id" >> $call_tree_up

  called_list_id=
  for l in `cscope -d -L -2 "$function_name" | cut -d" " -f2 |sort|uniq`; do
    called_list_id="$called_list_id ${name_id[$l]}"
  done
  len=`wc -w <<< $called_list_id`
  echo "$i $len $called_list_id" >> $call_tree_down
done

# Sort by first column (bash does not do by default)
sort -k1 -n -o ${call_tree_up}_tmp < $call_tree_up
sort -k1 -n -o ${call_tree_down}_tmp < $call_tree_down

# Drop first column (should be assending)
cut -d" " -f2- ${call_tree_up}_tmp > $call_tree_up
cut -d" " -f2- ${call_tree_down}_tmp  > $call_tree_down

# Remove trailing spaces (optional)
sed -i 's/\s\+$//' $call_tree_up
sed -i 's/\s\+$//' $call_tree_down

unset id_name
unset name_id

popd > /dev/null

