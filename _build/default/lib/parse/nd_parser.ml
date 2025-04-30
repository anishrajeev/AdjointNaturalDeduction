
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
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
    | NAT of (
# 7 "lib/parse/nd_parser.mly"
       (int)
# 33 "lib/parse/nd_parser.ml"
  )
    | MINUS
    | MATCH
    | LPAREN
    | LBRACKET
    | LBRACE
    | LANGLE
    | LABEL of (
# 9 "lib/parse/nd_parser.mly"
       (string)
# 44 "lib/parse/nd_parser.ml"
  )
    | INT32
    | INST
    | IDENT of (
# 8 "lib/parse/nd_parser.mly"
       (string)
# 51 "lib/parse/nd_parser.ml"
  )
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
  
end

include MenhirBasics

# 1 "lib/parse/nd_parser.mly"
  
(** ND Parser *)

    let errors = Error_msg.create ()

# 81 "lib/parse/nd_parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_prog) _menhir_state
    (** State 000.
        Stack shape : .
        Start symbol: prog. *)

  | MenhirState003 : (('s, _menhir_box_prog) _menhir_cell1_TYPE _menhir_cell0_IDENT, _menhir_box_prog) _menhir_state
    (** State 003.
        Stack shape : TYPE IDENT.
        Start symbol: prog. *)

  | MenhirState007 : ((('s, _menhir_box_prog) _menhir_cell1_TYPE _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_modes, _menhir_box_prog) _menhir_state
    (** State 007.
        Stack shape : TYPE IDENT modes.
        Start symbol: prog. *)

  | MenhirState008 : (('s, _menhir_box_prog) _menhir_cell1_UPARROW, _menhir_box_prog) _menhir_state
    (** State 008.
        Stack shape : UPARROW.
        Start symbol: prog. *)

  | MenhirState010 : (('s, _menhir_box_prog) _menhir_cell1_PLUS, _menhir_box_prog) _menhir_state
    (** State 010.
        Stack shape : PLUS.
        Start symbol: prog. *)

  | MenhirState012 : (('s, _menhir_box_prog) _menhir_cell1_LABEL, _menhir_box_prog) _menhir_state
    (** State 012.
        Stack shape : LABEL.
        Start symbol: prog. *)

  | MenhirState014 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN, _menhir_box_prog) _menhir_state
    (** State 014.
        Stack shape : LPAREN.
        Start symbol: prog. *)

  | MenhirState015 : (('s, _menhir_box_prog) _menhir_cell1_LBRACKET, _menhir_box_prog) _menhir_state
    (** State 015.
        Stack shape : LBRACKET.
        Start symbol: prog. *)

  | MenhirState017 : ((('s, _menhir_box_prog) _menhir_cell1_LBRACKET, _menhir_box_prog) _menhir_cell1_mode, _menhir_box_prog) _menhir_state
    (** State 017.
        Stack shape : LBRACKET mode.
        Start symbol: prog. *)

  | MenhirState018 : (('s, _menhir_box_prog) _menhir_cell1_LANGLE, _menhir_box_prog) _menhir_state
    (** State 018.
        Stack shape : LANGLE.
        Start symbol: prog. *)

  | MenhirState021 : (('s, _menhir_box_prog) _menhir_cell1_IDENT, _menhir_box_prog) _menhir_state
    (** State 021.
        Stack shape : IDENT.
        Start symbol: prog. *)

  | MenhirState024 : (('s, _menhir_box_prog) _menhir_cell1_mode, _menhir_box_prog) _menhir_state
    (** State 024.
        Stack shape : mode.
        Start symbol: prog. *)

  | MenhirState027 : (('s, _menhir_box_prog) _menhir_cell1_AMPERSAND, _menhir_box_prog) _menhir_state
    (** State 027.
        Stack shape : AMPERSAND.
        Start symbol: prog. *)

  | MenhirState031 : (('s, _menhir_box_prog) _menhir_cell1_alt, _menhir_box_prog) _menhir_state
    (** State 031.
        Stack shape : alt.
        Start symbol: prog. *)

  | MenhirState034 : (('s, _menhir_box_prog) _menhir_cell1_tp, _menhir_box_prog) _menhir_state
    (** State 034.
        Stack shape : tp.
        Start symbol: prog. *)

  | MenhirState037 : (('s, _menhir_box_prog) _menhir_cell1_tp, _menhir_box_prog) _menhir_state
    (** State 037.
        Stack shape : tp.
        Start symbol: prog. *)

  | MenhirState048 : (('s, _menhir_box_prog) _menhir_cell1_INST _menhir_cell0_IDENT, _menhir_box_prog) _menhir_state
    (** State 048.
        Stack shape : INST IDENT.
        Start symbol: prog. *)

  | MenhirState051 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_state
    (** State 051.
        Stack shape : LPAREN IDENT.
        Start symbol: prog. *)

  | MenhirState055 : ((('s, _menhir_box_prog) _menhir_cell1_INST _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_parms, _menhir_box_prog) _menhir_state
    (** State 055.
        Stack shape : INST IDENT parms.
        Start symbol: prog. *)

  | MenhirState057 : (('s, _menhir_box_prog) _menhir_cell1_parm, _menhir_box_prog) _menhir_state
    (** State 057.
        Stack shape : parm.
        Start symbol: prog. *)

  | MenhirState061 : (('s, _menhir_box_prog) _menhir_cell1_DEFN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_state
    (** State 061.
        Stack shape : DEFN IDENT.
        Start symbol: prog. *)

  | MenhirState063 : ((('s, _menhir_box_prog) _menhir_cell1_DEFN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_parms, _menhir_box_prog) _menhir_state
    (** State 063.
        Stack shape : DEFN IDENT parms.
        Start symbol: prog. *)

  | MenhirState065 : (((('s, _menhir_box_prog) _menhir_cell1_DEFN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_parms, _menhir_box_prog) _menhir_cell1_tp, _menhir_box_prog) _menhir_state
    (** State 065.
        Stack shape : DEFN IDENT parms tp.
        Start symbol: prog. *)

  | MenhirState066 : (('s, _menhir_box_prog) _menhir_cell1_SUSP, _menhir_box_prog) _menhir_state
    (** State 066.
        Stack shape : SUSP.
        Start symbol: prog. *)

  | MenhirState067 : (('s, _menhir_box_prog) _menhir_cell1_RECORD, _menhir_box_prog) _menhir_state
    (** State 067.
        Stack shape : RECORD.
        Start symbol: prog. *)

  | MenhirState070 : (('s, _menhir_box_prog) _menhir_cell1_BAR _menhir_cell0_LABEL, _menhir_box_prog) _menhir_state
    (** State 070.
        Stack shape : BAR LABEL.
        Start symbol: prog. *)

  | MenhirState072 : (('s, _menhir_box_prog) _menhir_cell1_MATCH, _menhir_box_prog) _menhir_state
    (** State 072.
        Stack shape : MATCH.
        Start symbol: prog. *)

  | MenhirState073 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN, _menhir_box_prog) _menhir_state
    (** State 073.
        Stack shape : LPAREN.
        Start symbol: prog. *)

  | MenhirState075 : (('s, _menhir_box_prog) _menhir_cell1_LANGLE, _menhir_box_prog) _menhir_state
    (** State 075.
        Stack shape : LANGLE.
        Start symbol: prog. *)

  | MenhirState076 : (('s, _menhir_box_prog) _menhir_cell1_LABEL, _menhir_box_prog) _menhir_state
    (** State 076.
        Stack shape : LABEL.
        Start symbol: prog. *)

  | MenhirState077 : (('s, _menhir_box_prog) _menhir_cell1_IDENT, _menhir_box_prog) _menhir_state
    (** State 077.
        Stack shape : IDENT.
        Start symbol: prog. *)

  | MenhirState079 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN, _menhir_box_prog) _menhir_state
    (** State 079.
        Stack shape : LPAREN.
        Start symbol: prog. *)

  | MenhirState083 : (('s, _menhir_box_prog) _menhir_cell1_FUN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_state
    (** State 083.
        Stack shape : FUN IDENT.
        Start symbol: prog. *)

  | MenhirState085 : (('s, _menhir_box_prog) _menhir_cell1_numexp, _menhir_box_prog) _menhir_state
    (** State 085.
        Stack shape : numexp.
        Start symbol: prog. *)

  | MenhirState087 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN, _menhir_box_prog) _menhir_state
    (** State 087.
        Stack shape : LPAREN.
        Start symbol: prog. *)

  | MenhirState090 : (('s, _menhir_box_prog) _menhir_cell1_exp, _menhir_box_prog) _menhir_state
    (** State 090.
        Stack shape : exp.
        Start symbol: prog. *)

  | MenhirState094 : (('s, _menhir_box_prog) _menhir_cell1_numexp, _menhir_box_prog) _menhir_state
    (** State 094.
        Stack shape : numexp.
        Start symbol: prog. *)

  | MenhirState096 : (('s, _menhir_box_prog) _menhir_cell1_numexp, _menhir_box_prog) _menhir_state
    (** State 096.
        Stack shape : numexp.
        Start symbol: prog. *)

  | MenhirState098 : (('s, _menhir_box_prog) _menhir_cell1_numexp, _menhir_box_prog) _menhir_state
    (** State 098.
        Stack shape : numexp.
        Start symbol: prog. *)

  | MenhirState100 : (('s, _menhir_box_prog) _menhir_cell1_numexp, _menhir_box_prog) _menhir_state
    (** State 100.
        Stack shape : numexp.
        Start symbol: prog. *)

  | MenhirState105 : (('s, _menhir_box_prog) _menhir_cell1_LANGLE, _menhir_box_prog) _menhir_state
    (** State 105.
        Stack shape : LANGLE.
        Start symbol: prog. *)

  | MenhirState113 : (('s, _menhir_box_prog) _menhir_cell1_atom, _menhir_box_prog) _menhir_state
    (** State 113.
        Stack shape : atom.
        Start symbol: prog. *)

  | MenhirState121 : ((('s, _menhir_box_prog) _menhir_cell1_MATCH, _menhir_box_prog) _menhir_cell1_exp, _menhir_box_prog) _menhir_state
    (** State 121.
        Stack shape : MATCH exp.
        Start symbol: prog. *)

  | MenhirState122 : (('s, _menhir_box_prog) _menhir_cell1_BAR, _menhir_box_prog) _menhir_state
    (** State 122.
        Stack shape : BAR.
        Start symbol: prog. *)

  | MenhirState123 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN, _menhir_box_prog) _menhir_state
    (** State 123.
        Stack shape : LPAREN.
        Start symbol: prog. *)

  | MenhirState125 : (('s, _menhir_box_prog) _menhir_cell1_LANGLE, _menhir_box_prog) _menhir_state
    (** State 125.
        Stack shape : LANGLE.
        Start symbol: prog. *)

  | MenhirState126 : (('s, _menhir_box_prog) _menhir_cell1_LABEL, _menhir_box_prog) _menhir_state
    (** State 126.
        Stack shape : LABEL.
        Start symbol: prog. *)

  | MenhirState131 : (('s, _menhir_box_prog) _menhir_cell1_pat, _menhir_box_prog) _menhir_state
    (** State 131.
        Stack shape : pat.
        Start symbol: prog. *)

  | MenhirState136 : ((('s, _menhir_box_prog) _menhir_cell1_BAR, _menhir_box_prog) _menhir_cell1_pat, _menhir_box_prog) _menhir_state
    (** State 136.
        Stack shape : BAR pat.
        Start symbol: prog. *)

  | MenhirState140 : (('s, _menhir_box_prog) _menhir_cell1_branch, _menhir_box_prog) _menhir_state
    (** State 140.
        Stack shape : branch.
        Start symbol: prog. *)

  | MenhirState145 : (('s, _menhir_box_prog) _menhir_cell1_field, _menhir_box_prog) _menhir_state
    (** State 145.
        Stack shape : field.
        Start symbol: prog. *)

  | MenhirState150 : (('s, _menhir_box_prog) _menhir_cell1_defn, _menhir_box_prog) _menhir_state
    (** State 150.
        Stack shape : defn.
        Start symbol: prog. *)


and ('s, 'r) _menhir_cell1_alt = 
  | MenhirCell1_alt of 's * ('s, 'r) _menhir_state * (string * Ast.tp)

and ('s, 'r) _menhir_cell1_atom = 
  | MenhirCell1_atom of 's * ('s, 'r) _menhir_state * (Ast.atom)

and ('s, 'r) _menhir_cell1_branch = 
  | MenhirCell1_branch of 's * ('s, 'r) _menhir_state * (Ast.pat * Ast.exp)

and ('s, 'r) _menhir_cell1_defn = 
  | MenhirCell1_defn of 's * ('s, 'r) _menhir_state * (Ast.defn)

and ('s, 'r) _menhir_cell1_exp = 
  | MenhirCell1_exp of 's * ('s, 'r) _menhir_state * (Ast.exp)

and ('s, 'r) _menhir_cell1_field = 
  | MenhirCell1_field of 's * ('s, 'r) _menhir_state * (string * Ast.exp)

and ('s, 'r) _menhir_cell1_mode = 
  | MenhirCell1_mode of 's * ('s, 'r) _menhir_state * (Ast.mode)

and ('s, 'r) _menhir_cell1_modes = 
  | MenhirCell1_modes of 's * ('s, 'r) _menhir_state * (Ast.mode list)

and ('s, 'r) _menhir_cell1_numexp = 
  | MenhirCell1_numexp of 's * ('s, 'r) _menhir_state * (Ast.exp)

and ('s, 'r) _menhir_cell1_parm = 
  | MenhirCell1_parm of 's * ('s, 'r) _menhir_state * (Ast.parm)

and ('s, 'r) _menhir_cell1_parms = 
  | MenhirCell1_parms of 's * ('s, 'r) _menhir_state * (Ast.parm list)

and ('s, 'r) _menhir_cell1_pat = 
  | MenhirCell1_pat of 's * ('s, 'r) _menhir_state * (Ast.pat)

and ('s, 'r) _menhir_cell1_tp = 
  | MenhirCell1_tp of 's * ('s, 'r) _menhir_state * (Ast.tp)

and ('s, 'r) _menhir_cell1_AMPERSAND = 
  | MenhirCell1_AMPERSAND of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_BAR = 
  | MenhirCell1_BAR of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_DEFN = 
  | MenhirCell1_DEFN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_FUN = 
  | MenhirCell1_FUN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_IDENT = 
  | MenhirCell1_IDENT of 's * ('s, 'r) _menhir_state * (
# 8 "lib/parse/nd_parser.mly"
       (string)
# 400 "lib/parse/nd_parser.ml"
)

and 's _menhir_cell0_IDENT = 
  | MenhirCell0_IDENT of 's * (
# 8 "lib/parse/nd_parser.mly"
       (string)
# 407 "lib/parse/nd_parser.ml"
)

and ('s, 'r) _menhir_cell1_INST = 
  | MenhirCell1_INST of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LABEL = 
  | MenhirCell1_LABEL of 's * ('s, 'r) _menhir_state * (
# 9 "lib/parse/nd_parser.mly"
       (string)
# 417 "lib/parse/nd_parser.ml"
)

and 's _menhir_cell0_LABEL = 
  | MenhirCell0_LABEL of 's * (
# 9 "lib/parse/nd_parser.mly"
       (string)
# 424 "lib/parse/nd_parser.ml"
)

and ('s, 'r) _menhir_cell1_LANGLE = 
  | MenhirCell1_LANGLE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LBRACKET = 
  | MenhirCell1_LBRACKET of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LPAREN = 
  | MenhirCell1_LPAREN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_MATCH = 
  | MenhirCell1_MATCH of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_PLUS = 
  | MenhirCell1_PLUS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_RECORD = 
  | MenhirCell1_RECORD of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_SUSP = 
  | MenhirCell1_SUSP of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_TYPE = 
  | MenhirCell1_TYPE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_UPARROW = 
  | MenhirCell1_UPARROW of 's * ('s, 'r) _menhir_state

and _menhir_box_prog = 
  | MenhirBox_prog of (Ast.env) [@@unboxed]

let _menhir_action_01 =
  fun l tau ->
    (
# 180 "lib/parse/nd_parser.mly"
                                ( (l, tau) )
# 462 "lib/parse/nd_parser.ml"
     : (string * Ast.tp))

let _menhir_action_02 =
  fun alt ->
    (
# 176 "lib/parse/nd_parser.mly"
               ( [alt] )
# 470 "lib/parse/nd_parser.ml"
     : ((string * Ast.tp) list))

let _menhir_action_03 =
  fun alt alts ->
    (
# 177 "lib/parse/nd_parser.mly"
                                   ( alt::alts )
# 478 "lib/parse/nd_parser.ml"
     : ((string * Ast.tp) list))

let _menhir_action_04 =
  fun x ->
    (
# 112 "lib/parse/nd_parser.mly"
                              ( Ast.Exp(Ast.Var(x)) )
# 486 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_05 =
  fun () ->
    (
# 113 "lib/parse/nd_parser.mly"
                              ( Ast.Exp(Ast.Unit) )
# 494 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_06 =
  fun e ->
    (
# 114 "lib/parse/nd_parser.mly"
                              ( Ast.Exp(e) )
# 502 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_07 =
  fun k ->
    (
# 115 "lib/parse/nd_parser.mly"
                              ( Ast.Dot(k) )
# 510 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_08 =
  fun e ->
    (
# 116 "lib/parse/nd_parser.mly"
                              ( Ast.Exp(Ast.Shift(e)) )
# 518 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_09 =
  fun () ->
    (
# 117 "lib/parse/nd_parser.mly"
                              ( Ast.Force )
# 526 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_10 =
  fun n ->
    (
# 118 "lib/parse/nd_parser.mly"
             ( Ast.Exp (Ast.Int n) )
# 534 "lib/parse/nd_parser.ml"
     : (Ast.atom))

let _menhir_action_11 =
  fun atom ->
    (
# 121 "lib/parse/nd_parser.mly"
                             ( [atom] )
# 542 "lib/parse/nd_parser.ml"
     : (Ast.atom list))

let _menhir_action_12 =
  fun atom atoms ->
    (
# 122 "lib/parse/nd_parser.mly"
                                ( atom::atoms )
# 550 "lib/parse/nd_parser.ml"
     : (Ast.atom list))

let _menhir_action_13 =
  fun e p ->
    (
# 132 "lib/parse/nd_parser.mly"
                                       ( (p, e) )
# 558 "lib/parse/nd_parser.ml"
     : (Ast.pat * Ast.exp))

let _menhir_action_14 =
  fun branch branches ->
    (
# 127 "lib/parse/nd_parser.mly"
    ( branch::branches )
# 566 "lib/parse/nd_parser.ml"
     : ((Ast.pat * Ast.exp) list))

let _menhir_action_15 =
  fun () ->
    (
# 129 "lib/parse/nd_parser.mly"
    ( [] )
# 574 "lib/parse/nd_parser.ml"
     : ((Ast.pat * Ast.exp) list))

let _menhir_action_16 =
  fun a ms tau ->
    (
# 82 "lib/parse/nd_parser.mly"
    ( Ast.TypeDefn(a, ms, tau) )
# 582 "lib/parse/nd_parser.ml"
     : (Ast.defn))

let _menhir_action_17 =
  fun e f parms tau ->
    (
# 85 "lib/parse/nd_parser.mly"
    ( Ast.ExpDefn(f, parms, tau, e) )
# 590 "lib/parse/nd_parser.ml"
     : (Ast.defn))

let _menhir_action_18 =
  fun f parms tau ->
    (
# 88 "lib/parse/nd_parser.mly"
    ( Ast.InstDefn(f, parms, tau) )
# 598 "lib/parse/nd_parser.ml"
     : (Ast.defn))

let _menhir_action_19 =
  fun e1 e2 ->
    (
# 91 "lib/parse/nd_parser.mly"
                                    ( Ast.Eq (e1, e2) )
# 606 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_20 =
  fun e1 e2 ->
    (
# 92 "lib/parse/nd_parser.mly"
                                      ( Ast.Add   (e1, e2) )
# 614 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_21 =
  fun e1 e2 ->
    (
# 93 "lib/parse/nd_parser.mly"
                                      ( Ast.Minus (e1, e2) )
# 622 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_22 =
  fun e1 e2 ->
    (
# 94 "lib/parse/nd_parser.mly"
                                      ( Ast.Mult  (e1, e2) )
# 630 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_23 =
  fun e1 e2 ->
    (
# 95 "lib/parse/nd_parser.mly"
                                      ( Ast.Div   (e1, e2) )
# 638 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_24 =
  fun x ->
    (
# 96 "lib/parse/nd_parser.mly"
                               ( Ast.Var(x) )
# 646 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_25 =
  fun () ->
    (
# 97 "lib/parse/nd_parser.mly"
                               ( Ast.Unit )
# 654 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_26 =
  fun e ->
    (
# 98 "lib/parse/nd_parser.mly"
                               ( e )
# 662 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_27 =
  fun args f ->
    (
# 99 "lib/parse/nd_parser.mly"
                               ( Ast.Call(f, args) )
# 670 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_28 =
  fun e1 e2 ->
    (
# 100 "lib/parse/nd_parser.mly"
                               ( Ast.Pair(e1, e2) )
# 678 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_29 =
  fun e k ->
    (
# 101 "lib/parse/nd_parser.mly"
                               ( Ast.Inj(k, e) )
# 686 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_30 =
  fun branches e ->
    (
# 104 "lib/parse/nd_parser.mly"
                               ( Ast.MatchWith(e, branches) )
# 694 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_31 =
  fun e x ->
    (
# 105 "lib/parse/nd_parser.mly"
                                        ( Ast.Fun(x, e) )
# 702 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_32 =
  fun fields ->
    (
# 106 "lib/parse/nd_parser.mly"
                                  ( Ast.Record(fields) )
# 710 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_33 =
  fun e ->
    (
# 107 "lib/parse/nd_parser.mly"
                               ( Ast.Shift(e) )
# 718 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_34 =
  fun e ->
    (
# 108 "lib/parse/nd_parser.mly"
                               ( Ast.Susp(e) )
# 726 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_35 =
  fun n ->
    (
# 109 "lib/parse/nd_parser.mly"
             ( Ast.Int n  )
# 734 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_36 =
  fun e l ->
    (
# 142 "lib/parse/nd_parser.mly"
                                         ( (l, e) )
# 742 "lib/parse/nd_parser.ml"
     : (string * Ast.exp))

let _menhir_action_37 =
  fun field fields ->
    (
# 137 "lib/parse/nd_parser.mly"
    ( field::fields )
# 750 "lib/parse/nd_parser.ml"
     : ((string * Ast.exp) list))

let _menhir_action_38 =
  fun () ->
    (
# 139 "lib/parse/nd_parser.mly"
    ( [] )
# 758 "lib/parse/nd_parser.ml"
     : ((string * Ast.exp) list))

let _menhir_action_39 =
  fun m ->
    (
# 187 "lib/parse/nd_parser.mly"
               ( Ast.string2mode m )
# 766 "lib/parse/nd_parser.ml"
     : (Ast.mode))

let _menhir_action_40 =
  fun m ->
    (
# 183 "lib/parse/nd_parser.mly"
              ( [m] )
# 774 "lib/parse/nd_parser.ml"
     : (Ast.mode list))

let _menhir_action_41 =
  fun m ms ->
    (
# 184 "lib/parse/nd_parser.mly"
                          ( m::ms )
# 782 "lib/parse/nd_parser.ml"
     : (Ast.mode list))

let _menhir_action_42 =
  fun n ->
    (
# 72 "lib/parse/nd_parser.mly"
                          ( Ast.Int n )
# 790 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_43 =
  fun x ->
    (
# 73 "lib/parse/nd_parser.mly"
                            ( Ast.Var x )
# 798 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_44 =
  fun e ->
    (
# 74 "lib/parse/nd_parser.mly"
                            ( e )
# 806 "lib/parse/nd_parser.ml"
     : (Ast.exp))

let _menhir_action_45 =
  fun tau x ->
    (
# 153 "lib/parse/nd_parser.mly"
                                                ( (x, tau) )
# 814 "lib/parse/nd_parser.ml"
     : (Ast.parm))

let _menhir_action_46 =
  fun parm parms ->
    (
# 156 "lib/parse/nd_parser.mly"
                                ( parm::parms )
# 822 "lib/parse/nd_parser.ml"
     : (Ast.parm list))

let _menhir_action_47 =
  fun () ->
    (
# 157 "lib/parse/nd_parser.mly"
                                ( [] )
# 830 "lib/parse/nd_parser.ml"
     : (Ast.parm list))

let _menhir_action_48 =
  fun p1 p2 ->
    (
# 145 "lib/parse/nd_parser.mly"
                                ( Ast.PairPat(p1, p2) )
# 838 "lib/parse/nd_parser.ml"
     : (Ast.pat))

let _menhir_action_49 =
  fun () ->
    (
# 146 "lib/parse/nd_parser.mly"
                                ( Ast.UnitPat )
# 846 "lib/parse/nd_parser.ml"
     : (Ast.pat))

let _menhir_action_50 =
  fun k p ->
    (
# 147 "lib/parse/nd_parser.mly"
                                ( Ast.InjPat(k, p) )
# 854 "lib/parse/nd_parser.ml"
     : (Ast.pat))

let _menhir_action_51 =
  fun x ->
    (
# 148 "lib/parse/nd_parser.mly"
                                ( Ast.VarPat(x) )
# 862 "lib/parse/nd_parser.ml"
     : (Ast.pat))

let _menhir_action_52 =
  fun p ->
    (
# 149 "lib/parse/nd_parser.mly"
                                ( p )
# 870 "lib/parse/nd_parser.ml"
     : (Ast.pat))

let _menhir_action_53 =
  fun p ->
    (
# 150 "lib/parse/nd_parser.mly"
                                ( Ast.ShiftPat(p) )
# 878 "lib/parse/nd_parser.ml"
     : (Ast.pat))

let _menhir_action_54 =
  fun d defns ->
    (
# 77 "lib/parse/nd_parser.mly"
                            ( d::defns )
# 886 "lib/parse/nd_parser.ml"
     : (Ast.env))

let _menhir_action_55 =
  fun () ->
    (
# 78 "lib/parse/nd_parser.mly"
                            ( [] )
# 894 "lib/parse/nd_parser.ml"
     : (Ast.env))

let _menhir_action_56 =
  fun alts ->
    (
# 160 "lib/parse/nd_parser.mly"
                                       ( Ast.Plus(alts) )
# 902 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_57 =
  fun alts ->
    (
# 161 "lib/parse/nd_parser.mly"
                                            ( Ast.With(alts) )
# 910 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_58 =
  fun tau1 tau2 ->
    (
# 162 "lib/parse/nd_parser.mly"
                                ( Ast.Times(tau1, tau2) )
# 918 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_59 =
  fun tau1 tau2 ->
    (
# 163 "lib/parse/nd_parser.mly"
                                 ( Ast.Arrow(tau1, tau2) )
# 926 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_60 =
  fun n ->
    (
# 165 "lib/parse/nd_parser.mly"
    ( if n = 1 then Ast.One
      else ( Error_msg.error errors None "only '1' is a type" ; raise Error_msg.Error ) )
# 935 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_61 =
  fun a ms ->
    (
# 167 "lib/parse/nd_parser.mly"
                                               ( Ast.TpInst(a, ms) )
# 943 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_62 =
  fun a ->
    (
# 168 "lib/parse/nd_parser.mly"
               ( Ast.TpInst(a, []) )
# 951 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_63 =
  fun tau ->
    (
# 169 "lib/parse/nd_parser.mly"
                              ( Ast.Down(tau) )
# 959 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_64 =
  fun tau ->
    (
# 170 "lib/parse/nd_parser.mly"
                       ( Ast.Up(tau) )
# 967 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_65 =
  fun m tau ->
    (
# 171 "lib/parse/nd_parser.mly"
                                            ( Ast.Flat(m, tau) )
# 975 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_66 =
  fun tau ->
    (
# 172 "lib/parse/nd_parser.mly"
                              ( tau )
# 983 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_action_67 =
  fun () ->
    (
# 173 "lib/parse/nd_parser.mly"
           ( Ast.Int32 )
# 991 "lib/parse/nd_parser.ml"
     : (Ast.tp))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | AMPERSAND ->
        "AMPERSAND"
    | ARROW ->
        "ARROW"
    | BAR ->
        "BAR"
    | CALL ->
        "CALL"
    | CLOS ->
        "CLOS"
    | COLON ->
        "COLON"
    | COMMA ->
        "COMMA"
    | CUT ->
        "CUT"
    | DEFN ->
        "DEFN"
    | DOT ->
        "DOT"
    | END ->
        "END"
    | EOF ->
        "EOF"
    | EQUAL ->
        "EQUAL"
    | FAIL ->
        "FAIL"
    | FORCE ->
        "FORCE"
    | FUN ->
        "FUN"
    | ID ->
        "ID"
    | IDENT _ ->
        "IDENT"
    | INST ->
        "INST"
    | INT32 ->
        "INT32"
    | LABEL _ ->
        "LABEL"
    | LANGLE ->
        "LANGLE"
    | LBRACE ->
        "LBRACE"
    | LBRACKET ->
        "LBRACKET"
    | LPAREN ->
        "LPAREN"
    | MATCH ->
        "MATCH"
    | MINUS ->
        "MINUS"
    | NAT _ ->
        "NAT"
    | PLUS ->
        "PLUS"
    | PROC ->
        "PROC"
    | RANGLE ->
        "RANGLE"
    | RBRACE ->
        "RBRACE"
    | RBRACKET ->
        "RBRACKET"
    | READ ->
        "READ"
    | RECORD ->
        "RECORD"
    | REUSE ->
        "REUSE"
    | RIGHTARROW ->
        "RIGHTARROW"
    | RPAREN ->
        "RPAREN"
    | SLASH ->
        "SLASH"
    | STAR ->
        "STAR"
    | SUSP ->
        "SUSP"
    | TYPE ->
        "TYPE"
    | UPARROW ->
        "UPARROW"
    | VALUE ->
        "VALUE"
    | WITH ->
        "WITH"
    | WRITE ->
        "WRITE"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_149 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_prog =
    fun _menhir_stack _v ->
      MenhirBox_prog _v
  
  let rec _menhir_goto_prog : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState150 ->
          _menhir_run_151 _menhir_stack _v
      | MenhirState000 ->
          _menhir_run_149 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_151 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_defn -> _ -> _menhir_box_prog =
    fun _menhir_stack _v ->
      let MenhirCell1_defn (_menhir_stack, _menhir_s, d) = _menhir_stack in
      let defns = _v in
      let _v = _menhir_action_54 d defns in
      _menhir_goto_prog _menhir_stack _v _menhir_s
  
  let _menhir_run_059 : type  ttv_stack. ttv_stack -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_s ->
      let _v = _menhir_action_55 () in
      _menhir_goto_prog _menhir_stack _v _menhir_s
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_TYPE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LBRACKET ->
              let _menhir_s = MenhirState003 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | IDENT _v ->
                  _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_004 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let m = _v in
      let _v = _menhir_action_39 m in
      _menhir_goto_mode _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_mode : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState003 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState024 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState021 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState015 ->
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_024 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | IDENT _v_0 ->
          let _menhir_stack = MenhirCell1_mode (_menhir_stack, _menhir_s, _v) in
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState024
      | RBRACKET ->
          let m = _v in
          let _v = _menhir_action_40 m in
          _menhir_goto_modes _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_modes : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState024 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState021 ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState003 ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_025 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_mode -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_mode (_menhir_stack, _menhir_s, m) = _menhir_stack in
      let ms = _v in
      let _v = _menhir_action_41 m ms in
      _menhir_goto_modes _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_022 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_IDENT -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_IDENT (_menhir_stack, _menhir_s, a) = _menhir_stack in
      let ms = _v in
      let _v = _menhir_action_61 a ms in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_tp : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState063 ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState051 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState007 ->
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState008 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState012 ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState014 ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState017 ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState037 ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState034 ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState018 ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_064 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_DEFN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_parms as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | STAR ->
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQUAL ->
          let _menhir_s = MenhirState065 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SUSP ->
              _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RECORD ->
              _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NAT _v ->
              _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LANGLE ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LABEL _v ->
              _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IDENT _v ->
              _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | ARROW ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_034 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_tp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState034 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_008 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_UPARROW (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState008 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_009 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_PLUS (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACE ->
          let _menhir_s = MenhirState010 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LABEL _v ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_011 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_LABEL (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState012 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UPARROW ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PLUS ->
              _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LANGLE ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT32 ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | AMPERSAND ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_013 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let n = _v in
      let _v = _menhir_action_60 n in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_014 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState014 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_015 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LBRACKET (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState015 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_018 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LANGLE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState018 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_019 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_67 () in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_020 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACKET ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState021 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | ARROW | COMMA | DEFN | EOF | EQUAL | INST | RANGLE | RBRACE | RPAREN | STAR | TYPE ->
          let a = _v in
          let _v = _menhir_action_62 a in
          _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_026 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_AMPERSAND (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACE ->
          let _menhir_s = MenhirState027 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LABEL _v ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_066 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_SUSP (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState066 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_067 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_RECORD (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | BAR ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState067
      | END ->
          let _v = _menhir_action_38 () in
          _menhir_run_143 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_068 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_BAR (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LABEL _v ->
          let _menhir_stack = MenhirCell0_LABEL (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | RIGHTARROW ->
              let _menhir_s = MenhirState070 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | SUSP ->
                  _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | RECORD ->
                  _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NAT _v ->
                  _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | MATCH ->
                  _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LPAREN ->
                  _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LANGLE ->
                  _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LABEL _v ->
                  _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | IDENT _v ->
                  _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FUN ->
                  _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_071 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | BAR | COMMA | DEFN | END | EOF | INST | RANGLE | RPAREN | TYPE | WITH ->
          let n = _v in
          let _v = _menhir_action_35 n in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | EQUAL | MINUS | PLUS | SLASH | STAR ->
          let n = _v in
          let _v = _menhir_action_42 n in
          _menhir_goto_numexp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_exp : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState065 ->
          _menhir_run_148 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState066 ->
          _menhir_run_147 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState070 ->
          _menhir_run_142 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState136 ->
          _menhir_run_137 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_120 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState073 ->
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState076 ->
          _menhir_run_115 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState105 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState090 ->
          _menhir_run_091 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState087 ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_148 : type  ttv_stack. ((((ttv_stack, _menhir_box_prog) _menhir_cell1_DEFN _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_parms, _menhir_box_prog) _menhir_cell1_tp as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DEFN | EOF | INST | TYPE ->
          let MenhirCell1_tp (_menhir_stack, _, tau) = _menhir_stack in
          let MenhirCell1_parms (_menhir_stack, _, parms) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, f) = _menhir_stack in
          let MenhirCell1_DEFN (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_17 e f parms tau in
          _menhir_goto_defn _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_090 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState090 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_072 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_MATCH (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState072 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_073 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_25 () in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | RECORD ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | NAT _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState073
      | MATCH ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | LPAREN ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | LANGLE ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | LABEL _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState073
      | IDENT _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState073
      | FUN ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState073
      | _ ->
          _eRR ()
  
  and _menhir_run_075 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LANGLE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState075 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_076 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_LABEL (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState076 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_077 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NAT _v_0 ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState077
      | LPAREN ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState077
      | LANGLE ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState077
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState077
      | DOT ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState077
      | BAR | COMMA | DEFN | END | EOF | INST | RANGLE | RPAREN | TYPE | WITH ->
          let x = _v in
          let _v = _menhir_action_24 x in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | EQUAL | MINUS | PLUS | SLASH | STAR ->
          let x = _v in
          let _v = _menhir_action_43 x in
          _menhir_goto_numexp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_078 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let n = _v in
      let _v = _menhir_action_10 n in
      _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_atom : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | NAT _v_0 ->
          let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState113
      | LPAREN ->
          let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState113
      | LANGLE ->
          let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState113
      | IDENT _v_1 ->
          let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState113
      | DOT ->
          let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
          _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState113
      | BAR | COMMA | DEFN | END | EOF | INST | RANGLE | RPAREN | TYPE | WITH ->
          let atom = _v in
          let _v = _menhir_action_11 atom in
          _menhir_goto_atoms _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_079 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState079
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | RECORD ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState079
      | NAT _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState079
      | MATCH ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState079
      | LPAREN ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState079
      | LANGLE ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState079
      | LABEL _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState079
      | IDENT _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState079
      | FUN ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState079
      | _ ->
          _eRR ()
  
  and _menhir_run_081 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FUN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | RIGHTARROW ->
              let _menhir_s = MenhirState083 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | SUSP ->
                  _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | RECORD ->
                  _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NAT _v ->
                  _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | MATCH ->
                  _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LPAREN ->
                  _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LANGLE ->
                  _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LABEL _v ->
                  _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | IDENT _v ->
                  _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FUN ->
                  _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_105 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LANGLE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState105 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_108 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = _v in
      let _v = _menhir_action_04 x in
      _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_109 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LABEL _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let k = _v in
          let _v = _menhir_action_07 k in
          _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | FORCE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_09 () in
          _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_atoms : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState113 ->
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState077 ->
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_114 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_atom -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_atom (_menhir_stack, _menhir_s, atom) = _menhir_stack in
      let atoms = _v in
      let _v = _menhir_action_12 atom atoms in
      _menhir_goto_atoms _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_112 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_IDENT -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_IDENT (_menhir_stack, _menhir_s, f) = _menhir_stack in
      let args = _v in
      let _v = _menhir_action_27 args f in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_numexp : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState100 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState098 ->
          _menhir_run_099 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState096 ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState094 ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState085 ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState065 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState066 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState070 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState136 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState073 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState076 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState105 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState090 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState087 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_101 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_numexp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_numexp (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_19 e1 e2 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_099 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_numexp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_numexp (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_21 e1 e2 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_097 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_numexp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_numexp (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_20 e1 e2 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_095 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_numexp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_numexp (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_23 e1 e2 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_093 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_numexp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_numexp (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_22 e1 e2 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_084 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_numexp (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_s = MenhirState085 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NAT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | SLASH ->
          let _menhir_s = MenhirState094 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NAT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | PLUS ->
          let _menhir_s = MenhirState096 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NAT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | MINUS ->
          let _menhir_s = MenhirState098 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NAT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | EQUAL ->
          let _menhir_s = MenhirState100 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NAT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_086 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let n = _v in
      let _v = _menhir_action_42 n in
      _menhir_goto_numexp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_087 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState087 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SUSP ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECORD ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MATCH ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_092 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = _v in
      let _v = _menhir_action_43 x in
      _menhir_goto_numexp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_defn : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_defn (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TYPE ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState150
      | INST ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState150
      | EOF ->
          _menhir_run_059 _menhir_stack MenhirState150
      | DEFN ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState150
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_047 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_INST (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LPAREN ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
          | COLON ->
              let _v_0 = _menhir_action_47 () in
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState048
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_049 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _menhir_s = MenhirState051 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | UPARROW ->
                  _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | PLUS ->
                  _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | NAT _v ->
                  _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | LPAREN ->
                  _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LBRACKET ->
                  _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LANGLE ->
                  _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | INT32 ->
                  _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | AMPERSAND ->
                  _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_054 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_INST _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_parms (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState055 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_060 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_DEFN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LPAREN ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
          | COLON ->
              let _v_0 = _menhir_action_47 () in
              _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState061
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_062 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_DEFN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_parms (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState063 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_147 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_SUSP -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_SUSP (_menhir_stack, _menhir_s) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_34 e in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_142 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_BAR _menhir_cell0_LABEL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | END ->
          let MenhirCell0_LABEL (_menhir_stack, l) = _menhir_stack in
          let MenhirCell1_BAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_36 e l in
          let _menhir_stack = MenhirCell1_field (_menhir_stack, _menhir_s, _v) in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState145
          | END ->
              let _v_0 = _menhir_action_38 () in
              _menhir_run_146 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
          | _ ->
              _menhir_fail ())
      | _ ->
          _eRR ()
  
  and _menhir_run_146 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_field -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_field (_menhir_stack, _menhir_s, field) = _menhir_stack in
      let fields = _v in
      let _v = _menhir_action_37 field fields in
      _menhir_goto_fields _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_fields : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState145 ->
          _menhir_run_146 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState067 ->
          _menhir_run_143 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_143 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_RECORD -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_RECORD (_menhir_stack, _menhir_s) = _menhir_stack in
      let fields = _v in
      let _v = _menhir_action_32 fields in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_137 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_BAR, _menhir_box_prog) _menhir_cell1_pat as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | END ->
          let MenhirCell1_pat (_menhir_stack, _, p) = _menhir_stack in
          let MenhirCell1_BAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_13 e p in
          let _menhir_stack = MenhirCell1_branch (_menhir_stack, _menhir_s, _v) in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState140
          | END ->
              let _v_0 = _menhir_action_15 () in
              _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
          | _ ->
              _menhir_fail ())
      | _ ->
          _eRR ()
  
  and _menhir_run_122 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_BAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState122 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAREN ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_123 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_49 () in
          _menhir_goto_pat _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | LPAREN ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState123
      | LANGLE ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState123
      | LABEL _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState123
      | IDENT _v ->
          let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState123
      | _ ->
          _eRR ()
  
  and _menhir_goto_pat : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState122 ->
          _menhir_run_135 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState123 ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState131 ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState125 ->
          _menhir_run_129 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState126 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_135 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_BAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_pat (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | RIGHTARROW ->
          let _menhir_s = MenhirState136 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SUSP ->
              _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RECORD ->
              _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NAT _v ->
              _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | MATCH ->
              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LANGLE ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LABEL _v ->
              _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IDENT _v ->
              _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | COMMA ->
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_131 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_pat -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState131 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAREN ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_125 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LANGLE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState125 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAREN ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_126 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_LABEL (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState126 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAREN ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL _v ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_127 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = _v in
      let _v = _menhir_action_51 x in
      _menhir_goto_pat _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_133 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let p = _v in
          let _v = _menhir_action_52 p in
          _menhir_goto_pat _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_pat (_menhir_stack, _menhir_s, _v) in
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_132 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_pat as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_pat (_menhir_stack, _menhir_s, _v) in
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RANGLE | RIGHTARROW | RPAREN ->
          let MenhirCell1_pat (_menhir_stack, _menhir_s, p1) = _menhir_stack in
          let p2 = _v in
          let _v = _menhir_action_48 p1 p2 in
          _menhir_goto_pat _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_129 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LANGLE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RANGLE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LANGLE (_menhir_stack, _menhir_s) = _menhir_stack in
          let p = _v in
          let _v = _menhir_action_53 p in
          _menhir_goto_pat _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_pat (_menhir_stack, _menhir_s, _v) in
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_128 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_LABEL -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_LABEL (_menhir_stack, _menhir_s, k) = _menhir_stack in
      let p = _v in
      let _v = _menhir_action_50 k p in
      _menhir_goto_pat _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_141 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_branch -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_branch (_menhir_stack, _menhir_s, branch) = _menhir_stack in
      let branches = _v in
      let _v = _menhir_action_14 branch branches in
      _menhir_goto_branches _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_branches : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState140 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState121 ->
          _menhir_run_138 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_138 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_MATCH, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_exp (_menhir_stack, _, e) = _menhir_stack in
      let MenhirCell1_MATCH (_menhir_stack, _menhir_s) = _menhir_stack in
      let branches = _v in
      let _v = _menhir_action_30 branches e in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_120 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_MATCH as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | WITH ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
          | END ->
              let _v_0 = _menhir_action_15 () in
              _menhir_run_138 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
          | _ ->
              _eRR ())
      | COMMA ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_118 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR | COMMA | DEFN | END | EOF | INST | RANGLE | RPAREN | TYPE | WITH ->
              let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
              let e = _v in
              let _v = _menhir_action_26 e in
              _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | EQUAL | MINUS | PLUS | SLASH | STAR ->
              let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
              let e = _v in
              let _v = _menhir_action_44 e in
              _menhir_goto_numexp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_116 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LANGLE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RANGLE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LANGLE (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_33 e in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_115 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_LABEL -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_LABEL (_menhir_stack, _menhir_s, k) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_29 e k in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_106 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LANGLE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RANGLE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LANGLE (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_08 e in
          _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_103 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_06 e in
          _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_102 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_FUN _menhir_cell0_IDENT -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell0_IDENT (_menhir_stack, x) = _menhir_stack in
      let MenhirCell1_FUN (_menhir_stack, _menhir_s) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_31 e x in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_091 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_exp as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | DEFN | END | EOF | INST | RANGLE | RPAREN | TYPE | WITH ->
          let MenhirCell1_exp (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_28 e1 e2 in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_088 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_44 e in
          _menhir_goto_numexp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_037 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_tp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState037 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UPARROW ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PLUS ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LANGLE ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT32 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMPERSAND ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_056 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_INST _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_parms as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DEFN | EOF | INST | TYPE ->
          let MenhirCell1_parms (_menhir_stack, _, parms) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, f) = _menhir_stack in
          let MenhirCell1_INST (_menhir_stack, _menhir_s) = _menhir_stack in
          let tau = _v in
          let _v = _menhir_action_18 f parms tau in
          _menhir_goto_defn _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_052 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, x) = _menhir_stack in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let tau = _v in
          let _v = _menhir_action_45 tau x in
          let _menhir_stack = MenhirCell1_parm (_menhir_stack, _menhir_s, _v) in
          (match (_tok : MenhirBasics.token) with
          | LPAREN ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState057
          | COLON ->
              let _v_0 = _menhir_action_47 () in
              _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
          | _ ->
              _eRR ())
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_058 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_parm -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_parm (_menhir_stack, _menhir_s, parm) = _menhir_stack in
      let parms = _v in
      let _v = _menhir_action_46 parm parms in
      _menhir_goto_parms _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_parms : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState061 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState057 ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState048 ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_046 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_TYPE _menhir_cell0_IDENT, _menhir_box_prog) _menhir_cell1_modes as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DEFN | EOF | INST | TYPE ->
          let MenhirCell1_modes (_menhir_stack, _, ms) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, a) = _menhir_stack in
          let MenhirCell1_TYPE (_menhir_stack, _menhir_s) = _menhir_stack in
          let tau = _v in
          let _v = _menhir_action_16 a ms tau in
          _menhir_goto_defn _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_045 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_UPARROW -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_UPARROW (_menhir_stack, _menhir_s) = _menhir_stack in
      let tau = _v in
      let _v = _menhir_action_64 tau in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_042 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LABEL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | RBRACE ->
          let MenhirCell1_LABEL (_menhir_stack, _menhir_s, l) = _menhir_stack in
          let tau = _v in
          let _v = _menhir_action_01 l tau in
          (match (_tok : MenhirBasics.token) with
          | COMMA ->
              let _menhir_stack = MenhirCell1_alt (_menhir_stack, _menhir_s, _v) in
              let _menhir_s = MenhirState031 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LABEL _v ->
                  _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | RBRACE ->
              let alt = _v in
              let _v = _menhir_action_02 alt in
              _menhir_goto_alts _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _menhir_fail ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_alts : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState010 ->
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState031 ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState027 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_043 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_PLUS -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_PLUS (_menhir_stack, _menhir_s) = _menhir_stack in
      let alts = _v in
      let _v = _menhir_action_56 alts in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_032 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_alt -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_alt (_menhir_stack, _menhir_s, alt) = _menhir_stack in
      let alts = _v in
      let _v = _menhir_action_03 alt alts in
      _menhir_goto_alts _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_028 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_AMPERSAND -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_AMPERSAND (_menhir_stack, _menhir_s) = _menhir_stack in
      let alts = _v in
      let _v = _menhir_action_57 alts in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_040 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let tau = _v in
          let _v = _menhir_action_66 tau in
          _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_039 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LBRACKET, _menhir_box_prog) _menhir_cell1_mode -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_mode (_menhir_stack, _, m) = _menhir_stack in
      let MenhirCell1_LBRACKET (_menhir_stack, _menhir_s) = _menhir_stack in
      let tau = _v in
      let _v = _menhir_action_65 m tau in
      _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_038 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_tp as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | DEFN | EOF | EQUAL | INST | RANGLE | RBRACE | RPAREN | TYPE ->
          let MenhirCell1_tp (_menhir_stack, _menhir_s, tau1) = _menhir_stack in
          let tau2 = _v in
          let _v = _menhir_action_59 tau1 tau2 in
          _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_035 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_tp as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARROW | COMMA | DEFN | EOF | EQUAL | INST | RANGLE | RBRACE | RPAREN | TYPE ->
          let MenhirCell1_tp (_menhir_stack, _menhir_s, tau1) = _menhir_stack in
          let tau2 = _v in
          let _v = _menhir_action_58 tau1 tau2 in
          _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_033 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LANGLE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RANGLE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LANGLE (_menhir_stack, _menhir_s) = _menhir_stack in
          let tau = _v in
          let _v = _menhir_action_63 tau in
          _menhir_goto_tp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | ARROW ->
          let _menhir_stack = MenhirCell1_tp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_005 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_TYPE _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_modes (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | EQUAL ->
          let _menhir_s = MenhirState007 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UPARROW ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PLUS ->
              _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LANGLE ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT32 ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | AMPERSAND ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_016 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LBRACKET as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_mode (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | RBRACKET ->
          let _menhir_s = MenhirState017 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UPARROW ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PLUS ->
              _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LANGLE ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT32 ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | AMPERSAND ->
              _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState000 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TYPE ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INST ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EOF ->
          _menhir_run_059 _menhir_stack _menhir_s
      | DEFN ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let prog =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_prog v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

# 189 "lib/parse/nd_parser.mly"
  

# 3097 "lib/parse/nd_parser.ml"
