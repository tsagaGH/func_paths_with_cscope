#include <stdio.h>
#include <stdlib.h>

#define func_N  1813 // This is how many functions there are in the project at the moment.
static int *call_graphs[func_N];

int main(int argc, const char ** argv) {
  char buffer[256];
  int i;
  FILE *fp = NULL;

  /* read the files into my data struct */
  for (i=0; i<func_N; ++i) {
    /* open file */
    int rv = sprintf(buffer, "/home/tsaga/Desktop/play_with_calling_trees/call_functions_line_dir/%d", i+1);
    fp = fopen(buffer, "r");
    if (!fp) {
      fprintf(stderr, "File _%d_ could not be opened. Returning...\n", i+1);
      fflush(stderr);
      return 1;
    }
    /* count entries and rewind */
    int cnt=0;
    char buf[8];
    while (fscanf(fp, "%s", buf)) cnt++;
    if (cnt > 0) {
      rewind(fp);
      /* read data */
      call_graphs[i] = (int*)malloc(sizeof(int) * cnt);
      cnt = 0;
      while (fscanf(fp, "%s", buf)) call_graphs[i][cnt++] = atoi(buf);
    }
    fclose(fp);
  }

  /* ... */
  


  /* free and return */
  for (i=0; i<func_N; ++i){
    free(call_graphs[i]);
  }

  return 0;
}

