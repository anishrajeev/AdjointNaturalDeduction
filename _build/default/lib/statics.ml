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

exception StaticError of string

type context = parm list

type tpdefn = tpname * (mode list) * tp
type expdefn = expname * context * tp * exp
type instdefn = expname * (tp list) * tp
type patseq = context * (pat list) * exp
              
let tp_defns : env ->  (tpdefn list) =
  List.fold_left
    (fun ac -> fun d ->
       match d with
       | TypeDefn (tn, ml, t) -> (tn, ml, t)::ac
       | _ -> ac) []

let exp_defns : env -> (expdefn list) =
  List.fold_left
    (fun ac -> fun d ->
       match d with
       | ExpDefn (en, pl, t, e) -> (en, pl, t, e)::ac
       | _ -> ac) []

let inst_defns (program : env) : instdefn list =
  List.fold_right
    (fun d -> fun ac ->
       match d with
       | InstDefn (en, pl, t) ->
         let sheared = List.map (fun (_, y) -> y) pl in
         (en, sheared, t)::ac
       | ExpDefn (en, pl, t, _) ->
         let sheared = List.map (fun (_, y) -> y) pl in
         (en, sheared, t)::ac
       | _ -> ac) program []

let rec contains (types : context) (name : string) =
  match types with
  | [] -> raise (StaticError ("The type " ^ name ^ " doesn't exist!"))
  | (n, t)::types -> if n = name then t else contains types name

let rec contains_type (types : tpdefn list) (t : tpname) : (mode list)*tp =
  match types with
  | (tn, ml, tp)::types -> if t = tn then (ml, tp) else (contains_type types t)
  | [] -> raise (StaticError ("Could not find type " ^ t))

let rec contains_mode (modemap : (mode*mode) list) (m : mode) : mode =
  match (m, modemap) with
  | (ModeVar ms, ((ModeVar ma, mc)::modemap)) -> if ms = ma then mc else contains_mode modemap m
  | _ -> raise (StaticError "Mode never existed in the given mode map")

let rec contains_mode_single (ml : mode list) (m : mode) : bool =
  match (m, ml) with
  | (ModeVar mx, (ModeVar mv)::ml) -> if mx = mv then true else contains_mode_single ml m
  | (_, []) -> false
  | (_, ml) -> raise (StaticError "Can't use mode constants")

let rec find_defn (defns : expdefn list) (defn : expname) : expdefn =
  match defns with
  | [] -> raise (StaticError ("The definition " ^ defn ^ " doesn't exist!"))
  | (name, c, t, e)::defns -> if defn = name then (name, c, t, e) else find_defn defns defn

let rec find_type (types : tpdefn list) (t : tpname) : tpdefn =
  match types with
  | [] -> raise (StaticError ("The type " ^ t ^ " doesn't exist!"))
  | (name, ml, ty)::types -> if t = name then (name, ml, ty) else find_type types t
    
let rec generic_contains_bool (l) (v) (f) : bool =
  match l with
  | [] -> false
  | (x::l) -> if f v x then true else (generic_contains_bool l v f)

let forgetful_functor (k) (xtimestp) =
  match xtimestp with | (_, t) -> k t

let type_list : env -> context =
  List.fold_left
    (fun ac -> fun d ->
       match d with
       | TypeDefn (tn, _, t) ->
         if generic_contains_bool ac tn (fun n1 -> fun(n2, _) -> n1 = n2)
         then raise (StaticError ("type " ^ tn ^ " has multiple definitions"))
         else (tn, t)::ac
       | _ -> ac) []

let type_inst_converter (types : tpdefn list) (t : tp) : tp =
  let rec inner (t : tp) (modemap : (mode*mode) list) : tp =
    match t with
    | Times (t1, t2) -> Times ((inner t1 modemap), (inner t2 modemap))
    | One -> One
    | Plus ltl ->
      let ltl = (List.map (fun (lab, t) -> (lab, inner t modemap)) ltl) in
      Plus ltl
    | Arrow (t1, t2) -> Arrow ((inner t1 modemap), (inner t2 modemap))
    | With ltl -> With (List.map (fun (lab, t) -> (lab, inner t modemap)) ltl)
    | Down t -> Down (inner t modemap)
    | Up t -> Up (inner t modemap)
    | Flat (m, t) ->
      (match m with
       | ModeVar _ -> Flat (contains_mode modemap m, inner t modemap)
       | _ -> raise (StaticError "Ultraspecific error #1(more like a static error)"))
    | TpInst (tn, ml) ->
      TpInst (tn, List.map (fun m -> contains_mode modemap m) ml)
    | Int32 -> Int32
  in
  match t with
  | TpInst (tn, ml) ->
    let (mp, tp) = contains_type types tn in
    inner tp (List.combine mp ml)
  | _ -> t

