%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
%}

alpha       [a-zA-Z_] 
digit       [0-9]
text        "\""([^\n\"\\]*(\\)*)*"\""  
charactere  '([^'\\\n]|\\.)'
number      ([0-9]+|[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?)
id          {alpha}({alpha}|{digit})*
%option yylineno

%%

"int"	            return INT;
"float"             return FLOAT;
"char"              return CHAR;
"void"              return VOID;
"for"               return FOR;
"while"             return WHILE;
"if"	            return IF;
"else"	            return ELSE;
"printf"            return PRINTF;
"scanf"             return SCANF;
{number}            {yylval.String = strdup(yytext); return NUM;}
{id}                {yylval.String = strdup(yytext); return ID;}
{text}              {yylval.String = strdup(yytext); return TEXT;}
{charactere}        {yylval.String = strdup(yytext); return CHARACTERE;}
"{"                 return LEFTBRACKET;
"}"                 return RIGHTBRACKET;
";"                 return SEMICOLON;
"("                 return LEFTPARENTHESIS;
")"                 return RIGHTPARENTHESIS;
"="                 {yylval.String = strdup(yytext); return ASGN;}
"<="                {yylval.String = strdup(yytext); return LE;}
">="                {yylval.String = strdup(yytext); return GE;}
"=="                {yylval.String = strdup(yytext); return EQ;}
"!="                {yylval.String = strdup(yytext); return NE;}
">"	                {yylval.String = strdup(yytext); return GT;}
"<"	                {yylval.String = strdup(yytext); return LT;}
"||" 	            {yylval.String = strdup(yytext); return LOR;}
"&&"  	            {yylval.String = strdup(yytext); return LAND;}
"+"  	            {yylval.String = strdup(yytext); return PLUS;}
"-"  	            {yylval.String = strdup(yytext); return MINUS;}
"*"  	            {yylval.String = strdup(yytext); return MUL;}
"/"  	            {yylval.String = strdup(yytext); return DIV;}
"%"  	            {yylval.String = strdup(yytext); return MOD;}
\/\/.*              ;
\/\*(.*\n)*.*\*\/   ;
[ \t]               { /* skip blanks and tabs */ }
\n                  { }  
.                   { return yytext[0]; } 

%%
