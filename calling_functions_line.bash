#/usr/bin/bash
function_names_file="/home/tsaga/Desktop/dump"
while IFS= read -r line
do
  function_id=`cut -d" " -f1 <<< $line`
  function_name=`cut -d" " -f2 <<< $line`
  new_file_name="/home/tsaga/Desktop/sbme/call_functions_line_dir/$function_id"
  if [ ! -f $new_file_name ]
  then
    call_list_name=`cscope -L -3"$function_name" | cut -d" " -f2 |sort|uniq`
    call_list_id=
    echo "function: $function_name"
    for l in $call_list_name; do
#      echo `\grep $l $function_names_file | cut -d" " -f1` >> $new_file_name
      id=`\grep $l $function_names_file | cut -d" " -f1`
      call_list_id="$call_list_id $id"
    done
    echo $call_list_id > $new_file_name
  else
    echo "Exists lol"
  fi
  echo $function_id
done < "$function_names_file"

