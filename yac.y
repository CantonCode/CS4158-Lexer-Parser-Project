%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern int yyparse();
int yylex();
int matchId(char* id);
int getIntValue(char* id);
double getDoubleValue(char* id);
void checkExists(char* id);
void yyerror(char* message);
void insertInteger(int size, char* id);
void insertDouble(int size, char* id);
void checkIntValid(int num, char* id);
int getDoubleSize(char* id);
void checkTokenAddValid(char* id1, char* id2);
void checkDoubleValid(double num, char* id);
void checkTokensEqual(char* id1, char* id2);
int getIntSize(char* id);
int getDoubleNumber(double number);
int getType(char* id);


struct variable 
{
	int iSize;
	int iVal;
	char* id_name;
	double dVal;
	double dSize;
	char* type;
};

%}

%union 
{
	char* str;
	int iVal;
	double dVal;
}

%start program
%token <str> WORD VALIDTOKENID
%token <iVal> INT SIZE_INT 
%token <dVal> DOUBLE SIZE_DOUBLE
%token START MAIN END INPUT PRINT ADD TO SEPARATOR TERMINATOR EQUALS_TO EQUALS_TO_VALUE QUOTATION
%token SPECIALCHAR INVALIDEND COMMA VALUE

%%
program: START TERMINATOR declarations MAIN TERMINATOR statements END TERMINATOR
{printf("\n\nThis language is valid\n");YYACCEPT;};

declaration: SIZE_INT VALIDTOKENID {insertInteger($1, $2);};
declaration: SIZE_DOUBLE VALIDTOKENID {insertDouble($1, $2);};

declarations: /* empty */
| declaration TERMINATOR
| declarations declaration TERMINATOR;

statement:add_operation;
| print_operation;
| equal_operation;
| input_operation;


statements: /* empty */
| statement TERMINATOR
| statements statement TERMINATOR;
	
add_operation: ADD INT TO VALIDTOKENID {checkIntValid($2, $4);}
| ADD DOUBLE TO VALIDTOKENID{checkDoubleValid($2,$4);}
| ADD VALIDTOKENID TO VALIDTOKENID {checkTokenAddValid($2,$4);}

equal_operation: VALIDTOKENID EQUALS_TO VALIDTOKENID{checkTokensEqual($1,$3);}
| VALIDTOKENID EQUALS_TO INT{checkIntValid($3,$1);}
| VALIDTOKENID EQUALS_TO_VALUE INT{checkIntValid($3,$1);}
| VALIDTOKENID EQUALS_TO DOUBLE{checkDoubleValid($3,$1);}
| VALIDTOKENID EQUALS_TO_VALUE DOUBLE{checkDoubleValid($3,$1);}
print_operation: PRINT multiple_print;

multiple_print: VALIDTOKENID{checkExists($1);}
| WORD{}
| WORD COMMA{} multiple_print;
| VALIDTOKENID COMMA{checkExists($1);}  multiple_print;

input_operation: INPUT take_inputs;

take_inputs: VALIDTOKENID{checkExists($1);}
| VALIDTOKENID COMMA{checkExists($1);}  take_inputs;

%%


static int var_count;
static struct variable tab[100] = {0, 0, ""};

int main() 
{
	yyparse();
	return 0;
}

void checkExists(char* id) 
{
	if(!matchId(id)) 
		yyerror("Identifier does not exist");
}

int matchId(char* id) 
{
	int found = 0;
	for(int i = 0; i < var_count; i++)
	{
		if (strcasecmp(id, tab[i].id_name) == 0) 
			found = 1;
	}
	return found;
}

void insertInteger(int size, char* id) 
{
	    if(matchId(id)) 
		yyerror("Duplicate identifier");
		
		char* t = "integer";
		tab[var_count].iSize = size;
		tab[var_count].id_name = id;
		tab[var_count].type = t;
		var_count++;

}

