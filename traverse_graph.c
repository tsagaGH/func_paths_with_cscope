
#include <stdio.h> // printf()
#include <stdlib.h>

#include "traverse_graph.h"

void print_all_paths(const int len, const int ** const database) {
  int i, j;

  int *am_called = (int*)calloc(len, sizeof(int*)); // init to zero
  int *path_beginnings = NULL;
  for (i=0;i<len; ++i)
    for (j=0; j< database[i][0]; ++j)
      am_called[database[i][j+1]-1] = 1;

  int cnt = 0;
  for (i=0; i<len;++i) cnt += am_called[i]==0;
  path_beginnings = (int *)malloc(sizeof(int)*cnt);
  j=0;
  for (i=0; i<len; ++i) if (am_called[i] == 0) path_beginnings[j++] = i;
  free(am_called);

  int visited[2000] = {};
  int visited_i;
  for (i=0; i<cnt; ++i) {
    visited_i = 0;
//    printf("%d\n", path_beginnings[i]);
    print_all_paths_from(-1, database, path_beginnings[i], visited, &visited_i,0);
  }

  free(path_beginnings);
}

static void print_all_paths_from(const int len, const int ** const database, int start, int* visited, int * visited_i, int depth) {
  static int doit = 0;
  int i, j;

  for (i=0; i<visited_i[0]; ++i) {
    if (start == visited[i]) {
      print_visited_list(visited, visited_i[0]);
      printf(" .. LOOP\n");
      return;
    }
  }
  visited[visited_i[0]++] = start;
  doit = 1;
  for (i=0;i<database[start][0]; ++i) {
    print_all_paths_from(-1, database, database[start][i+1]-1, visited, visited_i,depth+1);
  }
  if (doit==1){
    print_visited_list(visited, visited_i[0]);
    printf("\n");
  }
  doit = 0;
  visited_i[0]--;
}

static void print_visited_list(int *list, int sz) {
  int i;
  for (i=0; i<sz; ++i)
    printf("%6d",list[i]);
}

