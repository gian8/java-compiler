import java_cup.runtime.*;

%%

%unicode
%cup
%line // enable yyline
%column // enable yycolumn


%{

	public boolean debug = false; //use when parser is not ready
	public boolean dprint = false; //use when parser is ready

	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}

	private Symbol symD(String token ,int type){
		if(debug){
			System.out.println(token+": "+yytext());
			return this.sym(sym.DEBUG);
		}
		else if(dprint){
			System.out.println(token+": "+yytext());
			return this.sym(type);
		}
		else{
			return this.sym(type);
		}
	}

	private Symbol symD(String token, int type, Object value){
		if(debug){
			System.out.println(token+": "+yytext());
			return this.sym(sym.DEBUG, value);
		}
		else if(dprint){
			System.out.println(token+": "+yytext());
			return this.sym(type, value);
		}
		else{
			return this.sym(type, value);
		}
	}

%}
////////////////////////
/* REGULAR EXPRESSIONS ({..} to use regex in definitions), */

SEP = "%%"

INTEGER = ("+"|"-")?((0)|([1-9][0-9]*))
FLOAT = ("+"|"-")? ( [1-9][0-9]* "." [0-9]* ) | ( "." [0-9]+ ) | ( 0 "." [0-9]* )
DOUBLE = ("+"|"-")? (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+)) (e|E('+'|'-')?[0-9]+)?
QSTRING = \"[_a-zA-Z0-9 ]+\"
ID = [A-Za-z_][A-Za-z0-9_]*


exadecimal = ("-"(12[A-E0-9]| 1[0-2][ACE02468] | [1-9][ACE02468] | [ACE02468] ) | 0 | ([ACE02468] | [1-9A-F][ACE02468] | [1-7][0-9A-F][ACE02468] | 8[0-6][ACE02468] | 87[AC02468] ))
up6 = [A-Z]{6}([A-Z]{2})*
xyx = "xyx"
yxy = "yxy"
list_xy = ({xyx}|{yxy}){3}({xyx}|{yxy})*



binary = (0([1])*0([1])*0([1])*)| (([1])*0([1])*0([1])*0([1])*0([1])*) | (([1])*0([1])*0([1])*0([1])*0([1])*0([1])*0([1])*0([1])*)
time = "06:16:23"| 06":"16":"2[4-9] | 06":"16":"[3-5][0-9] | 06":"1[7-9]":"[0-5][0-9]| 06":"[2-5][0-9]":"[0-5][0-9] | 0[7-9]":"[0-5][0-9]":"[0-5][0-9] | 1[0-7]":"[0-5][0-9]":"[0-5][0-9] | 18":"[0-2][0-9]":"[0-5][0-9]  | 18":"30":"[0-5][0-9] |  18":"31":"[0-1][0-9]  |  "18:31:20" | "18:31:21"


ps = ("+++"|"***")
ps_list = ({ps}){7,25}
word = [a-zA-Z]{2}|[a-zA-Z]{4}|[a-zA-Z]{12}
wordlist = {word}"@"{word}"@"{word}("@"{word}"@"{word})*


TOKEN1 = {exadecimal}"$"({up6})?("hello"|{list_xy})
TOKEN2 = ("!"{binary}|"&"{time})
TOKEN3 = {ps_list}{wordlist}



%%


{FLOAT}			{ return symD("FLOAT", sym.FLOAT, new Float(yytext()));}
{DOUBLE}		{ return symD("DOUBLE", sym.DOUBLE, new Double(yytext()));}
{INTEGER}		{ return symD("INTEGER", sym.INTEGER, new Integer(yytext()));}

{SEP}			{ return symD("SEP", sym.SEP);}

"altitude"		{ return symD("A", sym.A);}
"fuel"			{ return symD("F", sym.F);}

"INIT"			{ return symD("INIT", sym.INIT);}
"IF"			{ return symD("IF", sym.IF);}
"IS"			{ return symD("IS", sym.IS);}
"THEN"			{ return symD("THEN", sym.THEN);}
"ELSE"			{ return symD("ELSE", sym.ELSE);}
"SET"			{ return symD("SET", sym.SET);}
"DONE"			{ return symD("DONE", sym.DONE);}
","				{ return symD("C", sym.C);}
";"				{ return symD("S", sym.S);}
"-"				{ return symD("MINUS", sym.MINUS);}
"."				{ return symD("POINT", sym.POINT);}
"->"			{ return symD("ARROW", sym.ARROW);}
"<"				{ return symD("MINOR", sym.MINOR);}
">"				{ return symD("MAJOR", sym.MAJOR);}
"*"				{ return symD("STAR", sym.STAR);}
"+"				{ return symD("PLUS", sym.PLUS);}
"/"				{ return symD("DIVIDE", sym.DIVIDE);}
":"				{ return symD("COL", sym.COL);}
"="				{ return symD("EQ", sym.EQ);}
"|"				{ return symD("PIPE", sym.PIPE);}

"("				{ return symD("RO", sym.RO);}
")"				{ return symD("RC", sym.RC);}
"["				{ return symD("SO", sym.SO);}
"]"				{ return symD("SC", sym.SC);}
"{"				{ return symD("CO", sym.CO);}
"}"				{ return symD("CC", sym.CC);}

{TOKEN1} 		{ return symD("TOKEN1", sym.TOKEN1);}
{TOKEN2}		{ return symD("TOKEN2", sym.TOKEN2);}
{TOKEN3}		{ return symD("TOKEN3", sym.TOKEN3);}

{ID}			{ return symD("ID", sym.ID, yytext());}
{QSTRING}		{ return symD("QSTRING", sym.QSTRING, yytext());}



"#" .* 			{;}

\r | \n | \r\n | " " | \t	{;}


.				{ System.out.println("Scanner Error: " + yytext()+" line: "+yyline+" column: "+yycolumn); }
