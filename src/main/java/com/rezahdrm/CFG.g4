grammar CFG;
program     : (var_dec | method_dec | class_dec |assignment)* ;
var_dec     : Type var_list array?';';
array       :('['int_literal']')+;
var_list    : id (Assin_op expr)?(','var_list)?;
method_list : Type id ('=' expr)?(','method_list)?;
method_dec  : ret_type id '('method_list?')' block;
block       : '{' (var_dec|statement)* '}';
class_block : '{'(var_dec|assignment';'| ModType? (method_dec|init_dec)|ModType':')*'}';
init_dec    :  id '('method_list?')' block;
ModType:'public'|'protected'|'private';
class_dec:'class'id(':'ModType? id)*class_block;
Type :'int'|'long'|'float'|'double'|'string'|'char'|'bool';
ret_type : 'void'|Type;
WS : [ \t\r\n]+ -> skip ;
COMMENT :('//'.*? '\n' | '/*' .*? '*//*') -> skip ;
statement : assignment
          |method_call';'
          |'if''('expr')'(block|statement)?('else'(block|statement)?)?
          |'do'block 'while''('expr')'';'
          |'while''('expr')' block
          |'for''('assignment?';'expr?';'assignment?')'block
          |'return'expr?';'
          |'break'';'
          |'continue'';'
          |'cin' '>>' id ';'
          |'cout' '<<' (id|literal) ';'
          |block
          ;
assignment : id Assin_op expr';';
method_call: id '('parameter_list?')';
parameter_list: expr (','parameter_list)?;
expr:method_call
    |expr AddOp term|term
    |expr Bin_op term
    |'−'expr
    |'!'expr
    ;


/*
expr:method_call
    |expr op expr
    |id
    |literal
    |'(' expr ')'
    |'−'expr
    |'!'expr
    ;
*/


/*
expr:term expr1|method_call|'−'expr|'!'expr;
expr1:AddOp term expr1|Bin_op term expr1|skip;
term:num term1;
term1:MulOp num term1|skip;
num:literal|id|'(' expr ')';
*/
Assin_op:('+='|'*='|'/='|'-='|'%=');
Bin_op :(Rel_Op|Eq_Op|Cond_Op);
term:term MulOp num|num;
num:literal|id|'(' expr ')';

AddOp: [+|-];
MulOp: [*|/]|'%';
Rel_Op:('<'|'>'|'<='|'>=');
Eq_Op:('=='|'!=');
Cond_Op:('&&'|'||');

literal:int_literal | bool_literal | float_literal | char_literal |string_literal;
id : ('&'|'*')? Alpha alpha_num*;
alpha_num: Alpha | Digit;
Alpha:[_a-zA-Z];
Digit:[0-9];
Hex:[a-fA-F];
hex_digit:Digit|Hex;
int_literal:decimal_literal|hex_literal;
decimal_literal:Digit+;
hex_literal:'0x'hex_digit hex_digit*;
bool_literal:'true'|'false';
float_literal:decimal_literal'.'decimal_literal|'.'decimal_literal|decimal_literal'.';
char_literal:'\''Char'\'';
string_literal:'"'Char*'"';
Char : Alpha|Digit;
Symbol: [!@#$%^&*()+=~\n\t\r];