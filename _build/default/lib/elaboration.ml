type label = [%import: Ast.label]
type tpname = [%import: Ast.tpname]
type modename = [%import: Ast.modename]
type mode = [%import: Ast.mode]
type tp = [%import: Ast.tp]
type varname = [%import: Ast.varname]
type expname = [%import: Ast.expname]
type pat = [%import: Ast.pat]
type exp = [%import: Ast.exp]
and atom = [%import: Ast.atom]
type parm = [%import: Ast.parm]
type defn = [%import: Ast.defn]
type env =  [%import: Ast.env]

exception ElaborationError of string

(*
 * going to elaborate on modes
 *)

type tpdefn = tpname * (mode list) * tp
              
let tp_defns : env ->  (tpdefn list) =
  List.fold_left
    (fun ac -> fun d ->
       match d with
       | TypeDefn (tn, ml, t) -> (tn, ml, t)::ac
       | _ -> ac) []

let rec contains_type (types : tpdefn list) (t : tpname) : (mode list)*tp =
  match types with
  | (tn, ml, tp)::types -> if t = tn then (ml, tp) else (contains_type types t)
  | [] -> raise (ElaborationError ("Could not find type " ^ t))


let mode_equality (m1 : mode) (m2 : mode) : bool = (Ast.Print.pp_mode m1) = (Ast.Print.pp_mode m2)

(* m1 <: m2 *)
let lattice (m1 : string) (m2 : string) : bool =
  match (m1, m2) with
  | ("U", "U") -> true
  | ("U", _) -> false
  | ("L", "L") -> true
  | (_, "L") -> false
  | ("A", "S") -> false
  | ("S", "A") -> false
  | _ -> true

let is_explicit (t : tp) : bool =
  match t with
  | Flat _ -> true
  | TpInst (_, ml) -> (List.length ml) = 0
  | _ -> false


let rec what_mode_tp (types : tpdefn list) (t : tp) : mode option =
  match t with
  | Times (t1, t2) ->
    (match (what_mode_tp types t1, what_mode_tp types t2) with
    | (None, None) -> None
    | (Some m, None) -> Some m
    | (None, Some m) -> Some m
    | (Some m1, Some m2) ->
      if mode_equality m1 m2
      then Some m1
      else raise (ElaborationError ("Inference on product type: Mode " ^ (Ast.Print.pp_mode m1) ^ " is not equal to mode " ^ (Ast.Print.pp_mode m2))))
  | One -> None
  | Plus ltl ->
    List.fold_left
      (fun acc -> fun (_, t) ->
         let mo = what_mode_tp types t in
         match (mo, acc) with
         | (None, None) -> None
         | (None, Some m) -> Some m
         | (Some m, None) -> Some m
         | (Some m1, Some m2) ->
           if mode_equality m1 m2
           then Some m1
           else raise (ElaborationError ("Inference on sum type: Mode " ^ (Ast.Print.pp_mode m1) ^ " is not equal to mode " ^ (Ast.Print.pp_mode m2)))) None ltl
  | Arrow (t1, t2) -> 
    (match (what_mode_tp types t1, what_mode_tp types t2) with
     | (None, None) -> None
     | (Some m, None) -> Some m
     | (None, Some m) -> Some m
     | (Some m1, Some m2) ->
       if mode_equality m1 m2
       then Some m1
       else raise (ElaborationError ("Inference on arrow type: Mode " ^ (Ast.Print.pp_mode m1) ^ " is not equal to mode " ^ (Ast.Print.pp_mode m2))))
  | With ltl ->
    List.fold_left
      (fun acc -> fun (_, t) ->
         let mo = what_mode_tp types t in
         match (mo, acc) with
         | (None, None) -> None
         | (None, Some m) -> Some m
         | (Some m, None) -> Some m
         | (Some m1, Some m2) ->
           if mode_equality m1 m2
           then Some m1
           else raise (ElaborationError ("Inference on record type: Mode " ^ (Ast.Print.pp_mode m1) ^ " is not equal to mode " ^ (Ast.Print.pp_mode m2)))) None ltl
  | Down t -> None
  | Up t -> None
  | Flat (m, t) ->
    (match what_mode_tp types t with
     | None -> Some m
     | Some m' ->
       if mode_equality m m'
       then Some m
       else raise (ElaborationError ("Inference on Flat type: Mode " ^ (Ast.Print.pp_mode m) ^ " is not equal to mode " ^ (Ast.Print.pp_mode m'))))
  | TpInst (tn, ml) ->
    if (List.length ml) = 0 then None else Some (List.nth ml 0)
  | Int32 -> None

let rec elaborate_tp (types : tpdefn list) (t : tp) (default : mode) (defn_mode : bool) : tp =
  let mode = (match what_mode_tp types t with | None -> default | Some m -> m) in
  match t with
  | Times (t1, t2) -> Flat (mode, Times (elaborate_tp types t1 mode defn_mode, elaborate_tp types t2 mode defn_mode))
  | One -> Flat (mode, One)
  | Plus ltl ->
    Flat (mode, Plus (List.map (fun (l, t) -> (l, elaborate_tp types t mode defn_mode)) ltl))
  | Arrow (t1, t2) -> Flat (mode, Arrow (elaborate_tp types t1 mode defn_mode, elaborate_tp types t2 mode defn_mode))
  | With ltl ->
    Flat (mode, With (List.map (fun (l, t) -> (l, elaborate_tp types t mode defn_mode)) ltl))
  | Down t ->
    (match (what_mode_tp types t) with
     | None -> if defn_mode then raise (ElaborationError "Ambiguous inside of downshift") else Flat (mode, Down (elaborate_tp types t (ModeConst "U") defn_mode))
     | Some m ->
       Flat (mode, Down (elaborate_tp types t m defn_mode)))
  | Up t ->
    (match (what_mode_tp types t) with
    | None -> if defn_mode then raise (ElaborationError "Ambiguous inside of upshift") else Flat (mode, Up (elaborate_tp types t (ModeConst "U") defn_mode))
    | Some m ->  Flat (mode, Up (elaborate_tp types t default defn_mode)))
  | Flat (m, t) -> elaborate_tp types t m defn_mode
  | TpInst (tn, ml) ->
    if (List.length ml) = 0
    then TpInst (tn, List.init ((fun (ml, _) -> List.length ml) (contains_type types tn)) (fun _ -> ModeConst "U"))
    else TpInst (tn, ml)
  | Int32 -> Flat (mode, Int32)


let elaborate_defn (types : tpdefn list) (d : defn) =
  match d with
  | TypeDefn (n, ml, t) -> TypeDefn (n, ml, elaborate_tp types t (List.nth ml 0) true)
  | ExpDefn (en, pl, t, e) ->
    ExpDefn (en, List.map (fun (p, t) -> (p, elaborate_tp types t (ModeConst "U") false)) pl, elaborate_tp types t (ModeConst "U") false, e)
  | InstDefn (en, pl, t) ->
    InstDefn (en, List.map (fun (p, t) -> (p, elaborate_tp types t (ModeConst "U") false)) pl, elaborate_tp types t (ModeConst "U") false)

let elaborate_program (e : env) : env =
  let types = tp_defns e in
  List.fold_right
    (fun d -> fun acc -> (elaborate_defn types d)::acc) e []
