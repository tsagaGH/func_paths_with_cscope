
all: call_exec

get_all_paths.o: get_all_paths.c
	gcc -c $^ -o $@

call_exec: get_all_paths.o
	gcc $^ -o $@

run:
	./call_exec hello bro

redo_id_files:
	./calling_functions_line.bash

clean:
	rm -f call_exec get_all_paths.o
	rm -f cscope.in.out cscope.out cscope.po.out cscope.files
	rm -f all_functions_tmp all_functions call_functions

