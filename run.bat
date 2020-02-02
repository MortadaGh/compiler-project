bison -dy c-grammer.y && flex c-lexical.l && gcc lex.yy.c y.tab.c -o program.exe
PAUSE