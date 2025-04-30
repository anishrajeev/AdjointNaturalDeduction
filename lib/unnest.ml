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

exception UnnestError of string

type context = parm list

type tpdefn = tpname * (mode list) * tp
type expdefn = expname * context * tp * exp
type patseq = (pat list) * exp

(*let rec print_context (input : context) : string =
  match input with
  | [] -> "EMPTYCONTEXT\n"
  | (vn, t)::input -> "(" ^ vn ^ ": " ^ (Ast.Print.pp_tp t) ^ ") " ^ (print_context input)*)

              
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

(*let rec print_context (c : context) =
  match c with
  | [] -> "END OF CTX\n"
  | ((v, t)::c) -> (v ^ ": " ^ (Ast.Print.pp_tp t) ^ "\n" ^ (print_context c))*)

let counter = ref 0
let increment () = counter := !counter + 1
let get_count () = !counter

let next () =
  increment();
  (string_of_int (get_count()))

let rec contains (c : context) (x : string) : tp =
  match c with
  | [] ->
    raise (UnnestError ("Context does not have variable " ^ x))
  | ((n, t) :: cr) ->
    if x = n then t else contains cr x

let rec contains_type (types : tpdefn list) (t : tpname) : (mode list)*tp =
  match types with
  | (tn, ml, tp)::types -> if t = tn then (ml, tp) else (contains_type types t)
  | [] -> raise (UnnestError ("Could not find type " ^ t))

let rec contains_mode (modemap : (mode*mode) list) (m : mode) : mode =
  match (m, modemap) with
  | (ModeVar ms, ((ModeVar ma, mc)::modemap)) -> if ms = ma then mc else contains_mode modemap m
  | _ -> raise (UnnestError "Mode never existed in the given mode map")

let rec patcontains (p : pat) (x : varname) : bool =
  match p with
  | PairPat (p1, p2) -> (patcontains p1 x) || (patcontains p2 x)
  | UnitPat -> false
  | InjPat (_, p) -> patcontains p x
  | ShiftPat p -> patcontains p x
  | VarPat v -> v = x

(*Replace v1 for v2 in exp*)
let rec substitution (v1 : varname) (v2 : varname) (e : exp) : exp=
  match e with
  | Var v -> if v = v1 then Var v2 else Var v
  | Pair (p1, p2) -> Pair (substitution v1 v2 p1, substitution v1 v2 p2)
  | Unit -> Unit
  | Inj (lab, e) -> Inj (lab, substitution v1 v2 e)
  | MatchWith (e', pel) ->
    let matchedexp = substitution v1 v2 e' in
    let newlist =
      List.map
        (fun (p, e) ->
           if patcontains p v1
           then (p, e)
           else (p, substitution v1 v2 e)) pel in
    MatchWith (matchedexp, newlist)
  | Call (vn, spine) -> Call ((if vn = v1 then v2 else vn), List.map
                             (fun a ->
                                match a with
                                | Exp e -> Exp (substitution v1 v2 e)
                                | Dot l -> Dot l
                                | Force -> Force) spine)
  | Fun (vn, e) -> if vn = v1 then Fun (vn, e) else Fun(vn, substitution v1 v2 e)
  | Record lel -> Record (List.map (fun (l, e) -> (l, substitution v1 v2 e)) lel)
  | Shift e -> Shift (substitution v1 v2 e)
  | Susp e -> Susp (substitution v1 v2 e)
  | Int i -> Int i
  | Add (e1, e2) -> Add (substitution v1 v2 e1, substitution v1 v2 e2)
  | Minus (e1, e2) -> Minus (substitution v1 v2 e1, substitution v1 v2 e2)
  | Div (e1, e2) -> Div (substitution v1 v2 e1, substitution v1 v2 e2)
  | Mult (e1, e2) -> Mult (substitution v1 v2 e1, substitution v1 v2 e2)
  | Eq (e1, e2) -> Eq (substitution v1 v2 e1, substitution v1 v2 e2)


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
       | _ -> raise (UnnestError "Ultraspecific error #1(more like a static error)"))
    | TpInst (tn, ml) ->
      TpInst (tn, List.map (fun m -> contains_mode modemap m) ml)
    | Int32 -> Int32
  in
  match t with
  | TpInst (tn, ml) ->
    let (mp, tp) = contains_type types tn in
    inner tp (List.combine mp ml)
  | _ -> t

let rec unroll_type (t : tp) : tp =
  match t with
  | Flat (_, t) -> unroll_type t
  | t -> t

