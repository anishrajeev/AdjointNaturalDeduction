%{
(** ND Parser *)

    let errors = Error_msg.create ()
%}

%token <int> NAT
%token <string> IDENT
%token <string> LABEL

%token MATCH WITH END
%token FUN RECORD      (* Lab 3 *)
%token TYPE DEFN FAIL
%token INST            (* Lab 4 *)
%token SUSP FORCE      (* Lab 4 *)
%token PROC
%token READ WRITE CUT ID CALL REUSE
%token CLOS            (* Lab 3 Sax *)
%token VALUE
%token INT32

%token COMMA COLON
%token DOT             (* Lab 3 *)
%token LPAREN RPAREN
%token LBRACE RBRACE
%token LBRACKET RBRACKET  (* Lab 4 *)
%token LANGLE RANGLE      (* Lab 4 *)
%token RIGHTARROW EQUAL BAR
%token STAR PLUS
%token AMPERSAND       (* Lab 3 *)
%token ARROW           (* Lab 3 *)
%token UPARROW         (* Lab 4 *)
%token EOF
%token MINUS SLASH

(* precedence & associativity *)
(* types *)
%right ARROW
%right STAR
%right UPARROW RBRACKET (* Lab 4 *)

(* expressions *)
%right COMMA
%right RIGHTARROW
%right EQUAL
%right LABEL SUSP  (* Lab 4 *)

%start prog

(* types *)
%type <Ast.env> prog
%type <Ast.defn> defn
%type <Ast.exp> exp
%type <(Ast.pat * Ast.exp) list> branches
%type <Ast.pat * Ast.exp> branch
%type <Ast.atom> atom
%type <Ast.atom list> atoms
%type <Ast.pat> pat
%type <Ast.varname * Ast.tp> parm
%type <(Ast.varname * Ast.tp) list> parms
%type <Ast.tp> tp
%type <(Ast.label * Ast.tp) list> alts
%type <Ast.label * Ast.tp> alt
%type <Ast.label * Ast.exp> field
%type <(Ast.label * Ast.exp) list> fields
%type <Ast.mode> mode
%type <Ast.mode list> modes
%type <Ast.exp> numexp
%%

numexp :
  | n = NAT               { Ast.Int n }
  | x = IDENT               { Ast.Var x }
  | LPAREN; e = exp; RPAREN { e }

prog :
  | d = defn; defns = prog; { d::defns }
  | EOF;                    { [] }

defn :
  | TYPE; a = IDENT; LBRACKET; ms = modes; RBRACKET; EQUAL; tau = tp;
    { Ast.TypeDefn(a, ms, tau) }

  | DEFN; f = IDENT; parms = parms; COLON; tau = tp; EQUAL; e = exp;
    { Ast.ExpDefn(f, parms, tau, e) }

  | INST; f = IDENT; parms = parms; COLON; tau = tp;
    { Ast.InstDefn(f, parms, tau) }

exp :
  | e1 = numexp; EQUAL; e2 = numexp { Ast.Eq (e1, e2) }
  | e1 = numexp; PLUS  ; e2 = numexp  { Ast.Add   (e1, e2) }  /* NEW */
  | e1 = numexp; MINUS ; e2 = numexp  { Ast.Minus (e1, e2) }  /* NEW */
  | e1 = numexp; STAR  ; e2 = numexp  { Ast.Mult  (e1, e2) }  /* NEW */
  | e1 = numexp; SLASH ; e2 = numexp  { Ast.Div   (e1, e2) }
  | x = IDENT;                 { Ast.Var(x) }
  | LPAREN; RPAREN;            { Ast.Unit }
  | LPAREN; e = exp; RPAREN;   { e }
  | f = IDENT; args = atoms;   { Ast.Call(f, args) }
  | e1 = exp; COMMA; e2 = exp; { Ast.Pair(e1, e2) }
  | k = LABEL; e = exp;        { Ast.Inj(k, e) }
  | MATCH; e = exp; WITH;
    branches = branches;
    END;                       { Ast.MatchWith(e, branches) }
  | FUN; x = IDENT; RIGHTARROW; e = exp { Ast.Fun(x, e) }  (* Lab 3 *)
  | RECORD; fields = fields; END; { Ast.Record(fields) }   (* Lab 3 *)
  | LANGLE; e = exp; RANGLE;   { Ast.Shift(e) }            (* Lab 4 *)
  | SUSP; e = exp;             { Ast.Susp(e) }             (* Lab 4 *)
  | n = NAT; { Ast.Int n  }

