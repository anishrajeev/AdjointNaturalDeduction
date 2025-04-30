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


exception TypeError of string

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

let rec print_context (input : context) : string =
  (match input with
  | [] -> "EMPTYCONTEXT\n"
  | (vn, t)::input -> "(" ^ vn ^ ": " ^ (Ast.Print.pp_tp t) ^ ") " ^ (print_context input))

let rec print_judgements (input : (context * exp) list) : string =
  (match input with
  | (ctx, e)::input -> (print_context ctx) ^ (Ast.Print.pp_exp 0 e) ^ "\n" ^ (print_judgements input)
  | [] -> "DONE WITH JUDGEMENTS\n")

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

let has_weakening (m1 : string) : bool = m1 = "U" || m1 = "A"                                         
let has_contraction (m1 : string) : bool = m1 = "U" || m1 = "S"

let rec what_mode (t : tp) : mode =
  match t with
  | Times (t1, _) -> what_mode t1
  | One -> ModeConst "U"
  | Plus ltl ->
    (match ltl with
     | (_, t)::_ -> what_mode t
     | _ -> raise (TypeError "Can't figure out the mode for a type"))
  | Arrow (t1, _) -> what_mode t1
  | With ltl -> 
    (match ltl with
     | (_, t)::_ -> what_mode t
     | _ -> raise (TypeError "Can't figure out the mode for a type"))
  | Down t -> 
    let x = Ast.Print.pp_mode (what_mode t) in
    if lattice "U" x then  ModeConst "U" else (raise (TypeError (x ^ " not :> U")))
  | Up _ -> ModeConst "U"
  | Flat (mode, _) -> mode
  | TpInst (_, ml) -> List.nth ml 0
  | Int32 -> ModeConst "U"

