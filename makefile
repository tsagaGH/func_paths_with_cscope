
all:
	echo You must choose targer.

database:
	bash calling_functions_line.bash

get_all_paths.o: get_all_paths.c
	gcc -c $^ -o $@

build: call_exec
call_exec: get_all_paths.o
	gcc $^ -o $@

run:
	./call_exec hello bro

redo_id_files:
	./calling_functions_line.bash

clean:
	rm -f call_exec get_all_paths.o
	rm -f cscope.in.out cscope.out cscope.po.out cscope.files
	rm -f  all_functions
	rm -f call_functions     called_functions
	rm -f call_functions_tmp called_functions_tmp

