%{
#include<stdio.h>
#include "yac.tab.h"

#define YY_DECL int yylex()

%}

%option caseless
%option noyywrap
%option yylineno

%%
START                               {return START;}
[x]+"-"[x]+                         {;yylval.dVal = yyleng;return SIZE_DOUBLE;}
[x]+                                {yylval.iVal = yyleng;return SIZE_INT;}
MAIN                                {return MAIN;}
VALUE                               {return VALUE;}
PRINT                               {return PRINT;}
EQUALS-TO                           {return EQUALS_TO;}
EQUALS-TO-VALUE                     {return EQUALS_TO_VALUE;}
ADD                                 {return ADD;}
TO                                  {return TO;}
END                                 {return END;}
INPUT                               {return INPUT;}
\;                                  {return TERMINATOR;} 
\,                                  {return COMMA;}
\"[^"]*\"                           {yylval.str = strdup(yytext); return WORD;}
[a-z]{1}                            {yylval.str = strdup(yytext); return VALIDTOKENID;}
[a-z]{1}[0-9a-z]{0,4}[a-z]{1}       {yylval.str = strdup(yytext); return VALIDTOKENID;}
[0-9]+.[0-9]+                       {yylval.dVal = atof(yytext);return DOUBLE;}
[0-9]+                              {yylval.iVal = atoi(yytext);return INT;}
.|\n                                {ECHO;}

%%
