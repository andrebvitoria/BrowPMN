grammar BrowPMN;

@header {
import struct.*;
}

prog returns [Node result]
    : (s=sttm)+ {$result = $s.result;}
    ;


sttm returns [Node result]
    : co=codigo {$result = $co.result;}
    ;

/*
funcao returns [Node result]
    : FUNCTAG func=ID LPAR (var1=ID (COMMA var2=ID)) RPAR LCOL codigo NEWLINE RCOL{
        $result = new Function($func, $var1, $var2).setCode($codigo.result);
    }
//    : FUNCTAG ID LPAR (ID (COMMA ID)*)? RPAR LCOL codigo NEWLINE RCOL
    ;
*/

codigo returns [Node result]
    : (as=assinatura {$result = $as.result;}
        | NEWLINE)+
    ;


assinatura returns [Node result]
    : variavel {$result = $variavel.result;}
    | fluxo {$result = $fluxo.result;}
    ;


variavel returns [Node result]
    : id=ID '=' valor {$result = new Variable($id.getText(), $valor.result);}
    | '!' id=ID '=' valor {$result = new Start($id.getText(), $valor.result);}
    | '#' id=ID '=' valor {$result = new End($id.getText(), $valor.result);}
    ;


fluxo returns [Node result]
    : (var=variavel) '->' (next=variavel) {$result = $var.result.setNextNode($next.result);}
    | (var=variavel) '->' (next=variavel) ('(' valor ')') {$result = $var.result.setNextNode($next.result, $valor.result);}
    ;


valor returns [String result]
    : str = STRING {$result = new String($str.getText());}
    ;


/*
condicional returns [Node result]
    // Exclusivo
    :  if=exclusivo (elif=exclusivo_caminho)* (else=exclusivo_restante)? {$result = }
    // Paralelo
    | paralelo (paralelo_caminho)*
    // Repetição
    | loop {$result = $loop.result;}
    ;


loop
    :  WHILE LPAR ID COMMA ID RPAR (LPAR STRING RPAR)? LCOL (assinatura)* NEWLINE RCOL (LPAR STRING RPAR)?
    ;


paralelo
    : DO LPAR ID COMMA ID RPAR (LPAR STRING RPAR)? LCOL (assinatura)* NEWLINE RCOL
    ;


paralelo_caminho : ELSE RPAR (LPAR STRING RPAR)? LCOL (assinatura)* NEWLINE RCOL
    ;


exclusivo
    : IF LPAR ID COMMA ID RPAR (LPAR STRING RPAR)? LCOL (assinatura)* NEWLINE RCOL
    ;


exclusivo_caminho
    : ELIF LPAR ID COMMA ID RPAR (LPAR STRING RPAR)? LCOL (assinatura)* NEWLINE RCOL
    ;


exclusivo_restante
    : ELSE RPAR (LPAR STRING RPAR)? LCOL (assinatura)* NEWLINE RCOL
    ;
*/





FUNCTAG : 'def';
COMMA : ',' ;
TAGINICIO : '!' ;
TAGFIM : '#' ;
LPAR : '(' ;
RPAR : ')' ;
PROXIMO : '->' ;
LCOL : '{' ;
RCOL : '}' ;
fragment WS : ' ';
fragment CHAR : [a-zA-Z0-9];
fragment STRTAG : '"' ;
STRING : STRTAG (CHAR|WS)* STRTAG;
ID : [_a-zA-Z][_a-zA-Z0-9]* ;
NEWLINE : '\r'? '\n' ;
ATRIBUICAO    : '=' ;
WHILE : 'while' ;
IF : 'if' ;
ELIF : 'elif';
ELSE : 'else' ;
DO : 'do';
AND : 'and';
IGNORE : [ \t\r\n]+ -> skip;
