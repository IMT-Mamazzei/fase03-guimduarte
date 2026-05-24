package br.maua.cic303;

import java_cup.runtime.*;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    // Função auxiliar para gerar Symbols (O formato que o CUP entende)
    private Symbol token(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol token(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?
Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

%%
/* ========================================================================= */
/* REGRAS LÉXICAS INTEGRADAS AO CUP                                          */
/* ========================================================================= */

<YYINITIAL> {
    
    {WhiteSpace}    { /* Não faz nada */ }

    /* Palavras Reservadas */
    "if"            { return token(sym.IF); }
    "then"          { return token(sym.THEN); }
    "else"          { return token(sym.ELSE); }
    "while"         { return token(sym.WHILE); }

    /* Pontuação */
    "("             { return token(sym.LPAREN); }
    ")"             { return token(sym.RPAREN); }
    "{"             { return token(sym.LBRACE); }
    "}"             { return token(sym.RBRACE); }
    ";"             { return token(sym.SEMI); }

    /* Operadores de Atribuição e Relacionais */
    "=="            { return token(sym.REL_OP, yytext()); }
    "!="            { return token(sym.REL_OP, yytext()); }
    "<="            { return token(sym.REL_OP, yytext()); }
    ">="            { return token(sym.REL_OP, yytext()); }
    ">"             { return token(sym.REL_OP, yytext()); }
    "<"             { return token(sym.REL_OP, yytext()); }
    "="             { return token(sym.ASSIGN); }

    /* Operadores Matemáticos */
    "+" | "-"       { return token(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return token(sym.MUL_OP, yytext()); }

    /* Macros */
    {Identifier}    { return token(sym.ID, yytext()); }
    {Number}        { return token(sym.NUMBER, yytext()); }

    /* Identificadores grandes demais - Lança uma exceção pois o CUP cuida dos erros sintáticos */
    {Letter}({Letter}|{Digit}|_){32} { 
        throw new RuntimeException("Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext()); 
    }

    /* Fallback */
    .               { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

<<EOF>>             { return token(sym.EOF); }