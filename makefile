
objects=get_all_paths traverse_graph

all: build run
#all:
#	echo You must choose targer.

database:
	bash calling_functions_line.bash

${objects}: % : %.c
	gcc -c $^ -o $@.o

build: call_exec
call_exec: ${objects}
	gcc $(addsuffix .o,$^) -o $@

run:
	./call_exec

clean: clean_cscope_files clean_c_objects clean_bash_files
clean_cscope_files:
	rm -f other_project_cscope_files_dir/cscope.{files,in.out,out,po.out}
clean_c_objects:
	rm -f call_exec $(addsuffix .o,${objects})
clean_bash_files:
	rm -f  all_functions \
	  call_tree_down     call_tree_up \
	  call_tree_down_tmp call_tree_up_tmp

