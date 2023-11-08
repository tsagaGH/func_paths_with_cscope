
#include <stdio.h>
#include <string.h> // getline()
#include <stdlib.h>

#include "traverse_graph.h" // print_all_paths()

int main(int argc, const char ** argv) {
  int **call_graphs;
  int **called_graphs;
  int func_N; // Total number of function (number of lines in "all_functions").

  int i, j;
  char *buf;
  size_t len;
  FILE *fp;

  const char all_functions [256] = "/home/tsaga/Desktop/play_with_calling_trees/all_functions";
  const char call_tree_up  [256] = "/home/tsaga/Desktop/play_with_calling_trees/call_tree_up";
  const char call_tree_down[256] = "/home/tsaga/Desktop/play_with_calling_trees/call_tree_down";

  /* Open functions file to count them. */
  fp = fopen(all_functions, "r");
  if (!fp) {
    fprintf(stderr, "File \"%s\" could not be opened. Returning with error...\n", all_functions);
    fflush(stderr);
    return 1;
  }
  func_N = 0;
  char c; for (c = getc(fp); c != EOF; c = getc(fp)) func_N+= c=='\n';
  fclose(fp);

  /* Reserve memory for adjacency lists. */
  call_graphs = (int**)malloc(sizeof(int*) * func_N);
  called_graphs = (int**)malloc(sizeof(int*) * func_N);

  /* Fill up adjacency list with how up-function-calls. */
  fp = fopen(call_tree_up, "r");
  if (!fp) {
    fprintf(stderr, "File \"%s\" could not be opened. Returning with error...\n", call_tree_up);
    fflush(stderr);
    return 1;
  }
  buf = NULL;
  len = 0;
  i = 0;
  while (getline(&buf, &len, fp) != -1) {
    char * token = strtok(buf, " ");
    int sz = atoi(token);
    call_graphs[i] = (int*)malloc(sizeof(int) * (sz + 1));
    call_graphs[i][0] = sz;
    token = strtok(NULL, " ");
    j=1;
    while (token) {
      call_graphs[i][j] = atoi(token);
      j++;
      token = strtok(NULL, " ");
    }
    i++;
  }
  fclose(fp);

  /* Fill up adjacency list with down-function-calls. */
  fp = fopen(call_tree_down, "r");
  if (!fp) {
    fprintf(stderr, "File \"%s\" could not be opened. Returning with error...\n", call_tree_down);
    fflush(stderr);
    return 1;
  }
  buf = NULL;
  len = 0;
  i = 0;
  while (getline(&buf, &len, fp) != -1) {
    char * token = strtok(buf, " ");
    int sz = atoi(token);
    called_graphs[i] = (int*)malloc(sizeof(int) * (sz + 1));
    called_graphs[i][0] = sz;
    token = strtok(NULL, " ");
    j=1;
    while (token) {
      called_graphs[i][j] = atoi(token);
      j++;
      token = strtok(NULL, " ");
    }
    i++;
  }
  fclose(fp);

  print_all_paths(func_N, (const int ** const)called_graphs);

  /* Free and return. */
  for (i=0; i<func_N; ++i){
    free(call_graphs[i]);
    free(called_graphs[i]);
  }
  free(call_graphs);
  free(called_graphs);

  return 0; // Success.
}