let rec remove (ctx : context) ((v, t) : varname*tp) : context =
  (match ctx with
  | [] -> if (has_weakening (Ast.Print.pp_mode (what_mode t))) then [] else raise (TypeError ("Tried to not use " ^ v ^ " when it doesn't have weakening"))
  | ((x, t')::ctx) -> if v = x then ctx else (x, t')::(remove ctx (v, t)))

let rec remove_list (c1 : context) (c2 : context) : context =
  match c2 with
  | ((x, t)::c2) -> remove_list (remove c1 (x, t)) c2
  | [] -> c1

let rec lub (c1 : context) (c2 : context) : context =
  match (c1, c2) with
  | ([], []) -> []
  | ((x, t)::c1, []) -> if (has_weakening (Ast.Print.pp_mode (what_mode t))) then (x, t)::(lub c1 c2) else raise (TypeError ("Variable " ^ x ^ " does not have weakening"))
  | ([], (x, t)::c2) -> if (has_weakening (Ast.Print.pp_mode (what_mode t))) then (x, t)::(lub c1 c2) else raise (TypeError ("Variable " ^ x ^ " does not have weakening"))
  | ((x, t)::c1, c2) -> (x, t)::(lub c1 (remove c2 (x, t)))

let rec contains (ctx : context) (v : varname) : tp =
  match ctx with
  | [] -> raise (TypeError ("Can't find variable " ^ v ^ " in context"))
  | (vn, t)::ctx -> if (v = vn) then t else contains ctx v

let rec contains_type (types : tpdefn list) (t : tpname) : (mode list)*tp =
  match types with
  | (tn, ml, tp)::types -> if t = tn then (ml, tp) else (contains_type types t)
  | [] -> raise (TypeError ("Could not find type " ^ t))

let rec contains_mode (modemap : (mode*mode) list) (m : mode) : mode =
  match (m, modemap) with
  | (ModeVar ms, ((ModeVar ma, mc)::modemap)) -> if ms = ma then mc else contains_mode modemap m
  | _ -> raise (TypeError "Mode never existed in the given mode map")

let rec contains_expression (lel : (label*exp) list) (l : label) : exp =
  match lel with
  | [] -> raise (TypeError ("The label " ^ l  ^ " never existed in the given lel"))
  | (l', e)::lel -> if l = l' then e else contains_expression lel l

let rec contains_defn (defns : expdefn list) (fn : expname) : expdefn =
  match defns with
  | [] -> raise (TypeError ("The definition " ^ fn  ^ " never existed in the top level definitions"))
  | (en, ctx, tp, exp)::defns -> if fn = en then (en, ctx, tp, exp) else contains_defn defns fn

let rec join (c1 : context) (c2 : context) : context =
  match (c1, c2) with
  | ([], []) -> []
  | (c1, []) -> c1
  | ([], c2) -> c2
  | ((x, t)::c1, c2) ->
    try
      let _ = contains c2 x in
      if has_contraction (Ast.Print.pp_mode (what_mode t))
      then (x, t)::(join c1 (remove c2 (x, t)))
      else raise (TypeError (x ^ " is used in multiple contexts but does not admit contraction"))
    with
    | TypeError e -> if e = ("Can't find variable " ^ x ^ " in context") then (x, t)::(join c1 c2) else raise (TypeError e)

let rec get_n l (n : int) =
  match (l, n) with
  | (_, 0) -> []
  | (x::l, n) -> x::(get_n l (n-1))
  | _ -> raise (TypeError "Not enough elements on the list to get n from")

let rec get_rest_minus_n l (n : int) =
  match (l, n) with
  | (l, 0) -> l
  | (_::l, n) -> get_rest_minus_n l (n-1)
  | _ -> raise (TypeError "Not enough elements on the list to remove n from")

let mode_equality (m1 : mode) (m2 : mode) : bool =
  match (m1, m2) with
  | (ModeConst m1, ModeConst m2) -> m1 = m2
  | (ModeVar m1, ModeVar m2) -> m1 = m2
  | _ -> false

let rec mode_list_equality (m1 : mode list) (m2 : mode list) : bool =
  match (m1, m2) with
  | ([], []) -> true
  | (l::m1, k::m2) -> (mode_equality l k) && (mode_list_equality m1 m2)
  | _ -> false

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
       | _ -> raise (TypeError "Ultraspecific error #1(more like a static error)"))
    | TpInst (tn, ml) ->
      TpInst (tn, List.map (fun m -> contains_mode modemap m) ml)
    | Int32 -> Int32
  in
  match t with
  | TpInst (tn, ml) ->
    let (mp, tp) = contains_type types tn in
    inner tp (List.combine mp ml)
  | _ -> t

let rec remove_from_list (ltl : (label*tp) list) (l : label) : (label*tp) list =
  match ltl with
  | [] -> raise (TypeError ("Could not find label " ^ l ^ " in the given ltl"))
  | (l', t)::ltl -> if l = l' then ltl else (l', t)::(remove_from_list ltl l)

let rec type_equal (types : tpdefn list) (t1 : tp) (t2 : tp) : bool =
  let rec contexts_equal (types : tpdefn list) (ltl1 : context) (ltl2 : context) : bool =
    match (ltl1, ltl2) with
    | ([], []) -> true
    | ((l, t)::ltl1, ltl2) ->
      (try
        (contexts_equal types ltl1 (remove_from_list ltl2 l)) && (type_equal types t (contains ltl2 l))
      with
      | _ -> false)
    | _ -> false in
  match (t1, t2) with
  | (Times (t11, t12), Times (t21, t22)) -> (type_equal types t11 t21) && (type_equal types t12 t22)
  | (One, One) -> true
  | (Plus ltl1, Plus ltl2) -> contexts_equal types ltl1 ltl2
  | (Arrow (t11, t12), Arrow(t21, t22)) -> (type_equal types t11 t21) && (type_equal types t12 t22)
  | (Down t1, Down t2) -> type_equal types t1 t2
  | (Up t1, Up t2) -> type_equal types t1 t2
  | (Flat (m1, t1), Flat (m2, t2)) -> mode_equality m1 m2 && type_equal types t1 t2
  | (TpInst (n1, ml1), TpInst(n2, ml2)) -> n1 = n2 && mode_list_equality ml1 ml2
  | (Int32, Int32) -> true
  | _ -> false


let rec contains_subtype_equation (types : tpdefn list)(tp1 : tp) (tp2 : tp) (seen : (tp*tp) list) : bool =
  match seen with
  | [] -> false
  | (t1, t2)::seen ->
    (type_equal types t1 tp1 && type_equal types t2 tp2) || (contains_subtype_equation types tp1 tp2 seen)

let type_subtype (types : tpdefn list) (t1 : tp) (t2 : tp) : bool =
  let rec inner (t1 : tp) (t2 : tp) (seen : (tp*tp) list) : bool =
    if (contains_subtype_equation types t1 t2 seen) || (type_equal types t1 t2)
    then true
    else
      (match (t1, t2) with
       | (TpInst (_, m1), TpInst (_, m2)) -> mode_equality (List.nth m1 0) (List.nth m2 0) && inner (type_inst_converter types t1) (type_inst_converter types t2) ((t1, t2)::seen)
       | (TpInst (_, _), _) -> inner (type_inst_converter types t1) t2 ((t1, t2)::seen)
       | (_, (TpInst (_, _))) ->
         inner t1 (type_inst_converter types t2) ((t1, t2)::seen)
       | (Flat (m1, t11), Flat (m2, t22)) -> (mode_equality m1 m2) && (inner t11 t22 ((t1, t2)::seen))
       | (Flat (m, t), _) -> (mode_equality m (what_mode t2)) && inner t t2 ((t1, t2)::seen)
       | (_, Flat (m, t)) -> (mode_equality m (what_mode t1)) && inner t1 t ((t1, t2)::seen)
       | (One, One) -> true
       | (Times (t11, t12), Times (t21, t22)) ->
         let newseen = (t1, t2)::seen in
         (inner t11 t21 (newseen)) && (inner t12 t22 (newseen))
       | (Plus ltl1, Plus ltl2) ->
         let newseen = (t1, t2)::seen in
         List.fold_left
           (fun acc -> fun (lab, t1) ->
              try
                if inner t1 (contains ltl2 lab) newseen
                then acc
                else false
              with
              | _ -> false) true ltl1
       | (Arrow (t1, t2), Arrow (t1', t2')) ->
         let newseen = (t1, t2)::seen in
         (inner t1' t1 newseen) && (inner t2 t2' newseen)
       | (With ltl1, With ltl2) ->
         let newseen = (t1, t2)::seen in
         List.fold_left
           (fun acc -> fun (lab, t1) ->
              try
                let t2 = contains ltl1 lab in
                if inner t2 t1 newseen then acc else false
              with
              | _ -> false) true ltl2
       | (Down t1, Down t2) ->
         inner t1 t2 ((Down t1, Down t2)::seen)
       | (Up t1, Up t2) ->
         inner t1 t2 ((Up t1, Up t2)::seen)
       | (Int32, Int32) -> true
       | (_, _) -> false)
  in
  inner t1 t2 []


let rec inversion (types : tpdefn list) (omega : tp list) (kstar : patseq list) : (context * exp) list =
  match omega with
  | t::omega' ->
    (match kstar with
     | [] -> raise (TypeError ("Inversion bug kstar is empty"))
     | (_, [], _)::_ -> raise (TypeError ("Omega isn't empty!"))
     | (_, (VarPat _)::_, _)::_ ->
       let filteredkstar =
         List.map
           (fun (ctx, pats, e) ->
              match pats with
              | (VarPat vn)::pats' -> ((vn, t)::ctx, pats', e)
              | _ -> raise (TypeError ("Inversion bug expected a variable"))) kstar in
       inversion types omega' filteredkstar
     | (_, UnitPat::_, _)::_ ->
       let unrolled_type = type_inst_converter types t in
       let rec unroll_flats (t : tp) : tp =
         (match t with
          | Flat (_, t) -> unroll_flats (type_inst_converter types t)
          | t -> t) in
       let t = unroll_flats unrolled_type in
       let () = (match t with | One -> () | _ -> raise (TypeError ("Inversion Bug expected omega to have unit type on top"))) in
       let filteredkstar =
         List.map
           (fun (ctx, pats, e) ->
              match pats with
              | UnitPat::pats' -> (ctx, pats', e)
              | _ -> raise (TypeError "Omega indicated unit type, one of branches doesn't conform")) kstar in
       inversion types omega' filteredkstar
     | (_, (PairPat (_, _))::_, _)::_ ->
       let unrolled_type = type_inst_converter types t in
       let rec unroll_flats (t : tp) : tp =
         (match t with
          | Flat (_, t) -> unroll_flats (type_inst_converter types t)
          | t -> t) in
       let t = unroll_flats unrolled_type in
       let (t1, t2) = (match t with | Times (t1, t2) -> (t1, t2) | _ -> raise (TypeError "Inversion Bug, expected omega to have pair type and it doesn't")) in
       let filteredkstar =
         List.map
           (fun (ctx, pats, e) ->
              match pats with
              | PairPat (p1, p2)::pats' -> (ctx, p1::(p2::pats'), e)
              | _ -> raise (TypeError "Inversion Bug, expected to see a pair pattern, didn't see that")) kstar in
       inversion types (t1::(t2::omega')) filteredkstar
     | (_, (InjPat (_, _))::_, _)::_ ->
       let unrolled_type = type_inst_converter types t in
       let rec unroll_flats (t : tp) : tp =
         (match t with
          | Flat (_, t) -> unroll_flats (type_inst_converter types t)
          | t -> t) in
       let t = unroll_flats unrolled_type in
       let ltl = (match t with | Plus ltl -> ltl | _ -> raise (TypeError "Inversion Bug, tried pattern matching on non sum type")) in
       let filteredkstar =
         List.map
           (fun (l, ty) ->
              let patterns =
                List.fold_right
                  (fun (ctx, pats, e) -> fun acc ->
                     match pats with
                     | (InjPat (l', p))::pats' -> if l = l' then (ctx, p::pats', e)::acc else acc
                     | _ -> raise (TypeError "Inversion Bug, One of the branches is not a sum type!")
                  ) kstar [] in
              let length = List.length patterns in
              if length = 0
              then raise (TypeError "Inversion Bug, the pattern matching is not surjective")
              else (ty::omega', patterns)) ltl in
       let recursed =
         List.map
           (fun (omega, kstar) -> inversion types omega kstar) filteredkstar in
       List.concat recursed
     | (_, (ShiftPat _)::_, _)::_ ->
       let unrolled_type = type_inst_converter types t in
       let rec unroll_flats (t : tp) : tp =
         (match t with
          | Flat (_, t) -> unroll_flats (type_inst_converter types t)
          | Down t -> t
          | _ -> raise (TypeError "Tried pattern matching a shift pattern with a non downshifted type")) in
       let checkagainst = unroll_flats unrolled_type in
       let filteredkstar = 
         List.map
           (fun (ctx, pats, e) ->
              match pats with
              | (ShiftPat p)::pats' -> (ctx, p::pats', e)
              | _ -> raise (TypeError "Tried to breakdown a shift using a non shift pattern")) kstar in
       inversion types (checkagainst::omega') filteredkstar)
  | [] ->
    if not (List.length kstar = 1)
    then raise (TypeError "The branches are not injective")
    else
      List.map
        (fun (ctx, pats, e) ->
           if (List.length pats) = 0
           then (ctx, e)
           else raise (TypeError "Inversion Bug, omega is empty but at least one branch isn't!")) kstar

let rec is_int32 (types : tpdefn list) (t : tp) : bool =
      (match t with
       | Flat (_, t) -> is_int32 types (type_inst_converter types t)
       | Int32 -> true
       | _ -> false)


let rec type_exp_check (defns : expdefn list) (types : tpdefn list) (inst_defns : instdefn list) (e : exp) (gamma : context) (check : tp) : context =
  match e with
  | Var vn ->
    (try
       if type_subtype types (contains gamma vn) check
       then [(vn, check)]
       else raise (TypeError ("Checking Judgement of var " ^ vn ^ " is incorrect"))
     with
     | _ -> type_exp_check defns types inst_defns (Call (vn, [])) gamma check)
  | Pair (e1, e2) ->
    let unrolled_type = type_inst_converter types check in
    let unrolled_type = (match unrolled_type with | Flat (_, t) -> t | t -> t) in
    (match unrolled_type with
     | Flat (_, t) -> type_exp_check defns types inst_defns (Pair (e1, e2)) gamma t
     | Times (t1, t2) ->
       let sigma1 = type_exp_check defns types inst_defns e1 gamma t1 in
       let sigma2 = type_exp_check defns types inst_defns e2 gamma t2 in
       join sigma1 sigma2
     | _ -> raise (TypeError "Tried checking a pair against a non pair type"))
  | Unit -> let unrolled_type = type_inst_converter types check in
    let rec unroll_flats (t : tp) : bool =
      (match t with
       | Flat (_, t) -> unroll_flats (type_inst_converter types t)
       | One -> true
       | _ -> false) in
    if unroll_flats unrolled_type then [] else (raise (TypeError "Tried checking unit with a non-unit type"))
  | Inj (l, e) ->
    let unrolled_type = type_inst_converter types check in
    let rec unroll_flats (t : tp) : tp =
      (match t with
       | Flat (_, t) -> unroll_flats (type_inst_converter types t)
       | Plus ltl -> contains ltl l
       | _ -> raise (TypeError "Tried checking an injection against a non sum type")) in
    let checkagainst = unroll_flats unrolled_type in
    type_exp_check defns types inst_defns e gamma checkagainst
  | MatchWith (e, pel) ->
    (let (t, xi1) = type_exp_synth defns types inst_defns e gamma in
     let cm = Ast.Print.pp_mode (what_mode check) in
     let tm = Ast.Print.pp_mode (what_mode t) in
     if not (lattice cm tm)
     then raise (TypeError ("Matching with something and mode " ^ cm ^ " not <: " ^ tm))
     else
     let kstar = List.map (fun (p, e) -> ([], (p::[]), e)) pel in
     let judgements = inversion types (t::[]) kstar in
     let xilist =
       List.map
         (fun (ctx, ex) ->
            let xix = type_exp_check defns types inst_defns ex (ctx@gamma) check in
            remove_list xix ctx) judgements
     in
     let xi2 = List.fold_left
         (fun acc -> fun xi ->
            lub acc xi) (List.nth xilist 0) xilist in
     join xi2 xi1
    )
  | Call (vn, spine) ->
    let rec spine_crusher (t : tp) (spine : atom list) (sigma : context) =
      (match spine with
       | [] ->
         if type_subtype types t check then (t, sigma) else raise (TypeError "Spine crushed, left wrong type")
       | (vert::spine) ->
         let rec unroll_flats (t : tp) : tp =
           (match t with
            | Flat (_, t) -> unroll_flats (type_inst_converter types t)
            | TpInst _ -> unroll_flats (type_inst_converter types t)
            | t -> t)
         in
         let t = unroll_flats t in
         (match (vert, t) with
          | (Exp e, Arrow (t1, t2)) -> spine_crusher t2 spine (join sigma (type_exp_check defns types inst_defns e gamma t1))
          | (Dot l, With ltl) -> spine_crusher (contains ltl l) spine sigma
          | (Force, Up t) -> spine_crusher t spine sigma
          | _ -> raise (TypeError "Spine crushing failed")))
    in
    (try
       let t = contains gamma vn in
       let (rt, sigma) = spine_crusher t spine [(vn, t)] in
       if type_subtype types rt check then sigma else raise (TypeError "Spine crushed into the wrong type")
     with
     | TypeError x ->
       if not (x = ("Can't find variable " ^ vn ^ " in context"))
       then raise (TypeError x)
       else
         let _ = contains_defn defns vn in
       let ((_, tl, _), sigma) = target_type_generation defns types inst_defns gamma vn spine check in
       let params = List.map (fun x -> match x with | Exp e -> e | _ -> raise (TypeError "Tried to pass a non expression to a meta var")) (get_n spine (List.length tl)) in
       let combined = List.combine tl params in
       let checked = List.map (fun (t, e) -> type_exp_check defns types inst_defns e gamma t) combined in
       List.fold_left (fun acc -> fun s -> join acc s) sigma checked)
  (* MODE NOT BEING PROPOGATED DOWN IN GAMMA IN THIS FUN BRANCH MAY CAUSE ISSUES: THINK ABT THIS LATER *)
  | Fun (vn, e) ->
    let unrolled_type = type_inst_converter types check in
    let rec unroll_flats (t : tp) : tp*tp =
      (match t with
       | Flat (_, t) -> unroll_flats (type_inst_converter types t)
       | Arrow (t1, t2) -> (t1, t2)
       | _ -> raise (TypeError "Tried checking a lambda against a non arrow type")) in
    let (t1, t2) = unroll_flats unrolled_type in
    let sigma = type_exp_check defns types inst_defns e ((vn, t1)::gamma) t2 in
    remove sigma (vn, t1)
  | Record lel ->
    let unrolled_type = type_inst_converter types check in
    let rec unroll_flats (t : tp) : (label*tp) list =
      (match t with
       | Flat (_, t) -> unroll_flats (type_inst_converter types t)
       | With ltl -> ltl
       | _ -> raise (TypeError "Tried checking a projection against a non record type")) in
    let ltl = unroll_flats unrolled_type in
    let sigma_naught =
      (match ltl with
       | (l, t)::_ ->
         let e = contains_expression lel l in
         type_exp_check defns types inst_defns e gamma t
       | _ -> raise (TypeError "Empty Sum")) in
    List.fold_left
      (fun sigma -> fun (l, t) ->
         let e = contains_expression lel l in
         lub sigma (type_exp_check defns types inst_defns e gamma t)) sigma_naught ltl
  | Shift e -> 
    let unrolled_type = type_inst_converter types check in
    let rec unroll_flats (t : tp) : tp =
      (match t with
       | Flat (_, t) -> unroll_flats (type_inst_converter types t)
       | Down t -> t
       | _ -> raise (TypeError "Tried checking a downshift against a non downshifted type")) in
    type_exp_check defns types inst_defns e gamma (unroll_flats unrolled_type)
  | Susp e ->
    let m = what_mode check in
    let unrolled_type = type_inst_converter types check in
    let rec unroll_flats (t : tp) : tp =
      (match t with
       | Flat (_, t) -> unroll_flats (type_inst_converter types t)
       | Up t -> t
       | _ -> raise (TypeError "Tried checking an upshift against a non upshifted type")) in
    let sigma = type_exp_check defns types inst_defns e gamma (unroll_flats unrolled_type) in
    let independence = List.fold_left (fun acc -> fun (_, t) -> lattice (Ast.Print.pp_mode m) (Ast.Print.pp_mode (what_mode t)) && acc) true sigma in
    if independence then sigma else raise (TypeError "Tried upshifting and didn't respect independence")
  | Int i ->
    if is_int32 types (type_inst_converter types check)
    then []
    else raise (TypeError ("Tried checking the int " ^ (string_of_int i) ^ " against a non int32 type"))
  | Add (e1, e2) ->
    let m = what_mode check in
    let sigma1 = type_exp_check defns types inst_defns e1 gamma (Flat (m, Int32)) in
    let sigma2 = type_exp_check defns types inst_defns e2 gamma (Flat (m, Int32)) in
    if is_int32 types (type_inst_converter types check)
    then join sigma1 sigma2
    else raise (TypeError "Tried checking an addition expression against a non int32 type")
  | Minus (e1, e2) ->
    let m = what_mode check in
    let sigma1 = type_exp_check defns types inst_defns e1 gamma (Flat (m, Int32)) in
    let sigma2 = type_exp_check defns types inst_defns e2 gamma (Flat (m, Int32)) in
    if is_int32 types (type_inst_converter types check)
    then join sigma1 sigma2
    else raise (TypeError "Tried checking a subtraction expression against a non int32 type")
  | Div (e1, e2) ->
    let m = what_mode check in
    let sigma1 = type_exp_check defns types inst_defns e1 gamma (Flat (m, Int32)) in
    let sigma2 = type_exp_check defns types inst_defns e2 gamma (Flat (m, Int32)) in
    if is_int32 types (type_inst_converter types check)
    then join sigma1 sigma2
    else raise (TypeError "Tried checking a division expression against a non int32 type")
  | Mult (e1, e2) ->
    let m = what_mode check in
    let sigma1 = type_exp_check defns types inst_defns e1 gamma (Flat (m, Int32)) in
    let sigma2 = type_exp_check defns types inst_defns e2 gamma (Flat (m, Int32)) in
    if is_int32 types (type_inst_converter types check)
    then join sigma1 sigma2
    else raise (TypeError "Tried checking a multiplication expression against a non int32 type")
  | Eq (e1, e2) ->
    let m = what_mode check in
    let sigma1 = type_exp_check defns types inst_defns e1 gamma (Flat (m, Int32)) in
    let sigma2 = type_exp_check defns types inst_defns e2 gamma (Flat (m, Int32)) in
    if type_subtype types (Flat (m, Plus [("'true", Flat (m, One)); ("'false", Flat (m, One))])) check
    then join sigma1 sigma2
    else raise (TypeError "Tried checking equal expression against a non boolean type")
and
  type_exp_synth (defns : expdefn list) (types : tpdefn list) (inst_defns : instdefn list) (e : exp) (gamma : context) : tp * context = 
  (match e with
   | Var vn -> let t = contains gamma vn in (t, [(vn, t)])
   | Pair (e1, e2) ->
     let (t1, c1) = type_exp_synth defns types inst_defns e1 gamma in
     let (t2, c2) = type_exp_synth defns types inst_defns e2 gamma in
     (Times (t1, t2), join c1 c2)
   | Unit -> raise (TypeError "Can't synthesize the unit type!")
   | Inj _ -> raise (TypeError "Can't synthesize the sum type!")
   | MatchWith _ -> raise (TypeError "Can't synthesize match statements!")
   | Call (vn, spine) ->
     let rec spine_crusher (t : tp) (spine : atom list) (sigma : context) =
       (match spine with
        | [] -> (t, sigma)
        | (vert::spine) ->
          let rec unroll_flats (t : tp) : tp =
            (match t with
             | Flat (_, t) -> unroll_flats (type_inst_converter types t)
             | TpInst _ -> unroll_flats (type_inst_converter types t)
             | t -> t)
          in
          let t = unroll_flats t in
          (match (vert, t) with
           | (Exp e, Arrow (t1, t2)) -> spine_crusher t2 spine (join sigma (type_exp_check defns types inst_defns e gamma t1))
           | (Dot l, With ltl) -> spine_crusher (contains ltl l) spine sigma
           | (Force, Up t) -> spine_crusher t spine sigma
           | _ -> raise (TypeError "Spine crushing failed")))
     in
     (try
        let t = contains gamma vn in
        spine_crusher t spine [(vn, t)]
      with
      | TypeError _ -> raise (TypeError ("Can't synthesize metavariables(" ^ vn ^ ")!")))
   | Fun _ -> raise (TypeError "Can't synthesize the arrow type!")
   | Record _ -> raise (TypeError "Can't synthesize a record type!")
   | Shift e -> let (t, s) = type_exp_synth defns types inst_defns e gamma in (Down t, s)
   | Susp e -> let (t, s) = type_exp_synth defns types inst_defns e gamma in (Down t, s)
   | Int i -> raise (TypeError "Can't synthesize a raw integer due to the ambiguity")
   | Add (e1, e2) ->
    let (t1, s1) = type_exp_synth defns types inst_defns e1 gamma in
    let (t2, s2) = type_exp_synth defns types inst_defns e2 gamma in
    let m1 = what_mode t1 in
    let m2 = what_mode t2 in
    if (mode_equality m1 m2) && (is_int32 types (type_inst_converter types t1)) && (is_int32 types (type_inst_converter types t2))
    then (Flat (m1, Int32), join s1 s2)
    else raise (TypeError "Tried synthing an addition expression but sub exp are not ints, or modes don't match")
   | Minus (e1, e2) ->
    let (t1, s1) = type_exp_synth defns types inst_defns e1 gamma in
    let (t2, s2) = type_exp_synth defns types inst_defns e2 gamma in
    let m1 = what_mode t1 in
    let m2 = what_mode t2 in
    if (mode_equality m1 m2) && (is_int32 types (type_inst_converter types t1)) && (is_int32 types (type_inst_converter types t2))
    then (Flat (m1, Int32), join s1 s2)
    else raise (TypeError "Tried synthing a subtraction expression but sub exp are not ints, or modes don't match")
   | Div (e1, e2) ->
    let (t1, s1) = type_exp_synth defns types inst_defns e1 gamma in
    let (t2, s2) = type_exp_synth defns types inst_defns e2 gamma in
    let m1 = what_mode t1 in
    let m2 = what_mode t2 in
    if (mode_equality m1 m2) && (is_int32 types (type_inst_converter types t1)) && (is_int32 types (type_inst_converter types t2))
    then (Flat (m1, Int32), join s1 s2)
    else raise (TypeError "Tried synthing a division expression but sub exp are not ints, or modes don't match")
   | Mult (e1, e2) ->
    let (t1, s1) = type_exp_synth defns types inst_defns e1 gamma in
    let (t2, s2) = type_exp_synth defns types inst_defns e2 gamma in
    let m1 = what_mode t1 in
    let m2 = what_mode t2 in
    if (mode_equality m1 m2) && (is_int32 types (type_inst_converter types t1)) && (is_int32 types (type_inst_converter types t2))
    then (Flat (m1, Int32), join s1 s2)
    else raise (TypeError "Tried synthing a multiplication expression but sub exp are not ints, or modes don't match")
   | Eq (e1, e2) ->
     match (e1, e2) with
     | (Int _, Int _) -> raise (TypeError "Can't synthesize what type an equal should be if no information is provided")
     | (Int _, e) ->
       let (t, sigma) = type_exp_synth defns types inst_defns e gamma in
       let m = what_mode t in
       ((Flat (m, Plus [("'true", Flat (m, One)); ("'false", Flat (m, One))])), sigma)
     | (e, Int _) ->
       let (t, sigma) = type_exp_synth defns types inst_defns e gamma in
       let m = what_mode t in
       ((Flat (m, Plus [("'true", Flat (m, One)); ("'false", Flat (m, One))])), sigma)
     | (e1, e2) ->
       let (t1, sigma1) = type_exp_synth defns types inst_defns e1 gamma in
       let (t2, sigma2) = type_exp_synth defns types inst_defns e2 gamma in
       let (m1, m2) = (what_mode t1, what_mode t2) in
       if mode_equality m1 m2
       then ((Flat (m1, Plus [("'true", Flat (m1, One)); ("'false", Flat (m1, One))])), join sigma1 sigma2)
       else raise (TypeError "Tried synthesizing a equal expression where the two expressions had different modes"))
and
  target_type_generation (defns : expdefn list) (types : tpdefn list) (inst_defns : instdefn list) (gamma : context) (en : expname) (spine : atom list) (check : tp) : instdefn*context =
  let rec inner (gamma : context) (spine : atom list) (target_type : tp) : tp*context =
    match spine with
    | [] -> (target_type, [])
    | vert::spine ->
      let target_type = type_inst_converter types target_type in
      match (vert, target_type) with
      | (_, Flat (_, t)) -> inner gamma (vert::spine) t
      | (Exp e, Arrow (t1, t2)) ->
        let sigma = type_exp_check defns types inst_defns e gamma t1 in
        let (t, s) = inner gamma spine t2 in
        (t, join sigma s)
      | (Dot l, With ltl) ->
        let t = contains ltl l in
        inner gamma spine t
      | (Force, Up t) -> inner gamma spine t
      | _ -> raise (TypeError "target_type individual generation failed")
  in
  let filtered = List.filter_map
      (fun (n, tl, t) ->
         if not (n = en)
         then None
         else
           let leftover = get_rest_minus_n spine (List.length tl) in
           try
             let (t, s) = inner gamma leftover t in
             if type_subtype types t check
             then Some ((n, tl, t), s)
             else None
           with
           |_ -> None) inst_defns in
  if List.length filtered = 0
  then raise (TypeError ("There is no instance of " ^ en ^ " that supports type " ^ (Ast.Print.pp_tp check)))
  else List.nth filtered 0


let type_defn (defns : expdefn list) (types : tpdefn list) (inst_defns : instdefn list) (def : defn) =
  match def with
  | ExpDefn (name, pl, _, e) ->
    let paramlist = List.map (fun (x, _) -> x) pl in
    (* let () = print_endline ("TYPING : " ^ name) in *)
    let _ =
      List.filter_map
        (fun (en, tl, t) ->
           if en = name
           then
             let modelist = List.map what_mode tl in
             let outputmode = what_mode t in
             let independent = List.fold_left (fun acc -> fun m -> (lattice (Ast.Print.pp_mode outputmode) (Ast.Print.pp_mode m)) && acc) true modelist in
             if not independent
             then raise (TypeError ("Independence condition not fulfilled on metavariable " ^ en ^ "!"))
             else
               let gamma = List.combine paramlist tl in
               let sigma = type_exp_check defns types inst_defns e gamma t in
               let _ =
                 List.map
                   (fun (x, t) -> remove sigma (x, t)) gamma
               in Some ()
           else None) inst_defns
    in ()
  | _ -> ()

let type_program (program : env) =
  let defns = exp_defns program in
  let types = tp_defns program in
  let inst_defns = inst_defns program in
  List.fold_left
    (fun _ -> fun d ->
       type_defn defns types inst_defns d) () program