let rec what_mode (t : tp) : mode =
  match t with
  | Times (t1, t2) -> what_mode t1
  | One -> ModeConst "U"
  | Plus ltl -> what_mode ((fun (_, t) -> t) (List.nth ltl 0))
  | Arrow (t1, t2) -> what_mode t1
  | With ltl -> what_mode ((fun (_, t) -> t) (List.nth ltl 0))
  | Down t -> ModeConst "U"
  | Up t -> ModeConst "U"
  | Flat (m, t) -> m
  | TpInst (name, ml) -> List.nth ml 0
  | Int32 -> ModeConst "U"

let lattice (m1 : string) (m2 : string) : bool =
  match (m1, m2) with
  | ("U", "U") -> true
  | ("U", _) -> false
  | ("L", "L") -> true
  | (_, "L") -> false
  | ("A", "S") -> false
  | ("S", "A") -> false
  | _ -> true

let mode_equality (m1 : mode) (m2 : mode) : bool =
  match (m1, m2) with
  | (ModeConst m, ModeConst m2) -> m = m2
  | (ModeVar m, ModeVar m2) -> m = m2
  | _ -> false

let rec mode_list_equality (m1 : mode list) (m2 : mode list) : bool =
  match (m1, m2) with
  | (a::m1, b::m2) -> (mode_equality a b) && (mode_list_equality m1 m2)
  | ([], []) -> true
  | _ -> false

let rec seen_before ((name, model) : string * (mode list)) (seen : (string * (mode list)) list) : bool =
  match seen with
  | [] -> false
  | ((n, ml)::seen) ->
     if (name = n) && (mode_list_equality model ml) then true else (seen_before (name, model) seen)

