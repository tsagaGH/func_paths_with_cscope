
objects=print_all_paths print_all_paths_util

all: id_to_name
#all:
#	echo You must choose targer.

database:
	bash all_calls.bash

${objects}: % : %.c
	gcc -c $^ -o $@.o

c_build: paths
paths: ${objects}
	gcc $(addsuffix .o,$^) -o $@

run:
	./paths > paths_id

id_to_name:
	bash id_to_name.bash

clean: clean_cscope_files clean_c_objects clean_bash_files
	rm -f paths_id paths_name
clean_cscope_files:
	rm -f other_project_cscope_files_dir/cscope.files \
	  other_project_cscope_files_dir/cscope.in.out \
	  other_project_cscope_files_dir/cscope.out \
	  other_project_cscope_files_dir/cscope.po.out
clean_c_objects:
	rm -f paths $(addsuffix .o,${objects})
clean_bash_files:
	rm -f  all_functions \
	  call_tree_down     call_tree_up \
	  call_tree_down_tmp call_tree_up_tmp

