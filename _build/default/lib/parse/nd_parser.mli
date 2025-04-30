
(* The type of tokens. *)

type token = 
  | WRITE
  | WITH
  | VALUE
  | UPARROW
  | TYPE
  | SUSP
  | STAR
  | SLASH
  | RPAREN
  | RIGHTARROW
  | REUSE
  | RECORD
  | READ
  | RBRACKET
  | RBRACE
  | RANGLE
  | PROC
  | PLUS
  | NAT of (int)
  | MINUS
  | MATCH
  | LPAREN
  | LBRACKET
  | LBRACE
  | LANGLE
  | LABEL of (string)
  | INT32
  | INST
  | IDENT of (string)
  | ID
  | FUN
  | FORCE
  | FAIL
  | EQUAL
  | EOF
  | END
  | DOT
  | DEFN
  | CUT
  | COMMA
  | COLON
  | CLOS
  | CALL
  | BAR
  | ARROW
  | AMPERSAND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.env)
