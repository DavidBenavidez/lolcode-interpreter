#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
// Declare types of variables
#define UNTYPED 0
#define INTEGER 1
#define FLOAT 2
#define STRING 3
#define BOOLEAN 4

typedef struct lexeme{
  char *variable_name;
  int variable_type;
  int int_val;
  float float_val;
  char *string_val;
  int bool_val; 
  struct lexeme *next;
  struct lexeme *prev;
}TABLE;

// To remove character from string: https://stackoverflow.com/questions/5457608/how-to-remove-the-character-at-a-given-index-from-a-string-in-c
void RemoveChars(char *s, char c)
{
    int writer = 0, reader = 0;
    while (s[reader])
    {
        if (s[reader]!=c) 
        {   
            s[writer++] = s[reader];
        }
        reader++;       
    }
    s[writer]=0;
}

// Print table
void view(TABLE *root){
	if(root != NULL){
		printf("%s: ", root->variable_name);
    switch(root->variable_type){
      case 1:  
        printf("%d\n", root->int_val);
        break;
      case 2:
        printf("%f\n", root->float_val);
        break;
      case 3:
        printf("%s\n", root->string_val);
        break;
      case 4:
        printf("%d\n", root->bool_val);
        break;
    }
		view(root->next);
	}
}

void insert_table(TABLE **rootptr, TABLE *temp){
	// If linked list is empty
  if(*rootptr==NULL) *rootptr = temp;
	else{
		temp->prev = *rootptr;
    if(strcmp(temp->variable_name, (*rootptr)->variable_name) == 0){
      printf("Variable %s redeclared\n", temp->variable_name);
      exit(0);
    }
		if(*rootptr)
			insert_table(&((*rootptr)->next),temp);
	}
}

void insert_numbr(TABLE **rootptr, char *var, int value){
  TABLE *temp;
  temp = *rootptr;
  while(temp != NULL){
    if(strcmp(temp->variable_name, var) == 0){
      temp->variable_type = INTEGER;
      temp->int_val = value;
      break;
    }
    temp = temp->next;
  }
}

void insert_numbar(TABLE **rootptr, char *var, float value){
  TABLE *temp;
  temp = *rootptr;
  while(temp != NULL){
    if(strcmp(temp->variable_name, var) == 0){
      temp->variable_type = FLOAT;
      temp->float_val = value;
      break;
    }
    temp = temp->next;
  }
}

void insert_yarn(TABLE **rootptr, char *var, char *value){
  TABLE *temp;
  temp = *rootptr;
  while(temp != NULL){
    if(strcmp(temp->variable_name, var) == 0){
      temp->variable_type = STRING;
      RemoveChars(value, '\"'); // Remove quotations
      temp->string_val = value;
      break;
    }
    temp = temp->next;
  }
}

void insert_troof(TABLE **rootptr, char *var, int value){
  TABLE *temp;
  temp = *rootptr;
  while(temp != NULL){
    if(strcmp(temp->variable_name, var) == 0){
      temp->variable_type = BOOLEAN;
      temp->bool_val = value;
      break;
    }
    temp = temp->next;
  }
}

void init_lexeme(TABLE **rootptr, char *name){
	// Initialize new node (lexeme)
  TABLE *temp;
	temp = (TABLE *)malloc(sizeof(TABLE));
	temp->variable_name = name;
	temp->variable_type = UNTYPED;
	temp->next = temp->prev = NULL;
	insert_table(rootptr, temp);
}

