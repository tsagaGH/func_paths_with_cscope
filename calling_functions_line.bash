#/usr/bin/bash

# NOTE: IFS means Internal Field Separator.
# NOTE: Make sure to be in this dir when calling

this_dir="/home/tsaga/Desktop/play_with_calling_trees"
cd $this_dir

# gather all functions
false > all_functions # unec. maybe..
ctags -x --c-types=f -R --languages=C $SME_GIT_ROOT |\
 cut -d" " -f1 | sort | uniq | awk '{print NR,$0}' > all_functions

# Generate cscope database and copy is over
pushd / > /dev/null
find $SME_GIT_ROOT -name *.c -o -name *.h > $SME_GIT_ROOT/cscope.files;
pushd $SME_GIT_ROOT > /dev/null
cscope -Rbkq
popd > /dev/null
popd > /dev/null
cp $SME_GIT_ROOT/cscope.{files,in.out,out,po.out} $this_dir

# Prepare to dead the database
declare -A id_name
declare -A name_id
while IFS=" " read -r function_id function_name
do
  id_name[$function_id]=$function_name
  name_id[$function_name]=$function_id
done < "$this_dir/all_functions"

# read the database and build an assoc. file (call functions file)
new_file_name="$this_dir/call_functions"
new_file_name2="$this_dir/called_functions"
false > $new_file_name
false > $new_file_name2
for i in "${name_id[@]}"
do
  function_name=${id_name[$i]}

  call_list_id=
  call_name_list=`cscope -d -L -3 "$function_name" | cut -d" " -f2 |sort|uniq`
  call_list_length=`wc -w <<< $call_name_list`
  for l in $call_name_list; do
    call_list_id="$call_list_id ${name_id[$l]}"
  done
  echo "$i $call_list_length $call_list_id" >> $new_file_name

  called_list_id=
  called_name_list=`cscope -d -L -2 "$function_name" | cut -d" " -f2 |sort|uniq`
  called_list_length=`wc -w <<< $called_name_list`
  for l in $called_name_list; do
    called_list_id="$called_list_id ${name_id[$l]}"
  done
  echo "$i $called_list_length $called_list_id" >> $new_file_name2
done

# Sort by first column (bash does not do by default)
sort -k1 -n -o call_functions_tmp < call_functions
sort -k1 -n -o called_functions_tmp < called_functions

# Drop first column (should be assending)
cut -d" " -f2- call_functions_tmp > call_functions
cut -d" " -f2- called_functions_tmp > called_functions

# Remove trailing spaces (optional)
sed -i 's/\s\+$//' call_functions
sed -i 's/\s\+$//' called_functions

unset id_name
unset name_id

