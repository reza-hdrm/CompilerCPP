%%

%class Scanner
%line
%char
%column
%{
        public int getYyline() {
            return yyline;
        }

        public int getYychar() {
            return yychar;
        }

        public int getYycolumn() {
            return yycolumn;
        }
%}

%{
      public static int typeOperation;
      public static int typeIdentifier;
      public static int typeAccessModifier;
      public static int line;
      public static int dateType;
      public static int literalType;
      public static final int DATATYPE = 1;
      public static final int ID = 257;
      public static final int IF = 258;
      public static final int ELSE = 259;
      public static final int DO = 276;
      public static final int WHILE = 260;
      public static final int FOR = 261;
      public static final int CLASS = 277;
      public static final int PRIVATE = 278;
      public static final int PUBLIC = 279;
      public static final int PROTEC = 286;
      public static final int VOID = 280;
      public static final int RETURN = 281;
      public static final int ACCEMOD = 2;
      public static final int INT = 294;
      public static final int DOUBLE = 295;
      public static final int FLOAT = 296;
      public static final int BOOL = 297;
      public static final int LONG = 298;
      public static final int STRING = 299;
      public static final int CHAR = 300;
      public static final int VIRTUAL = 307;
      public static final int CIN = 309;
      public static final int COUT = 310;


      public static final int NUM = 262;
      public static final int REAL = 263;
      public static final int LITERAL =301;
      public static final int INTLITERAL =302;
      public static final int BOOLLITERAL =303;
      public static final int FLOATLITERAL =304;
      public static final int CHARLITERAL =305;
      public static final int STRINGLITERAL =306;

      public static final int ERROR = 0;

      public static final int OPERATION=3;
      public static final int ADD = 288;// +
      public static final int SUB = 289;//-
      public static final int MUL = 290;//*
      public static final int DIV = 291;// /
      public static final int MOD = 292;// %
      public static final int LT = 265;// <
      public static final int LE = 266;// <=
      public static final int EQ = 267;// ==
      public static final int NE = 268;// !=
      public static final int GT = 269;// >
      public static final int GE = 270;// >=
      public final static int AND = 282;// &&
      public final static int OR = 283;// ||
      public final static int ASSIGN = 293;// =
      public final static int FALSE = 284;// false
      public final static int TRUE = 285;// true
      public static final int NOT = 300;// !

      public static final int COMMA = 271;// ,
      public static final int COLON = 286;// :
      public static final int SEMICOLON = 287;// ;
      public static final int LPAREN = 272;// (
      public static final int RPAREN = 273;// )
      public static final int LBRACE = 274;//{
      public static final int RBRACE = 275;//}
      public static final int LBRACE1 = 307;//}
      public static final int RBRACE1 = 308;//}
      public static final int LSHIFT = 311;//<<
      public static final int RSHIFT = 312;//>>



%}
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]

literal={int_literal} | {bool_literal} | {float_literal} | {char_literal} |{string_literal}
id = [*&]?[_]? {Alpha} {alpha_num}*
alpha_num= {Alpha}|{Digit}
Alpha = [_a-zA-Z]
Digit = [0-9]
Hex   = [a-fA-F]
hex_digit={Digit}|{Hex}
int_literal={decimal_literal}|{hex_literal}
decimal_literal={Digit}+
hex_literal="0x"{hex_digit} {hex_digit}*
bool_literal="true"|"false"
float_literal={decimal_literal}"."{decimal_literal}|"."{decimal_literal}|{decimal_literal}"."
char_literal=[\']{Alpha}?[\'];
string_literal=[\"]{Alpha}*[\"];
/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" {CommentContent} "*"+ "/"
EndOfLineComment= "//"{InputCharacter}* {LineTerminator}
CommentContent = ( [^*] | \*+ [^/*] )*
%%
{Comment} { /* ignore */ }
{WhiteSpace} { /* ignore */ }
if  {return IF;}
else {return ELSE;}
do  {return DO;}
while {return WHILE;}
for {return FOR;}
class {return CLASS;}
void {dateType = VOID; return DATATYPE;}
return {return RETURN;}
int {dateType = INT; return DATATYPE;}
double {dateType = DOUBLE; return DATATYPE;}
float {dateType = FLOAT; return DATATYPE;}
bool {dateType = BOOL; return DATATYPE;}
long {dateType = LONG; return DATATYPE;}
string {dateType = STRING; return DATATYPE;}
char {dateType = CHAR; return DATATYPE;}
virtual {return VIRTUAL;}
public {typeAccessModifier = PUBLIC;return ACCEMOD;}
private {typeAccessModifier = PRIVATE;return ACCEMOD;}
protected {typeAccessModifier = PROTEC;return ACCEMOD;}
cout {return COUT;}
cin  {return CIN;}
"<<" {return LSHIFT;}
">>" {return RSHIFT;}
"+=" {return OPERATION;}
"-=" {return OPERATION;}
"*=" {return OPERATION;}
"/=" {return OPERATION;}
"%=" {return OPERATION;}
"++" {return OPERATION;}
"--" {return OPERATION;}
"+" {typeOperation = ADD; return OPERATION;}
"-" {typeOperation =SUB;return OPERATION;}
"*" {typeOperation =MUL; return OPERATION;}
"/" {typeOperation =DIV; return OPERATION;}
"%" {typeOperation =MOD; return OPERATION;}
"<" {typeOperation =LT; return OPERATION;}
"<=" {typeOperation =LE; return OPERATION;}
"==" {typeOperation =EQ; return OPERATION;}
"!=" {typeOperation =NE; return OPERATION;}
">" {typeOperation =GT; return OPERATION;}
">=" {typeOperation =GE; return OPERATION;}
"&&" {typeOperation =AND; return OPERATION;}
"||" {typeOperation =OR; return OPERATION;}
"=" {typeOperation =ASSIGN; return OPERATION;}
"!" {typeOperation =NOT; return OPERATION;}
"," {return COMMA;}
":" {return COLON;}
";" {return SEMICOLON;}
"(" {return LPAREN;}
")" {return RPAREN;}
"{" {return LBRACE;}
"}" {return RBRACE;}
"[" {return LBRACE1;}
"]" {return RBRACE1;}


{id} {return ID;}
{int_literal} {literalType = INTLITERAL; return LITERAL;}
{bool_literal} {literalType = BOOLLITERAL; return LITERAL;}
{float_literal} {literalType = FLOATLITERAL; return LITERAL;}
{char_literal} {literalType = CHARLITERAL; return LITERAL;}
{string_literal} {literalType = STRINGLITERAL; return LITERAL;}
. {return ERROR;}


