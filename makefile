
objects=print_all_paths_util

all:
	$(MAKE) clean -s
	$(MAKE) database -s
	$(MAKE) c_build -s
	$(MAKE) run -s
	$(MAKE) clean_bash_files -s
	$(MAKE) id_to_name -s

database:
	bash all_calls.bash

${objects}: % : %.c %.h
	gcc -c $< -o $@.o

c_build: paths
paths: ${objects} paths.c
	gcc -c paths.c -o paths.o
	gcc paths.o $(addsuffix .o,${objects}) -o $@

run:
	./paths > paths_id

id_to_name:
	bash id_to_name.bash
	awk '{print $$1}'  paths_name | sort | uniq > paths_start
	awk '{print $$NF}' paths_name | sort | uniq > paths_end
	while read -r fn; do \
    echo -n "$${fn} " && (\grep "\<$${fn}\>" paths_name | wc -l ); \
  done < paths_start | awk '{print $$2, $$1}' | sort -n > paths_start_power

clean: clean_cscope_files clean_c_objects clean_bash_files
	rm -f paths_id paths_name paths_start paths_end paths_start_power all_functions
clean_cscope_files:
	rm -f other_project_cscope_files_dir/cscope.files \
        other_project_cscope_files_dir/cscope.in.out \
        other_project_cscope_files_dir/cscope.out \
        other_project_cscope_files_dir/cscope.po.out
clean_c_objects:
	rm -f paths paths.o $(addsuffix .o,${objects})
clean_bash_files:
	rm -f call_tree_down call_tree_up call_tree_down_tmp call_tree_up_tmp

