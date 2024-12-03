%{
#include "../obj/day03.tab.h"
%}


%%

mul                  { return MUL; }
"don't()"            { return DONT; }
"do()"               { return DO; }
[0-9]+               { yylval.num = atoi(yytext); return NUM; }
,                    { return COMMA; }
\(                   { return LP; }
\)                   { return RP; }
[ \t\n]+             ; 
.                    { return OTHER; }

%%

int yywrap() {
    return 1;
}
