
#include <stdio.h> // printf()
#include <stdlib.h>

#include "print_all_paths_util.h"

void print_all_paths(const int len, const int ** const database) {
  int i, j;

  /* Determine those that are NOT called by any other (any how many are they). */
  int* am_called = (int*)calloc(len, sizeof(int*)); // init to zero
  for (i=0; i<len; ++i)
    for (j=0; j<database[i][0]; ++j)
      am_called[database[i][j+1]] = 1;
  int cnt = 0;
  for (i=0; i<len; ++i) cnt += am_called[i]==0;

  /* Make a definitive list of path beginnings. */
  int* path_beginnings = (int*)malloc(sizeof(int) * cnt);
  j=0;
  for (i=0; i<len; ++i) if (am_called[i] == 0) path_beginnings[j++] = i;
  free(am_called);

  /* Print out every possible path starting from every possible beginning. */
  int visited[2000] = {}; // Visited items so far on the current path.
  int vnum; // Number of visitied items.
  for (i=0; i<cnt; ++i) {
    vnum = 0;
    print_all_paths_from(database, path_beginnings[i], visited, &vnum);
  }

  free(path_beginnings);
}

static void print_all_paths_from(
      const int ** const database,
      int start,
      int* visited,
      int* vnum_ptr) {
  int i;

  for (i=0; i<*vnum_ptr; ++i) {
    if (start == visited[i]) {
      print_visited_list(visited, *vnum_ptr);
      printf("%6d LOOP\n", start);
      return;
    }
  }
  visited[*vnum_ptr] = start;
  (*vnum_ptr)++; // Caution: Without parenthesis the interpretation is different.
  for (i=0; i<database[start][0]; ++i) {
    print_all_paths_from(database, database[start][i+1], visited, vnum_ptr);
  }
  print_visited_list(visited, *vnum_ptr);
  printf("\n");
  (*vnum_ptr)--; // Caution: The parenthesis are necessary.
}

static inline void print_visited_list(const int * const list, const int sz) { int i; for (i=0; i<sz; ++i) printf("%6d", list[i]); }