let rec check_if_dirty_type (types : tpdefn list) (t : tp) : bool =
  let rec inner (t : tp) (seen : (string * (mode list)) list) = 
    match t with
    | Flat (m, t') ->
      (match t' with
       | Times (t1, t2) -> inner t1 seen || inner t2 seen
       | One -> false
       | Plus ltl -> List.fold_left (fun acc -> fun (_, t) -> inner t seen || acc) false ltl
       | Arrow (t1, t2) -> inner t1 seen || inner t2 seen
       | With ltl -> List.fold_left (fun acc -> fun (_, t) -> inner t seen || acc) false ltl
       | Down t ->
         (not (lattice (Ast.Print.pp_mode m) (Ast.Print.pp_mode (what_mode t)))) || (inner t seen)
       | Up t ->
         (not (lattice (Ast.Print.pp_mode (what_mode t)) (Ast.Print.pp_mode m))) || (inner t seen)
       | Flat (m, t) -> inner (Flat (m, t)) seen
       | TpInst (_, ml) -> not (mode_equality (List.nth ml 0) m)
       | Int32 -> false)
    | Times (t1, t2) -> (inner t1 seen) || (inner t2 seen)
    | One -> false
    | Plus ltl -> List.fold_left (fun acc -> fun (_, t) -> inner t seen || acc) false ltl
    | Arrow (t1, t2) -> inner t1 seen || inner t2 seen
    | With ltl -> List.fold_left (fun acc -> fun (_, t) -> inner t seen || acc) false ltl
    | Down t -> inner t seen
    | Up t -> inner t seen
    | TpInst (n, ml) ->
      if (seen_before (n, ml) seen) then false else inner (type_inst_converter types t) ((n, ml)::seen)
    | Int32 -> false
  in
  inner t []

let rec static_type_check (types : tpdefn list) (ty : tp) =
  match ty with
  | Times (t1, t2) ->
    let () = static_type_check types t1
    in static_type_check types t2
  | One -> ()
  | Plus ltl ->
    let _ = List.fold_left
        (fun acc -> fun (l, _) ->
           if generic_contains_bool acc l (=)
           then raise (StaticError ("The label " ^ l ^ " is duplicate"))
           else l::acc
        ) [] ltl in
    let _ = List.map (forgetful_functor (static_type_check types)) ltl in ()
  | Arrow (t1, t2) -> let () = (static_type_check types t1) in (static_type_check types t2)
  | With ltl ->
    let _ = List.fold_left
        (fun acc -> fun (l, _) ->
           if generic_contains_bool acc l (=)
           then raise (StaticError ("The label " ^ l ^ " is duplicate"))
           else l::acc
        ) [] ltl in
    let _ = List.map (forgetful_functor (static_type_check types)) ltl in ()
  | Down t -> static_type_check types t
  | Up t -> static_type_check types t
  | Flat (m, t) -> static_type_check types t
  | TpInst (name, ml) ->
    let (_, mlp, t)  = find_type types name in
    let b = (match t with | TpInst _ -> false | _ -> true) in
    if not ((List.length mlp) = (List.length ml) && b)
    then raise (StaticError "ERROR")
    else
      let elaborated_type = type_inst_converter types (TpInst (name, ml)) in
      if check_if_dirty_type types elaborated_type then raise (StaticError ("Type " ^ (Ast.Print.pp_tp (TpInst (name, ml))) ^ " is dirty"))
  | Int32 -> ()
      

let rec static_pat_check (gamma : string list) (p : pat) : string list =
  match p with
  | PairPat (p1, p2) ->
    static_pat_check (static_pat_check gamma p2) p1
  | UnitPat -> gamma
  | InjPat (_, p) -> static_pat_check gamma p
  | VarPat v ->
    if generic_contains_bool gamma v (=)
    then raise (StaticError "Same variable used multiple times in a branch")
    else (v::gamma)
  | ShiftPat p -> static_pat_check gamma p

let rec static_exp_check (types : tpdefn list) (defns : expdefn list) (gamma : string list) (e : exp) =
  match e with
  | Var _ -> ()
  | Pair (e1, e2) ->
    let _ = static_exp_check types defns gamma e1 in
    static_exp_check types defns gamma e2
  | Unit -> ()
  | Inj (_, e) -> static_exp_check types defns gamma e
  | MatchWith (e, pel) ->
    let _ = static_exp_check types defns gamma e in
    let _ =
      List.map
        (forgetful_functor (static_exp_check types defns gamma)) pel in
    let _ =
      List.map
        (fun (p, _) -> static_pat_check [] p) pel in ()
  | Call (_, _) -> ()
  | Fun (vn, e) -> static_exp_check types defns (vn::gamma) e
  | Record lel ->
    let _ =
      List.map
        (forgetful_functor (static_exp_check types defns gamma)) lel in
    let _ = List.fold_left
        (fun acc -> fun (l, _) ->
           if generic_contains_bool acc l (=)
           then raise (StaticError ("Label " ^ l ^ " is duplicated"))
           else (l::acc)) [] lel
    in ()
  | Shift e -> static_exp_check types defns gamma e
  | Susp e -> static_exp_check types defns gamma e
  | Int i -> ()
  | Add (e1, e2) ->
    let _ = static_exp_check types defns gamma e1 in
    static_exp_check types defns gamma e2
  | Minus (e1, e2) ->
    let _ = static_exp_check types defns gamma e1 in
    static_exp_check types defns gamma e2      
  | Div (e1, e2) ->
    let _ = static_exp_check types defns gamma e1 in
    static_exp_check types defns gamma e2
  | Mult (e1, e2) ->
    let _ = static_exp_check types defns gamma e1 in
    static_exp_check types defns gamma e2
  | Eq (e1, e2) ->
    let _ = static_exp_check types defns gamma e1 in
    static_exp_check types defns gamma e2


let rec duplicate_params (c : context) : bool =
  match c with
  | ((x, _)::c) ->
    (generic_contains_bool c x (fun x -> fun (y, _) -> x = y) || (duplicate_params c))
  | [] -> false

let rec used_mode_constants (t : tp) =
  match t with
  | Times (t1, t2) -> (used_mode_constants t1) || (used_mode_constants t2)
  | One -> false
  | Plus ltl -> List.fold_left (fun acc -> fun (_, t) -> acc || used_mode_constants t) false ltl
  | Arrow (t1, t2) -> (used_mode_constants t1) || (used_mode_constants t2)
  | With ltl -> List.fold_left (fun acc -> fun (_, t) -> acc || used_mode_constants t) false ltl
  | Down t -> used_mode_constants t
  | Up t -> used_mode_constants t
  | Flat (m, t) ->
    (match m with
    | ModeConst _ -> true
    | _ -> used_mode_constants t)
  | TpInst (_, ml) -> List.fold_left
                        (fun acc -> fun m ->
                           let mc = (match m with | ModeConst _ -> true | ModeVar _ -> false) in
                           acc || mc) false ml
  | Int32 -> false


let rec free_var_finder (t : tp) (ctx : mode list) : bool =
  match t with
  | Times (t1, t2) -> (free_var_finder t1 ctx) || (free_var_finder t2 ctx)
  | One -> false
  | Plus  ltl ->
    List.fold_left (fun acc -> fun (_, t) -> (free_var_finder t ctx) || acc) false ltl
  | Arrow (t1, t2) -> (free_var_finder t1 ctx) || (free_var_finder t2 ctx)
  | With ltl -> List.fold_left (fun acc -> fun (_, t) -> (free_var_finder t ctx) || acc) false ltl
  | Down t -> free_var_finder t ctx
  | Up t -> free_var_finder t ctx
  | Flat (m, t) -> (not (contains_mode_single ctx m)) || (free_var_finder t ctx)
  | TpInst (tn, ml) ->
    List.fold_left (fun acc -> fun m -> acc || (not (contains_mode_single ctx m))) false ml
  | Int32 -> false

let rec no_mode_vars (t : tp) : bool = 
  let rec inner (ml : mode list) : bool =
    match ml with
    | [] -> true
    | m::ml ->
      (match m with
       | ModeConst _ -> inner ml
       | ModeVar _ -> false)
  in
  match t with
  | Times (t1, t2) -> (no_mode_vars t1) && (no_mode_vars t2)
  | One -> true
  | Plus ltl -> List.fold_left (fun acc -> fun (_, t) -> (no_mode_vars t) && acc) true ltl
  | Arrow (t1, t2) -> (no_mode_vars t1) && (no_mode_vars t2)
  | With ltl -> List.fold_left (fun acc -> fun (_, t) -> (no_mode_vars t) && acc) true ltl
  | Down t -> no_mode_vars t
  | Up t -> no_mode_vars t
  | Flat (m, t) ->
    (match m with
    | ModeVar _ -> false
    | ModeConst _ -> no_mode_vars t)
  | TpInst (_, ml) -> inner ml
  | Int32 -> true

let static_defn_check (types : tpdefn list) (defns : expdefn list) (d : defn) =
  match d with
  | TypeDefn (name, ml, t) ->
    let () = (if name = "int32" then raise (StaticError "Can't use int32 as a type name as it is a reserved keyword") else ()) in
    let () = (match t with | TpInst _ -> raise (StaticError "Can't use a type name as a type defn") | _ -> ()) in
    let _ = List.fold_left (fun acc -> fun m ->
          if contains_mode_single acc m 
          then raise (StaticError ("Reusing the mode " ^ (Ast.Print.pp_mode m) ^ " multiple times in mode list"))
          else (m::acc)) [] ml in
    let () = List.fold_left (fun acc -> fun m -> match m with | ModeConst _ -> raise (StaticError "used constant modes in type definitions") | _ -> acc) () ml in
    let () = if used_mode_constants t then raise (StaticError ("Used mode constants in defn of type " ^ name)) else () in
    let () = (if free_var_finder t ml then raise (StaticError ("Used variables not in mode list while defining " ^ name)) else ()) in
    static_type_check types t
  | ExpDefn (n, pl, t, e) ->
    let () = static_type_check types t in
    let () =
      (if not (List.fold_left (fun acc -> fun (_, t) ->
           let b = no_mode_vars t in
           acc && b)
           true (("rt", t)::pl))
       then raise (StaticError "Used variable modes in a not a type definition") else ()) in
    let _ =
      List.map
        (fun (_, t) ->
           if check_if_dirty_type types t
           then raise (StaticError ("Type " ^ (Ast.Print.pp_tp t)  ^ " is dirty"))
           else ()
        ) (("returntype", (type_inst_converter types t))::pl) in
    let () = static_exp_check types defns (List.map (fun (p, _) -> p) pl) e in
    let () =
      if (duplicate_params pl)
      then raise (StaticError ("The definition " ^ n ^ " has duplicate parameters")) in
    static_type_check types t
  | InstDefn (n, pl, t) ->
    let () =
      (if not (List.fold_left (fun acc -> fun (_, t) ->
           let b = no_mode_vars t in
           acc && b)
           true (("rt", t)::pl))
       then raise (StaticError "Used variable modes in a not a type definition") else ()) in
    let _ = find_defn defns n in
    let () = static_type_check types t in
    let () =
      (if (duplicate_params pl)
      then raise (StaticError ("The definition " ^ n ^ " has duplicate parameters"))
      else ()) in
    let _ = List.map (fun (_, t) -> static_type_check types t) pl in
    let _ =
      List.map
        (fun (_, t) ->
           if check_if_dirty_type types t
           then
             raise (StaticError ("Type " ^ (Ast.Print.pp_tp t)  ^ " is dirty"))
           else ()
        ) (("returntype", (type_inst_converter types t))::pl) in
    ()

let rec duplicate_checker (list) (equal) : bool =
  let rec inner (list) (value) : bool =
    match list with
    | [] -> false
    | (x::ls) -> (equal x value) || (inner ls value)
  in
  match list with
  | [] -> false
  | (x::ls) ->
    if inner ls x then true else duplicate_checker ls equal

let static_program_check (program : env) =
  let _ = type_list program in
  let types = tp_defns program in
  let defns = exp_defns program in
  if (duplicate_checker types (fun (n, _, _) -> fun (n2, _, _) -> n = n2)) || (duplicate_checker defns (fun (n, _, _, _) -> fun (n2, _, _, _) -> n = n2))
  then raise (StaticError "Duplicate type/defn")
  else
  let _ = List.map (static_defn_check types defns) program in ()
