
all: call_exec

get_all_paths.o: get_all_paths.c
	gcc -c $^ -o $@

call_exec: get_all_paths.o
	gcc $^ -o $@

run:
	./call_exec hello bro


clean:
	rm call_exec get_all_paths.o