atom :
  | x = IDENT;                { Ast.Exp(Ast.Var(x)) }
  | LPAREN; RPAREN;           { Ast.Exp(Ast.Unit) } 
  | LPAREN; e = exp ; RPAREN; { Ast.Exp(e) }
  | DOT; k = LABEL;           { Ast.Dot(k) }               (* Lab 3 *)
  | LANGLE; e = exp ; RANGLE; { Ast.Exp(Ast.Shift(e)) }    (* Lab 4 *)
  | DOT; FORCE;               { Ast.Force }                (* Lab 4 *)
  | n = NAT; { Ast.Exp (Ast.Int n) }

atoms :
  | atom = atom;             { [atom] }
  | atom = atom; atoms = atoms; { atom::atoms }

branches :
  | branch = branch;
    branches = branches;
    { branch::branches }
  | (* empty *)
    { [] }

branch :
  | BAR; p = pat; RIGHTARROW; e = exp; { (p, e) }

fields :
  | field = field ;
    fields = fields;
    { field::fields }
  | (* empty *)
    { [] }

field :
  | BAR; l = LABEL; RIGHTARROW; e = exp; { (l, e) }

pat :
  | p1 = pat; COMMA; p2 = pat;  { Ast.PairPat(p1, p2) }
  | LPAREN; RPAREN;             { Ast.UnitPat }
  | k = LABEL; p = pat;         { Ast.InjPat(k, p) }
  | x = IDENT;                  { Ast.VarPat(x) }
  | LPAREN; p = pat; RPAREN;    { p }
  | LANGLE; p = pat; RANGLE;    { Ast.ShiftPat(p) }  (* Lab 4 *)

parm :
  | LPAREN; x = IDENT; COLON; tau = tp; RPAREN; { (x, tau) }

parms :
  | parm = parm; parms = parms; { parm::parms }
  | (* empty *)                 { [] }

tp :
  | PLUS; LBRACE; alts = alts; RBRACE; { Ast.Plus(alts) }
  | AMPERSAND; LBRACE; alts = alts; RBRACE; { Ast.With(alts) }
  | tau1 = tp; STAR; tau2 = tp; { Ast.Times(tau1, tau2) }
  | tau1 = tp; ARROW; tau2 = tp; { Ast.Arrow(tau1, tau2) }  (* Lab 3 *)
  | n = NAT;
    { if n = 1 then Ast.One
      else ( Error_msg.error errors None "only '1' is a type" ; raise Error_msg.Error ) }
  | a = IDENT; LBRACKET; ms = modes; RBRACKET; { Ast.TpInst(a, ms) }  (* changed for Lab 4 *)
  | a = IDENT; { Ast.TpInst(a, []) }
  | LANGLE; tau = tp; RANGLE; { Ast.Down(tau) }                   (* Lab 4 *)
  | UPARROW; tau = tp; { Ast.Up(tau) }                            (* Lab 4 *)
  | LBRACKET; m = mode; RBRACKET; tau = tp; { Ast.Flat(m, tau) }  (* Lab 4 *)
  | LPAREN; tau = tp; RPAREN; { tau }
  | INT32; { Ast.Int32 }

alts :
  | alt = alt; { [alt] }
  | alt = alt; COMMA; alts = alts; { alt::alts }

alt :
  | l = LABEL; COLON; tau = tp; { (l, tau) }

modes :
  | m = mode; { [m] }
  | m = mode; ms = modes; { m::ms }

mode :
  | m = IDENT; { Ast.string2mode m }

%%
