{
(** ND Lexer *)

module N = Nd_parser

let errors = Error_msg.create ()

let text = Lexing.lexeme

let from_lexbuf : Lexing.lexbuf -> Mark.src_span option =
  fun lexbuf ->
    Mark.of_positions
      (Lexing.lexeme_start_p lexbuf)
      (Lexing.lexeme_end_p lexbuf)
    |> Option.some

let error lexbuf (msg : string) =
  let src_span = from_lexbuf lexbuf in
  Error_msg.error errors src_span msg

}

let idstart = ['a'-'z' 'A'-'Z' '_']
let idchar = ['a'-'z' 'A'-'Z' '_' '0'-'9'] (* omitting '$' from Sax *)
let ident = idstart idchar*
let label = '\'' idchar+

let digit = ['0'-'9']

let ws = [' ' '\t' '\r']

rule initial = parse
  | ws+  { initial lexbuf }
  | '\n' { Lexing.new_line lexbuf;
           initial lexbuf
         }
  | "%" { comment_line lexbuf }
  | "(*" { comment_block 1 lexbuf }

  | ',' { N.COMMA }
  | ':' { N.COLON }
  | '.' { N.DOT }         (* Lab 3 *)

  | '(' { N.LPAREN }
  | ')' { N.RPAREN }
  | '{' { N.LBRACE }
  | '}' { N.RBRACE }
  | '[' { N.LBRACKET }    (* Lab 4 *)
  | ']' { N.RBRACKET }    (* Lab 4 *)
  | '<' { N.LANGLE }      (* Lab 4 *)
  | '>' { N.RANGLE }      (* Lab 4 *)

  | "=>" { N.RIGHTARROW }
  | '=' { N.EQUAL }
  | '|' { N.BAR }

  | '*' { N.STAR }
  | '+' { N.PLUS }
  | "->" { N.ARROW }   (* Lab 3 *)

  | '-'             { N.MINUS }
  | '/'             { N.SLASH }

  | digit+ as n { N.NAT (int_of_string n) }
  | '-' digit+ as n { N.NAT (int_of_string n) }
  
  | '&' { N.AMPERSAND } (* Lab 3 *)
  | '^' { N.UPARROW }   (* Lab 4 *)

  | "type"   { N.TYPE }
  | "defn"   { N.DEFN }
  | "fail"   { N.FAIL } (* not parsed! *)
  | "match"  { N.MATCH }
  | "with"   { N.WITH }
  | "end"    { N.END }
  | "fun"    { N.FUN }    (* Lab 3 *)
  | "record" { N.RECORD } (* Lab 3 *)
  | "int32" { N.INT32 }

  | "inst"   { N.INST }   (* Lab 4 *)
  | "susp"   { N.SUSP }   (* Lab 4 *)
  | "force"  { N.FORCE }  (* Lab 4 *)

  (* from *.sax, to avoid conflicts *)
  | "proc"   { N.PROC }
  | "read"   { N.READ }
  | "write"  { N.WRITE }
  | "cut"    { N.CUT }
  | "id"     { N.ID }
  | "call"   { N.CALL }
  | "reuse"  { N.REUSE }
  | "clos"   { N.CLOS }  (* Lab 3 Sax *)

  (* from *.sax.val *)
  | "value"  { N.VALUE }

  | label as name { N.LABEL name }
  | ident as name { N.IDENT name }

  | eof { N.EOF }

  | _  { error lexbuf
           (Printf.sprintf "Illegal character '%s'" (text lexbuf));
         initial lexbuf
       }

and comment_line = parse
  | '\n' { Lexing.new_line lexbuf; initial lexbuf }
  | eof  { N.EOF }
  | _ { comment_line lexbuf }

and comment_block depth = parse
  | '\n' { Lexing.new_line lexbuf; comment_block depth lexbuf }
  | "*)" { if depth = 1 then initial lexbuf else comment_block (depth-1) lexbuf }
  | "(*" { comment_block (depth+1) lexbuf }
  | _ { comment_block depth lexbuf }

{}
