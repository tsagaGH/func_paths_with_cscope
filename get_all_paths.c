#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "traverse_graph.h"

//#define func_N  1813 // This is how many functions there are in the project at the moment.
//static int *call_graphs[func_N] = {};
//static int *called_graphs[func_N] = {};

static void show_database(const int len, const int ** const database);

static int **call_graphs;
static int **called_graphs;
static int func_N = 0;

int main(int argc, const char ** argv) {
  int i, j;
  char *buf;
  size_t len;
  FILE *fp;

  /* Open functions file to count them */
  fp = fopen("/home/tsaga/Desktop/play_with_calling_trees/all_functions", "r");
  if (!fp) {
    fprintf(stderr, "File could not be opened. Returning...\n");
    fflush(stderr);
    return 1;
  }
  func_N = 0;
  char c;
  for (c = getc(fp); c != EOF; c = getc(fp)) func_N+= c=='\n';
  fclose(fp);
  call_graphs = (int**)malloc(sizeof(int*) * func_N);
  called_graphs = (int**)malloc(sizeof(int*) * func_N);

  /* Open "call" database file */
  fp = fopen("/home/tsaga/Desktop/play_with_calling_trees/call_functions", "r");
  if (!fp) {
    fprintf(stderr, "File could not be opened. Returning...\n");
    fflush(stderr);
    return 1;
  }

  /* read the file into my double array */
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


  /* Open "called" database file */
  fp = fopen("/home/tsaga/Desktop/play_with_calling_trees/called_functions", "r");
  if (!fp) {
    fprintf(stderr, "File could not be opened. Returning...\n");
    fflush(stderr);
    return 1;
  }

  /* read the file into my double array */
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

  show_database(10, (const int **)call_graphs);
  show_database(10, (const int **)called_graphs);

//  /* find paths beginnings */
//  int could_not_be_beginning[func_N] = {};
//  for (i=0; i<func_N; ++i){
//    for (j=0; j<call_graphs[i][0]; ++j) {
//      could_not_be_beginning[ call_graphs[i][j+1] ] = 1;
//    }
//  }
//
//  for (i=0; i<func_N; ++i) {
//    if (could_not_be_beginning[i]==0) {
//        printf("%d could be path beginning\n", i+1);
//    }
//  }

  /* free and return */
  for (i=0; i<func_N; ++i){
    free(call_graphs[i]);
    free(called_graphs[i]);
  }
  free(call_graphs);
  free(called_graphs);

  return 0;
}

static void show_database(const int len, const int ** const database) {
  int i, j;
  printf("Showing:\n");
  for (i=0; i<len; ++i) {
    printf("%d: [%d]", i+1, database[i][0]);
    for (j=0; j<database[i][0]; ++j) {
      printf("  %d", database[i][j+1]);
    }
    printf("\n");
  }
}

