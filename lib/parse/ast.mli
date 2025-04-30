(** Abstract Syntax Trees for ND *)

(* TYPES *)

    type label = string
    type tpname = string
    type modename = string

    type mode = ModeConst of modename
              | ModeVar of modename

    val string2mode : modename -> mode

    type tp = Times of tp * tp
            | One
            | Plus of (label * tp) list
            | Arrow of tp * tp           (* Lab 3 *)
            | With of (label * tp) list  (* Lab 3 *)
            | Down of tp                 (* Lab 4 *)
            | Up of tp                   (* Lab 4 *)
            | Flat of mode * tp          (* Lab 4 *)
            | TpInst of tpname * mode list (* Lab 4 *)
            | Int32
         (* | TpName of tpname *)        (* replace for Lab 4 *)

    type varname = string
    type expname = string

    type pat = PairPat of pat * pat
             | UnitPat
             | InjPat of label * pat
             | ShiftPat of pat           (* Lab 4 *)
             | VarPat of varname

    type exp = Var of varname
             | Pair of exp * exp
             | Unit
             | Inj of label * exp
             | MatchWith of exp * (pat * exp) list
             | Call of varname * atom list
             | Fun of varname * exp         (* Lab 3 *)
             | Record of (label * exp) list (* Lab 3 *)
             | Shift of exp                 (* Lab 4 *)
             | Susp of exp                  (* Lab 4 *)
             | Int of int
             | Add   of exp * exp
             | Minus of exp * exp
             | Mult  of exp * exp
             | Div   of exp * exp
             | Eq of exp * exp
    and atom = Exp of exp    
             | Dot of label (* Lab 3, to support projection ".k" *)
             | Force        (* Lab 4, to support ".force" *)

    type parm = varname * tp

    type defn = TypeDefn of tpname * mode list * tp
              | ExpDefn of expname * parm list * tp * exp
              | InstDefn of expname * parm list * tp

    type env = defn list

    (** Print as source, with redundant parentheses *)
    (* these print redundant '(...)' and '{...}' *)
    
    module Print : sig
      val pp_mode : mode -> string
      val pp_tp : tp -> string
      val pp_pat : pat -> string
      val pp_exp : int -> exp -> string 
      val pp_defn : defn -> string
      val pp_env : env -> string
    end

