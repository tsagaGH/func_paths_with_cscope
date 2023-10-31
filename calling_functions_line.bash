#/usr/bin/bash

# Make sure to be in this dir when calling
this_dir="/home/tsaga/Desktop/play_with_calling_trees"

# Generate cscope database.
find $SME_GIT_ROOT -name *.c -o -name *.h > $SME_GIT_ROOT/cscope.files;
pushd $SME_GIT_ROOT > /dev/null
cscope -Rbkq
popd > /dev/null

# Bring the database over
cp $SME_GIT_ROOT/cscope.{files,in.out,out,po.out} $this_dir

function_names_file="$this_dir/all_functions"
new_file_name="$this_dir/call_functions"
false > touch $new_file_name
# NOTE: IFS means Internal Field Separator.
while IFS=" " read -r function_id function_name
do
  echo $function_id
  call_list_id=
  for l in `cscope -L -3"$function_name" | cut -d" " -f2 |sort|uniq`; do
    call_list_id="$call_list_id `\grep $l $function_names_file | cut -d" " -f1`"
  done
  echo $call_list_id > $new_file_name
done < "$function_names_file"

