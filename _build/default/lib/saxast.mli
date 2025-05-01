(** Abstract Syntax Trees for SAX *)

(* TYPES *)
type label = string
type tpname = string
type modename = string

type mode = ModeConst of modename
          | ModeVar of modename

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

type varname = string
type procname = string

type pat = PairPat of varname * varname
         | UnitPat
         | InjPat of label * varname
         | ShiftPat of varname           (* Lab 4 *)
         | VarPat of varname

type storable = Small of pat
              | Branches of ((pat*cmd) list)
                            
and cmd = Read of varname * storable
        | Write of varname * storable
        | Cut of varname * tp * cmd * cmd
        | Id of varname * varname
        | Call of procname * varname * varname list
        | Add of varname * varname * varname
        | Minus of varname * varname * varname
        | Div of varname * varname * varname
        | Mult of varname * varname * varname
        | Eq of varname * varname * varname
        | Set of varname * int
        | Close of procname * varname * varname list
(* | MarkedCmd of cmd Mark.marked *)

type parm = varname * tp

(* type ext = Mark.ext option *)

type defn = TypeDefn of tpname * mode list * tp (* * ext *)
          | ProcDefn of procname * parm * parm list * cmd
          | ClosDefn of procname * parm * parm list * cmd
          | FailDefn of defn (* * ext *)

type env = defn list

module Print : sig
  val pp_env : env -> string
  val pp_tp : tp -> string
end
