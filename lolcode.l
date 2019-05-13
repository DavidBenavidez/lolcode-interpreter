%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"HAI"                       {return HAI;}
"KTHXBYE"                   {return KTHXBYE;}
"I HAS A "                  {return VAR;}
"ITZ"                       {return ITZ;}
"SUM"                       {return SUM;}
"DIFF"                      {return DIFF;}
"QUOSHUNT"                  {return QUOSHUNT;}
"PRODUKT"                   {return PRODUKT;}
"MOD"                       {return MOD;}
"BIGGR"                     {return BIGGR;}
"SMALLR"                    {return SMALLR;}
"OF"                        {return OF;}
"AN"                        {return AN;}
"VISIBLE "                  {return VISIBLE;}
"GIMMEH "                   {return GIMMEH;}
"BOTH"                      {return BOTH;} 
"EITHER"                    {return EITHER;} 
"WON"                       {return WON;} 
"NOT"                       {return NOT;}
"SAEM"                      {return SAEM;} 
"DIFFRINT"                  {return DIFFRINT;}
"SMOOSH"                    {return SMOOSH;}
"R"                         {return R;}
"O RLY?"                    {return INITIF;}
"YA RLY"                    {return IF;}
"NO WAI"                    {return ELSE;}
"OIC?"                      {return ENDIF;}
("WIN"|"FAIL")  {
                    if(strcmp(yytext, "WIN") == 0){
                        yylval.number = 1;
                    }else{
                        yylval.number = 0;
                    }
                    return TROOF;
                }
(-?[0-9]+)  {
                yylval.number = atoi(yytext);
                return NUMBR;
            }
(-?[0-9]+\.[0-9]+)  {
                        yylval.floatVal = atof(yytext);
                        return NUMBAR;
                    }
(\"(\\.|[^"\\])*\")     {
                            yylval.string = strdup(yytext);
	                    	return YARN;
                        }
([a-zA-Z]{1}[a-zA-Z]+)  {
                            yylval.string = strdup(yytext);
                            return IDENTIFIER;
                        }
[ \t\n]                 ;
[-+=;]                  {return yytext[0];}
%%
int yywrap (void) {return 1;}