let rec unwrap (types : tpdefn list) (delta : varname list) (omega : tp list) (kstar : patseq list) : (context * exp) =
  match omega with
  | t::omega' ->
    (match kstar with
     | [] -> raise (UnnestError ("Inversion bug kstar is empty"))
     | ([], _)::_ -> raise (UnnestError ("Omega isn't empty!"))
     | ((VarPat _)::_, _)::_ ->
       (match delta with
        | (v::d) ->
          let fresh = "n$"^(next ()) in
          let filteredkstar =
            List.map
              (fun (pl, e) ->
                 match pl with
                 | ((VarPat v2)::pl) -> (pl, substitution v2 fresh e)
                 | _ -> raise (UnnestError "You used a variable in one branch and a non variable in another at the same level")
              ) kstar in
          let  (gamma, e) = unwrap types d omega' filteredkstar in
          ((v, t)::gamma, MatchWith (Var v, [(VarPat fresh, e)]))
        | _ -> raise (UnnestError ("Delta is empty while unmatching the var type in omega")))
     | (UnitPat::_, _)::_ ->
       (match delta with
        | (v::d) ->
          let filteredkstar =
            List.map
              (fun (pl, e) ->
                 match pl with
                 | (UnitPat::pl) -> (pl, e)
                 | _ -> raise (UnnestError "Wrong pattern while deconstructing unit")) kstar in
          let (gamma, e) = unwrap types d omega' filteredkstar in
          (gamma, MatchWith (Var v, [(UnitPat, e)]))
        | _ -> raise (UnnestError ("Delta is empty while unmatching the unit type in omega")))
     | ((PairPat (_, _))::_, _)::_ ->
       (match delta with
        | (v::d) ->
          let t = unroll_type (type_inst_converter types t) in          
          let (t1, t2) = (match t with | Times (t1, t2) -> (t1, t2) | _ -> raise (UnnestError "Typechecking error")) in
          let filteredkstar =
            List.map
              (fun (pl, e) ->
                 match pl with
                 | PairPat (p1, p2)::pl -> (p1::p2::pl, e)
                 | _ -> raise (UnnestError "Typechecking error")) kstar in
          let fresh1 = "n$"^(next ()) in
          let fresh2 = "n$"^(next ()) in
          let (gamma, e) = unwrap types (fresh1::fresh2::d) (t1::t2::omega') filteredkstar in
          ((v, t)::gamma, MatchWith (Var v, [(PairPat(VarPat fresh1, VarPat fresh2), e)]))
        | _ -> raise (UnnestError ("Delta is empty while unmatching the pair type in omega")))
     | (InjPat (_, _)::_, _)::_ ->
       (match delta with
        | (v::d) ->
          let t = unroll_type (type_inst_converter types t) in
          let ltl = (match t with | Plus ltl -> ltl | _ -> raise (UnnestError "Typechecking error")) in
          (*filtered kstar is a list of all the branches for each label!*)
          let filteredkstar = 
            List.map
              (fun (l, ty) ->
                 let patterns =
                   List.fold_right
                     (fun (pats, e) -> fun acc ->
                        match pats with
                        | (InjPat (l', p))::pats' -> if l = l' then (p::pats', e)::acc else acc
                        | _ -> raise (UnnestError "Inversion Bug, One of the branches is not a sum type!")
                     ) kstar [] in
                 let length = List.length patterns in
                 if length = 0
                 then raise (UnnestError "Inversion Bug, the pattern matching is not surjective")
                 else (l, ty::omega', patterns)) ltl in
          let fresh = "n$"^(next ()) in          
          let (gamma, pel) = List.fold_left_map
              (fun acc -> fun (lab, omega, pats) ->
                 let (gamma, unwrapped) = unwrap types (fresh::d) omega pats in
                 (gamma@acc, (InjPat (lab, VarPat fresh), unwrapped))) [] filteredkstar in
          ((v, t)::gamma, MatchWith(Var v, pel))
        | [] -> raise (UnnestError ("Delta is empty while unmatching the sum type in omega")))
     | (ShiftPat _::_, _)::_ ->
       (match delta with
        | (v::d) ->
          let t = unroll_type (type_inst_converter types t) in
          let t = (match t with | Down t -> t | _ -> raise (UnnestError "Typechecking error")) in
          let filteredkstar =
            List.map
              (fun (pl, e) ->
                 match pl with
                 | ShiftPat p::pl -> (p::pl, e)
                 | _ -> raise (UnnestError "Typechecking error")) kstar in
          let fresh = "n$"^(next ()) in
          let (gamma, e) = unwrap types (fresh::d) (t::omega') filteredkstar in
          ((v, t)::gamma, MatchWith (Var v, [(ShiftPat (VarPat fresh), e)]))
        | _ -> raise (UnnestError ("Delta is empty while unmatching the pair type in omega")))
    )
  | [] ->
    match kstar with
    | (pats, e)::[] ->
      if((List.length pats) = 0)
      then ([], e)
      else raise (UnnestError "Inversion Bug, omega is empty but at least one branch isn't!")
    | [] -> raise (UnnestError "There has been an error and kstar is too small")
    | _ -> raise (UnnestError "There has been an error and kstar is too big")

let rec find_defn (defns : expdefn list) (name : expname) : expdefn =
  match defns with
  | (dn, pl, tp, e)::defns -> if dn = name then (dn, pl, tp, e) else (find_defn defns name)
  | [] -> raise (UnnestError ("Can't find definition named " ^ name))

let rec synth (defns : expdefn list) (gamma : context) (types : tpdefn list) (e : exp) : tp =
  match e with
  | Var vn ->
    (try  contains gamma vn
    with
    | _ -> let (_, _, t, _) = find_defn defns vn in t)
  | Pair (e1, e2) -> Times ((synth defns gamma types e1), (synth defns gamma types e2))
  | Unit -> One
  | Inj (_, _) -> raise (UnnestError "Can't synthesize a sum")
  | MatchWith (_, _) -> raise (UnnestError "Can't synthesize a match")
  | Call (vn, spine) ->
    let rec spine_crusher (spine : atom list) (t : tp) =
      let t = unroll_type (type_inst_converter types t) in
      match (spine, t) with
      | ([], _) -> t
      | ((Exp _)::spine, Arrow (_, t2)) -> spine_crusher spine t2
      | ((Dot l)::spine, With ltl) -> spine_crusher spine (contains ltl l)
      | (Force::spine, Up t) -> spine_crusher spine t
      | _ -> raise (UnnestError "Spine crushing error") in
    (try
       let t = contains gamma vn in
       spine_crusher spine t
     with
     | _ ->
       let (_, pl, t, _) = find_defn defns vn in
       let rec remove_top_n (spine : atom list) (n : int) =
         match (spine, n) with
         | (s, 0) -> s
         | ([], _) -> raise (UnnestError "Not enough to remove")
         | (_::spine, n) -> remove_top_n spine (n-1) in
       let leftover = remove_top_n spine (List.length pl) in
       spine_crusher leftover t)
  | Fun (_, _) -> raise (UnnestError "Can't synthesize an anon func")
  | Record _ -> raise (UnnestError "Can't synthesize a record")
  | Shift _ -> raise (UnnestError "Can't synthesize a down shift")
  | Susp _ -> raise (UnnestError "Can't synthesize a down shift")
  | Int i -> Int32
  | Add (_, _) -> Int32
  | Minus (_, _) -> Int32
  | Div (_, _) -> Int32
  | Mult (_, _) -> Int32
  | Eq (_, _) -> Plus [("'true", One); ("'false", One)]
    

let rec unwrap_exp (defns : expdefn list) (types : tpdefn list) (gamma : context) (t : tp) (e : exp) : exp =
  match e with
  | Var v -> Var v
  | Pair (e1, e2) ->
    let t = unroll_type (type_inst_converter types t) in
    (match t with
    | Times (t1, t2) -> Pair (unwrap_exp defns types gamma t1 e1, unwrap_exp defns types gamma t2 e2)
    | _ -> raise (UnnestError "ERROR1"))
  | Unit -> Unit
  | Inj (l, e) ->
    let t = unroll_type (type_inst_converter types t) in
    (match t with
    | Plus ltl ->  Inj (l, unwrap_exp defns types gamma (contains ltl l) e)
    | _ -> raise (UnnestError "ERROR2"))
  | Call (vn, spine) ->
    let rec spine_crusher (spine : atom list) (t : tp) (acc : atom list) =
      let t = unroll_type (type_inst_converter types t) in
      match (spine, t) with
      | ([], _) -> acc
      | ((Exp e)::spine, Arrow (t1, t2)) ->
        spine_crusher spine t2 (Exp (unwrap_exp defns types gamma t1 e)::acc)
      | ((Dot l)::spine, With ltl) -> spine_crusher spine (contains ltl l) (Dot l::acc)
      | (Force::spine, Up t) -> spine_crusher spine t (Force::acc)
      | _ ->
        raise (UnnestError "Spine crushing error") in
    (try
       let t = contains gamma vn in
       Call (vn, List.rev (spine_crusher spine t []))
     with
     | _ ->
       let (_, pl, t, _) = find_defn defns vn in
       let rec remove_top_n (spine : atom list) (n : int) (pl : parm list) (acc : atom list) =
         match (pl, spine, n) with
         | (_, s, 0) -> (s, acc)
         | (_, [], _) -> raise (UnnestError "Not enough to remove")
         | ((_, t)::pl, Exp e::spine, n) -> remove_top_n spine (n-1) pl ((Exp (unwrap_exp defns types gamma t e)::acc))
         | _ -> raise (UnnestError "Removing top gone wrong")
       in
       let (leftover, acc) = remove_top_n spine (List.length pl) pl [] in
       let spine_crushed = spine_crusher leftover t acc in
       Call (vn, List.rev spine_crushed))
  | MatchWith (exp, pel) ->
    let fresh = "n$"^(next ()) in
    let exptype = synth defns gamma types exp in
    let delta = [fresh] in
    let omega = [exptype] in
    let kstar =
      List.map
        (fun (p, e) ->
           ([p], e)) pel in
    let (gammanew, newmatch) = unwrap types delta omega kstar in
    let gamma = (gamma@gammanew) in
    (match newmatch with
    | MatchWith (e, pel) ->
      let expressiontype = synth defns ((fresh, exptype)::gamma) types e in
      let mappedlist =
        List.map
          (fun (p, e) ->
             let unwrappedexpressiontype = unroll_type (type_inst_converter types expressiontype) in
             match p, unwrappedexpressiontype with
             | (PairPat (VarPat v1, VarPat v2), Times(t1, t2)) -> (p, unwrap_exp defns types ((fresh, exptype)::(v1, t1)::(v2, t2)::gamma) t e)
             | (UnitPat, One) -> (p, unwrap_exp defns types ((fresh, exptype)::gamma) t e)
             | (InjPat (l, VarPat v), Plus ltl) -> (p, unwrap_exp defns types ((fresh, exptype)::(v, (contains ltl l))::gamma) t e)
             | (VarPat v, _) -> (p, unwrap_exp defns types ((fresh, exptype)::(v, expressiontype)::gamma) t e)
             | (ShiftPat (VarPat v), Down s) -> (p, unwrap_exp defns types ((fresh, exptype)::(v, s)::gamma) t e)
             | _ -> raise (UnnestError "Illegal pattern/breakdown")) pel in
      MatchWith (exp, [(VarPat fresh, MatchWith (Var fresh, mappedlist))])
    | _ -> MatchWith (e, [(VarPat fresh, newmatch)]))
  | Fun (vn, e) ->
    let t = unroll_type (type_inst_converter types t) in
    (match t with
     | Arrow (t1, t2) ->
       Fun (vn, unwrap_exp defns types ((vn, t1)::gamma) t2 e)
     | _ -> raise (UnnestError "ERROR3"))
  | Record lel ->
    let t = unroll_type (type_inst_converter types t) in
    (match t with
     | With ltl -> Record (List.map
                             (fun (l, e) ->
                                try
                                  let t = contains ltl l in
                                  (l, unwrap_exp defns types gamma t e)
                                with
                                | _ -> (l, e)) lel)
     | _ -> raise (UnnestError "ERROR4"))
  | Shift e ->
    let t = unroll_type (type_inst_converter types t) in
    (match t with
     | Down t -> Shift (unwrap_exp defns types gamma t e)
     | _ -> raise (UnnestError "SHIFT1 ERROR"))
  | Susp e ->
    let t = unroll_type (type_inst_converter types t) in
    (match t with
     | Up t -> Susp (unwrap_exp defns types gamma t e)
     | _ -> raise (UnnestError "SHIFT2 ERROR"))
  | Int i -> Int i
  | Add (e1, e2) -> Add (unwrap_exp defns types gamma Int32 e1, unwrap_exp defns types gamma Int32 e2)
  | Minus (e1, e2) -> Minus (unwrap_exp defns types gamma Int32 e1, unwrap_exp defns types gamma Int32 e2)
  | Div (e1, e2) -> Div (unwrap_exp defns types gamma Int32 e1, unwrap_exp defns types gamma Int32 e2)
  | Mult (e1, e2) -> Mult (unwrap_exp defns types gamma Int32 e1, unwrap_exp defns types gamma Int32 e2)
  | Eq (e1, e2) -> Eq (unwrap_exp defns types gamma Int32 e1, unwrap_exp defns types gamma Int32 e2)

let unnest (program : env) : env =
  let defns = exp_defns program in
  let types = tp_defns program in
  let rec inner (program : env) =
    match program with
    | [] -> []
    | (d::program) ->
      match d with
      | ExpDefn (a, pl, b, e) ->
        (ExpDefn (a, pl, b, unwrap_exp defns types pl b e))::(inner program)
      | _ -> d::(inner program)
  in
  inner program