void insertDouble(int size, char* id) 
{
	    if(matchId(id)) 
		yyerror("Duplicate identifier");

		char* t = "double";
		tab[var_count].dSize = size;
		tab[var_count].id_name = id;
		tab[var_count].type = t;
		var_count++;
}

int intLength(int number)
{
	return number == 0 ? 1 : (int) log10 ((double) number) + 1;
}

void checkIntValid(int num, char* id)
{
	checkExists(id);
	int iSize = getIntSize(id);
	int iLength = intLength(num);
	
	if(iLength != iSize)
		yyerror("Size of number is not the same as identifier size");		
}

void checkDouble(double num, char* id)
{
	checkExists(id);

	int numDigits = getDoubleNumber(num) + 1;
	int dSize = getDoubleSize(id);
	
	if(numDigits != dSize)
		yyerror("Size of number is not the same as identifier size");		
	
}

void checkDoubleValid(double num, char* id)
{
	checkExists(id);

	int numDigits = getDoubleNumber(num) + 1;
	int idSize = getDoubleSize(id);

	if(numDigits != idSize){
		yyerror("Sizes are not equal");
	}	
}

void checkTokenAddValid(char* id1, char* id2)
{
	checkExists(id1);
	checkExists(id2);
	int iSize1 = getIntSize(id1);
	int iSize2 = getIntSize(id2);
	double dSize1 = getDoubleSize(id1);
	double dSize2 = getDoubleSize(id1);
	
	if(iSize1 != iSize2 | dSize1 != dSize2)
		yyerror("Identifiers are not of the same size");
}

void checkTokensEqual(char* id1, char* id2)
{
	checkExists(id1);
	checkExists(id2);
	int iSize1 = getIntSize(id1);
	int iSize2 = getIntSize(id2);
	double dSize1 = getDoubleSize(id1);
	double dSize2 = getDoubleSize(id1);
	int type = getType(id1);
	int v1,v2;
	
if(iSize1 != iSize2 | dSize1 != dSize2)
		yyerror("Identifiers are not of the same size");

	if(!type){
		v1 = getIntValue(id1);
		v2 = getIntValue(id2);

		if(v1 != v2)
			yyerror("Identifiers are not of the same value");

	}
	else if(type){	
		v1 = getDoubleValue(id1);
		v2 = getDoubleValue(id2);

		if(v1 != v2)
			yyerror("Identifiers are not of the same value");
		}

}

int getIntValue(char* id) 
{
	int value;
	checkExists(id);
	
		for(int i = 0; i < var_count; i++) 
			if (strcasecmp(id, tab[i].id_name) == 0) 
				value = tab[i].iVal;

	return value;
}

double getDoubleValue(char* id) 
{
	int value;
	checkExists(id);

		for(int i = 0; i < var_count; i++) 
			if (strcasecmp(id, tab[i].id_name) == 0) 
				value = tab[i].dVal;

	return value;
}
int getDoubleNumber(double number) 
{
    int firstHalf =  (number == 0) ? 1 : (double) log10 ((double) number) + 1;
    int counter = 0;

    while ((int)number != number) { 
        number *= 10; 
        counter++; 
    } 
    return firstHalf+counter;
}

int getIntSize(char* id)
{
	for(int i = 0; i < var_count; i++)
		if (strcasecmp(id, tab[i].id_name) == 0) 
			return tab[i].iSize;	
}

int getDoubleSize(char* id)
{
	for(int i = 0; i < var_count; i++)
		if (strcasecmp(id, tab[i].id_name) == 0) 
			return tab[i].dSize;	
}

int getType(char* id)
{
	for(int i = 0; i < var_count; i++)
		if (strcasecmp(id, tab[i].id_name) == 0) 
			if(tab[i].type == "integer")
				return 0;
			else
				return 1;	
}

void yyerror(char* message) 
{
	printf("\n\nInvalid language instance %s ", message);
	exit(-1);
}