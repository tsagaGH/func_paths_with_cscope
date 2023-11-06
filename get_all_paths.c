#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define func_N  1813 // This is how many functions there are in the project at the moment.
static int *call_graphs[func_N];

int main(int argc, const char ** argv) {
  FILE *fp = fopen("/home/tsaga/Desktop/play_with_calling_trees/call_functions", "r");
  if (!fp) {
    fprintf(stderr, "File could not be opened. Returning...\n");
    fflush(stderr);
    return 1;
  }

  int i, j;
  /* read the file into my double array */
  char * buf = NULL;
  size_t len = 0;
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
//    printf("i = %d, [%d]:", i+1, call_graphs[i][0]);
//    for (j = 0 ; j <= call_graphs[i][0]; ++j) printf("  %d", call_graphs[i][j]); printf("\n");
    i++;
  }
  fclose(fp);

  /* find paths beginnings */
  int could_not_be_beginning[func_N] = {};
  for (i=0; i<func_N; ++i){
    for (j=0; j<call_graphs[i][0]; ++j) {
      could_not_be_beginning[ call_graphs[i][j+1] ] = 1;
    }
  }

  for (i=0; i<func_N; ++i) {
    if (could_not_be_beginning[i]==0) {
        printf("%d could be path beginning\n", i+1);
    }
  }

  /* free and return */
  for (i=0; i<func_N; ++i){
    free(call_graphs[i]);
  }

  return 0;
}

