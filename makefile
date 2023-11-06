
all:
	echo You must choose targer.

database:
	bash calling_functions_line.bash

objects=get_all_paths traverse_graph

${objects}: % : %.c
	gcc -c $^ -o $@.o

build: call_exec
call_exec: ${objects}
	gcc $(addsuffix .o,$^) -o $@

run:
	./call_exec hello bro

redo_id_files:
	./calling_functions_line.bash

clean_all: clean_cscope_files clean_c_objects clean_database_files

clean_c_objects:
	rm -f call_exec $(addsuffix .o,${objects})

clean_cscope_files:
	rm -f cscope.in.out cscope.out cscope.po.out cscope.files

clean_files:
	rm -f  all_functions
	rm -f call_functions     called_functions
	rm -f call_functions_tmp called_functions_tmp

