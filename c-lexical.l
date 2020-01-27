%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
%}

alpha [a-zA-Z] 
digit [0-9]
number {digit}+
id {alpha}({alpha}|{digit})*

%%

"int"	            return INT;
"float"             return FLOAT;
"char"              return CHAR;
"void"              return VOID;
"for"               return FOR;
"while"             return WHILE;
"if"	            return IF;
"else"	            return ELSE;
{number}            {yylval.String = strdup(yytext); return NUM;}
{id}                {yylval.String = strdup(yytext); return ID;}
"="                 return ASGN;
"<="                return LE;
">="                return GE;
"=="                return EQ;
"!="                return NE;
">"	                return GT;
"<"	                return LT;
"||" 	            return LOR;
"&&"  	            return LAND;
\/\/.*              ;
\/\*(.*\n)*.*\*\/   ;
[ \t\n]     { /* skip blanks and tabs */ }  
.      { return yytext[0]; } 

%%