void assign_var(TABLE **rootptr, char *newvar_name, char *refvar_name){
  TABLE *temp;
  temp = *rootptr;
  // Get the referenced variable to assign to the new variable
  while(temp != NULL){
    if(strcmp(temp->variable_name, refvar_name) == 0){
      // Assign value of referenced variable to new variable
      switch(temp->variable_type){
        case 1:
          insert_numbr(rootptr, newvar_name, temp->int_val);
          break;
        case 2:
          insert_numbar(rootptr, newvar_name, temp->float_val);
          break;
        case 3:
          insert_yarn(rootptr, newvar_name, temp->string_val);
          break;
        case 4:
          insert_troof(rootptr, newvar_name, temp->bool_val);
          break;
      }
      break;
    }
    temp = temp->next;
  }
  // if referenced variable does not exist, exit program
  if(temp == NULL){
    printf("Variable %s does not exist.\n", refvar_name);
    exit(0);
  }
}

void print_var(TABLE **rootptr, char *var_name){
  TABLE *temp;
  temp = *rootptr;
  // Get the referenced variable to assign to the new variable
  while(temp != NULL){
    if(strcmp(temp->variable_name, var_name) == 0){
      // Assign value of referenced variable to new variable
      switch(temp->variable_type){
        case 1:
          printf("%d\n", temp->int_val);
          break;
        case 2:
          printf("%f\n", temp->float_val);
          break;
        case 3:
          printf("%s\n", temp->string_val);
          break;
        case 4:
          printf("Cannot cast boolean to string value\n");
          exit(0);
      }
      break;
    }
    temp = temp->next;
  }
  // if referenced variable does not exist, exit program
  if(temp == NULL){
    printf("Variable %s does not exist.\n", var_name);
    exit(0);
  }
}

float get_var(TABLE **rootptr, char *var_name, int *isInteger){
  TABLE *temp;
  temp = *rootptr;
  // Get the referenced variable to assign to the new variable
  while(temp != NULL){
    if(strcmp(temp->variable_name, var_name) == 0){
      // Assign value of referenced variable to new variable
      switch(temp->variable_type){
        case 1:
          return((float) temp->int_val);
          break;
        case 2:
          *isInteger = 0;
          return(temp->float_val);
          break;
        case 4:
          return((float) temp->bool_val);
          break;
      }
      break;
    }
    temp = temp->next;
  }
  // if referenced variable does not exist, exit program
  if(temp == NULL){
    printf("Variable %s does not exist.\n", var_name);
    exit(0);
  }
}

int check_type(char *input_string){
  // CHECK DATA TYPE OF INPUT FROM https://stackoverflow.com/questions/34835625/how-to-check-data-type-of-user-input-like-int-double-and-string-in-c
  double x;
  double tolerance = 1e-12;
  char str[20] = "";
  int num;
  // Assign value of input to variable
  if (sscanf(input_string, "%lf", &x) == 1) { 
    // Is it a number? All integers are also doubles.
    num = (int)x; // We cast to int. 
    // Check if it is a floating point
    if ( fabs(x - num)/x > tolerance ) {
      return FLOAT;
    } else { // If it is an integer
      return INTEGER;
    }
  } 
  else if (sscanf(input_string, "%s", str) == 1) { 
      // Check if it is string
      return STRING;
  } else { 
      // No match error.
      printf("input \'%s\' not recognized\n", input_string);
  }
}
void get_input(TABLE **rootptr, char *var_name){
  // printf("Inside!\n");
  char *input_string;
  input_string = (char *)malloc(sizeof(char)*100);
  fflush(stdin);
  fgets(input_string, 100, stdin);
  fflush(stdin);

  TABLE *temp;
  temp = *rootptr;
  // Get the referenced variable to assign to the new variable
  while(temp != NULL){
    if(strcmp(temp->variable_name, var_name) == 0){
      int var_type = check_type(input_string);
      if(var_type == INTEGER) insert_numbr(rootptr, var_name, atoi(input_string));
      else if (var_type == FLOAT) insert_numbar(rootptr, var_name, atof(input_string));
      else if (var_type == STRING) insert_yarn(rootptr, var_name, input_string);      
      break;
    }
    temp = temp->next;
  }
  // if referenced variable does not exist, exit program
  if(temp == NULL){
    printf("Variable %s does not exist.\n", var_name);
    exit(0);
  }
}