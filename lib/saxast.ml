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
(* | MarkedCmd of cmd Mark.marked *)

type parm = varname * tp

(* type ext = Mark.ext option *)

type defn = TypeDefn of tpname * mode list * tp (* * ext *)
          | ProcDefn of procname * parm * parm list * cmd (* * ext*)
          | FailDefn of defn (* * ext *)

type env = defn list

let rec indent n s = if n = 0 then s else " " ^ indent (n-1) s
  let parens s = "(" ^ s ^ ")"


module Print = struct

let pp_mode (m : mode) = match m with | ModeConst m -> m | ModeVar m -> m
  
let rec pp_tp (tau : tp) : string = match tau with
  | Times(tau1, tau2) -> parens (pp_tp tau1 ^ " * " ^ pp_tp tau2)
  | One -> "1"
  | Plus(alts) ->
     "+" ^ "{" ^ String.concat ", " (List.map (fun (l, tau_l) -> l ^ " : " ^ pp_tp tau_l) alts) ^ "}"
  | Arrow(tau1, tau2) -> parens (pp_tp tau1 ^ " -> " ^ pp_tp tau2)  (* Lab 3 *)
  | With(alts) ->
     "&" ^ "{" ^ String.concat ", " (List.map (fun (l, tau_l) -> l ^ " : " ^ pp_tp tau_l) alts) ^ "}"
  | Down(tau) -> "<" ^ pp_tp tau ^ ">" (* Lab 4 *)
  | Up(tau) -> "^" ^ parens (pp_tp tau) (* Lab 4 *)
  | Flat(m, tau) -> "[" ^ pp_mode m ^ "]" ^ parens (pp_tp tau) (* Lab 4 *)
  | TpInst(a, []) -> a                                 (* Lab 4 *)
  | TpInst(a, ms) -> a ^ "[" ^ String.concat " " (List.map pp_mode ms) ^ "]" (* Lab 4 *)
  | Int32 -> "int32"

let pp_pat (pat : pat) : string = match pat with
  | PairPat(x,y) -> "(" ^ x ^ ", " ^ y ^ ")"
  | UnitPat -> "()"
  | InjPat(l,x) -> l ^ "(" ^ x ^ ")"
  | ShiftPat x -> "<" ^ x ^ ">"
  | VarPat x -> x

let rec pp_cmd (col : int) (p : cmd) : string =
  match p with
  | Read(x, Small pat) -> "read " ^ x ^ " " ^ pp_pat pat ^ "\n"                           
  | Read(x, Branches branches) -> "read " ^ x ^ " {\n"
                         ^ pp_branches col branches
                         ^ "\n" ^ indent col "}"
  | Write(x, Small pat) -> "write " ^ x ^ " " ^ pp_pat pat
  | Write(x, Branches branches) -> "write " ^ x ^ " {\n"
                         ^ pp_branches col branches
                         ^ "\n" ^ indent col "}"
  | Cut(x, tau, p, q) -> "cut " ^ x ^ " : " ^ pp_tp tau ^ " {\n"
                        ^ indent (col+4) (pp_cmd (col+4) p) ^ "\n"
                        ^ indent col "}\n"
                        ^ indent col (pp_cmd col q)
  | Id(x, y) -> "id " ^ x ^ " " ^ y
  | Call(f, x, ys) -> "call " ^ f ^ " " ^ x ^ " " ^ String.concat " " ys
  | Add (d, x, y) -> "add " ^ d ^ " x " ^ " y"
  | Minus (d, x, y) -> "minus " ^ d ^ " x " ^ " y"
  | Div (d, x, y) -> "div " ^ d ^ " x " ^ " y"
  | Mult (d, x, y) -> "mult " ^ d ^ " x " ^ " y"
  | Eq (d, x, y) -> "eq " ^ d ^ " x " ^ " y"
  | Set (d, i) -> "set " ^ d ^ " " ^ (string_of_int i)

and pp_branches col branches = match branches with
  | [(pat, p)] -> pp_branch col (pat, p)
  | ((pat, p)::branches) -> pp_branch col (pat, p) ^ "\n"
                            ^ pp_branches col branches
  | [] -> raise (Failure "empty branches")

and pp_branch col branch = match branch with
    (pat, p) -> let prefix = "| " ^ pp_pat pat ^ " => " in
                let k = String.length prefix in
                indent col (prefix ^ pp_cmd (col+k) p)

let pp_parm x_tau = match x_tau with
  | (x, tau) -> parens (x ^ " : " ^ pp_tp tau)

let pp_parms y_sigmas = String.concat " " (List.map pp_parm y_sigmas)

let rec pp_defn defn = match defn with
  | TypeDefn(a, ml, tau) ->  "type " ^ a ^ "[" ^ String.concat " " (List.map pp_mode ml) ^ "]" ^ " = " ^ pp_tp tau ^ "\n"
  | ProcDefn(f, x_tau, y_sigmas, body) ->
     "proc " ^ f ^ " " ^ pp_parm x_tau ^ " " ^ pp_parms y_sigmas ^ " =\n"
     ^ indent 4 (pp_cmd 4 body) ^ "\n"
  | FailDefn(defn) -> "fail\n" ^ pp_defn defn

let pp_env defns = String.concat "\n" (List.map pp_defn defns)

end


