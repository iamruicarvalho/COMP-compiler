grammar Javamm;

@header {
    package pt.up.fe.comp2024;
}

EQUALS : '=';       // equal
SEMI : ';' ;        // semicolon
LCURLY : '{' ;      // left curly brackets
RCURLY : '}' ;      // rigth curly brackets
LPAREN : '(' ;      // left round brackets
RPAREN : ')' ;      // rigth round brackets
LRECT : '[' ;       // left square brackets
RRECT : ']' ;       // rigth square brackets
MUL : '*' ;         // multiplication
DIV : '/' ;         // division
ADD : '+' ;         // addition
SUB : '-' ;         // subtraction

IF : 'if' ;         // if
ELSE : 'else' ;     // else
WHILE : 'while' ;   // while

CLASS : 'class' ;
PUBLIC : 'public' ;
RETURN : 'return' ;

INT : [0] | ([1-9][0-9]*) ;
ID : [a-zA-Z_$][a-zA-Z$0-9_]*;   // id

COMMENT_SINGLE : '//' .*? '\n' -> skip ;    // single line comment
COMMENT_MULTI : '/*' .*? '*/' -> skip ;     // multi line comment

WS : [ \t\n\r\f]+ -> skip ;

program
    : (importDeclaration)* classDecl EOF
    ;

importDeclaration
    : 'import' importValue+=ID ('.' importValue+=ID )* ';'
    ;

classDecl
    : 'class' name=ID ( 'extends' sname=ID )? LCURLY ( varDeclaration )* ( methodDecl )* RCURLY
    ;

varDeclaration
    : type ('main' | name=ID) ';'
    ;

methodDecl
    : ('public')? type name=ID LPAREN ( param ( ',' param )* )? RPAREN LCURLY ( varDeclaration )* ( statement )* 'return' expression ';' RCURLY
    | ('public')? 'static'  type name='main' LPAREN 'String' LRECT RRECT aname=ID RPAREN LCURLY ( varDeclaration )* ( statement )* RCURLY
    ;

param:
    type name=ID
    ;

type locals [boolean isArray = false]
    : value='int' ('['{$isArray = true;}']')?   // variable number of integers
    | value='int' ('...')?
    | value='boolean'                           // boolean
    | value='double'                            // double
    | value='float'                             // float
    | value='String'                            // string
    | value='char'                              // char
    | value='byte'                              // byte
    | value='short'                             // short
    | value='long'                              // long
    | value='void'                              // void
    | value=ID                                  // id
    ;

statement
    : LCURLY ( statement )* RCURLY
    | 'if' LPAREN expression RPAREN statement 'else' statement
    | 'while' LPAREN expression RPAREN statement
    | expression ';'
    | var=ID '=' expression ';'
    | var=ID LRECT expression RRECT '=' expression ';'
    ;

expression
    : LPAREN expression RPAREN
    | 'new' 'int' LRECT expression RRECT
    | 'new' classname=ID LPAREN (expression (',' expression) *)? RPAREN
    | expression LRECT expression RRECT
    | expression '.' value=ID LPAREN (expression (',' expression) *)? RPAREN
    | expression '.' 'length'
    | value = 'this'
    | value = '!' expression
    | expression op=('*' | '/') expression
    | expression op=('+' | '-') expression
    | expression op=('<' | '>') expression
    | expression op=('==' | '!=' | '<=' | '>=' | '+=' | '-=' | '*=' | '/=') expression
    | expression op=('&&' | '||') expression
    | className=ID expression
    | LRECT ( expression ( ',' expression )* )? RRECT
    | value=INT
    | value='true'
    | value='false'
    | value=ID
    | value=ID op=('++' | '--')
    ;
