#/usr/bin/bash

# NOTE: IFS means Internal Field Separator.
# NOTE: Make sure to be in this dir when calling

this_dir="/home/tsaga/Desktop/play_with_calling_trees"
cd $this_dir

# gather all functions
false > all_functions # unec. maybe..
ctags -x --c-types=f -R --languages=C $SME_GIT_ROOT |\
 cut -d" " -f1 | sort | uniq | awk '{print NR,$0}' > all_functions

# Generate cscope database.
find $SME_GIT_ROOT -name *.c -o -name *.h > $SME_GIT_ROOT/cscope.files;
pushd $SME_GIT_ROOT > /dev/null
cscope -Rbkq && cp $SME_GIT_ROOT/cscope.{files,in.out,out,po.out} $this_dir
popd > /dev/null

echo gasd
cscope -d -L -3sUpdateClockDiv
echo GASD
exit

declare -A id_name
declare -A name_id
while IFS=" " read -r function_id function_name
do
  id_name[$function_id]=$function_name
  name_id[$function_name]=$function_id
done < "$this_dir/all_functions"

for i in "${name_id[@]}"
do
  function_name=${id_name[$i]}
  echo "$i, ${id_name[$i]}"
  echo `cscope -d -L -3"$function_name" | cut -d" " -f2 |sort|uniq`
  break
done

exit



function_names_file="$this_dir/all_functions"
new_file_name="$this_dir/call_functions"
false > touch $new_file_name
while IFS=" " read -r function_id function_name
do
  echo "$function_id, $function_name"
  call_list_id=
  for l in `cscope -L -3"$function_name" | cut -d" " -f2 |sort|uniq`; do
    call_list_id="$call_list_id `\grep $l $function_names_file | cut -d" " -f1`"
  done
  echo $call_list_id >> $new_file_name
done < "$function_names_file"

