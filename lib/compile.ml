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

module S = Saxast

exception CompileError of string

type context = parm list

type tpdefn = tpname * (mode list) * tp
type expdefn = expname * context * tp * exp
type instdefn = expname * (tp list) * tp

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

let counter = ref 0
let increment () = counter := !counter + 1
let get_count () = !counter

let next () =
  increment();
  (string_of_int (get_count()))

let rec contains (c : context) (v : string) : tp =
  match c with
  | ((v', t)::c) -> if v = v' then t else contains c v
  | [] -> raise (CompileError ("Can't find " ^ v ^ " in the given context"))

let rec contains_type (types : tpdefn list) (t : tpname) : (mode list)*tp =
  match types with
  | (tn, ml, tp)::types -> if t = tn then (ml, tp) else (contains_type types t)
  | [] -> raise (CompileError ("Could not find type " ^ t))

let rec contains_mode (modemap : (mode*mode) list) (m : mode) : mode =
  match (m, modemap) with
  | (ModeVar ms, ((ModeVar ma, mc)::modemap)) -> if ms = ma then mc else contains_mode modemap m
  | _ -> raise (CompileError "Mode never existed in the given mode map")

let translate_mode (ndm : mode) : S.mode =
  match ndm with
  | ModeConst m -> S.ModeConst m
  | ModeVar m -> S.ModeVar m

let rec translate_tp (ndtp : tp) : S.tp =
  match ndtp with
  | Times (t1, t2) -> S.Times (translate_tp t1, translate_tp t2)
  | One -> S.One
  | Plus ltl ->
    S.Plus
      (List.map (fun (l, t) -> (l, translate_tp t)) ltl)
  | Arrow (t1, t2) -> S.Arrow (translate_tp t1, translate_tp t2)
  | With ltl -> S.With (List.map (fun (l, t) -> (l, translate_tp t)) ltl)
  | Down t -> S.Down (translate_tp t)
  | Up t -> S.Up (translate_tp t)
  | Flat (m, t) -> S.Flat (translate_mode m, translate_tp t)
  | TpInst (t, ml) -> S.TpInst (t, List.map translate_mode ml)
  | Int32 -> S.Int32

let rec mode_unroller (t : tp) : tp =
  match t with
  | Flat (_, t) -> t
  | _ -> t

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
       | _ -> raise (CompileError "Ultraspecific error #1(more like a static error)"))
    | TpInst (tn, ml) ->
      TpInst (tn, List.map (fun m -> contains_mode modemap m) ml)
    | Int32 -> Int32
  in
  match t with
  | TpInst (tn, ml) ->
    let (mp, tp) = contains_type types tn in
    inner tp (List.combine mp ml)
  | _ -> t

let rec find_defn (defns : expdefn list) (fn : expname) : expdefn =
  match defns with
  | [] -> raise (CompileError ("The definition " ^ fn  ^ " never existed in the top level definitions"))
  | (en, ctx, tp, exp)::defns -> if fn = en then (en, ctx, tp, exp) else find_defn defns fn

let rec what_mode (t : tp) : mode =
  let lattice (m1 : string) (m2 : string) : bool =
    match (m1, m2) with
    | ("U", "U") -> true
    | ("U", _) -> false
    | ("L", "L") -> true
    | (_, "L") -> false
    | ("A", "S") -> false
    | ("S", "A") -> false
    | _ -> true
  in
  match t with
  | Times (t1, _) -> what_mode t1
  | One -> ModeConst "U"
  | Plus ltl ->
    (match ltl with
     | (_, t)::_ -> what_mode t
     | _ -> raise (CompileError "Can't figure out the mode for a type"))
  | Arrow (t1, _) -> what_mode t1
  | With ltl ->
    (match ltl with
     | (_, t)::_ -> what_mode t
     | _ -> raise (CompileError "Can't figure out the mode for a type"))
  | Down t ->
    let x = Ast.Print.pp_mode (what_mode t) in
    if lattice "U" x then  ModeConst "U" else (raise (CompileError (x ^ " not :> U")))
  | Up _ -> ModeConst "U"
  | Flat (mode, _) -> mode
  | TpInst (_, ml) -> List.nth ml 0
  | Int32 -> ModeConst "U"

(*returns a type, could be flat or TpInst*)
let rec synthesize (defns : expdefn list) (gamma : context) (types : tpdefn list) (e : exp) : tp =
  match e with
  | Var vn ->
    (try  contains gamma vn
     with
     | _ -> let (_, _, t, _) = find_defn defns vn in t)
  | Pair (e1, e2) -> Times ((synthesize defns gamma types e1), (synthesize defns gamma types e2))
  | Unit -> One
  | Inj (_, _) -> raise (CompileError "Can't synthesize a sum")
  | MatchWith (_, _) -> raise (CompileError "Can't synthesize a match")
  | Call (vn, spine) ->
    let rec spine_crusher (t : tp) (spine : atom list) : tp =
      let regulart = t in
      let t = mode_unroller (type_inst_converter types (mode_unroller t)) in
      (match spine with
       | [] -> regulart
       | vert::spine ->
         match (vert, t) with
         | (Exp _, Arrow (_, t2)) -> spine_crusher t2 spine
         | (Dot l, With ltl) ->
           spine_crusher (contains ltl l) spine
         | (Force, Up t) -> spine_crusher t spine
         | _ -> raise (CompileError "Spine Crushing error in synth"))
    in
    spine_crusher (contains gamma vn) spine
  | Fun _ -> raise (CompileError "Can't synthesize an anon function")
  | Record _ -> raise (CompileError "Can't synthesize a record")
  | Shift _ -> raise (CompileError "Can't synthesize a downshift")
  | Susp _ -> raise (CompileError "Can't synthesize an upshift")
  | Int i -> raise (CompileError "Can't synthesize a raw integer, mode is ambiguous")
  | Add (e, _) ->
    let m = what_mode (synthesize defns gamma types e) in
    Flat (m, Int32)
  | Minus (e, _) ->
    let m = what_mode (synthesize defns gamma types e) in
    Flat (m, Int32)
  | Div (e, _) ->
    let m = what_mode (synthesize defns gamma types e) in
    Flat (m, Int32)
  | Mult (e, _) ->
    let m = what_mode (synthesize defns gamma types e) in
    Flat (m, Int32)
  | Eq (e, _) ->
    let m = what_mode (synthesize defns gamma types e) in
    Flat (m, Plus [("'true", Flat (m, One)); ("'false", Flat (m, One))])

let rec dress_up (t : tp) : tp =
  match t with
  | Flat (m, t) -> Flat (m, t)
  | TpInst _ -> t
  | _ -> Flat (what_mode t, t)

let rec translate_exp (types : tpdefn list) (defns : expdefn list) (inst_defns : instdefn list)(gamma : context) (dest : string) (desttp : tp) (e : exp) : S.cmd =
  match e with
  | Var v ->
    (try
       let _ = contains gamma v in
       S.Id (dest, v)
    with
    | _ ->
      let _ = find_defn defns v in
      translate_exp types defns inst_defns gamma dest desttp (Call (v, [])))
  | Pair (e1, e2) ->
    let unrolleddesttp = mode_unroller (type_inst_converter types (mode_unroller desttp)) in
    let (t1, t2) = (match unrolleddesttp with | Times (t1, t2) -> (t1, t2) | _ -> raise (CompileError "Type error")) in
    let firstfresh = "s$"^(next ()) in
    let secondfresh = "s$"^(next ()) in
    S.Cut (firstfresh, translate_tp (dress_up t1),
           (translate_exp types defns inst_defns gamma firstfresh t1 e1),
           (S.Cut
              (secondfresh, translate_tp (dress_up t2),
               (translate_exp types defns inst_defns gamma secondfresh t2 e2),
               S.Write (dest, Small (PairPat (firstfresh, secondfresh))))))
  | Unit -> S.Write (dest, Small UnitPat)
  | Inj (lab, e) ->
    let unrolleddesttp = mode_unroller (type_inst_converter types (mode_unroller desttp)) in
    let ltl = (match unrolleddesttp with | Plus ltl -> ltl | _ -> raise (CompileError "Typing Error1")) in
    let al = contains ltl lab in
    let als = translate_tp (dress_up al) in
    let fresh = "s$"^(next ()) in
    S.Cut (fresh, als, translate_exp types defns inst_defns gamma fresh al e, S.Write (dest, Small (InjPat (lab, fresh))))
  | MatchWith (e, pel) ->
    let synth = synthesize defns gamma types e in
    let unrolledsynth = mode_unroller (type_inst_converter types (mode_unroller synth)) in
    (match unrolledsynth with
     | Times (t1, t2) ->
       (match pel with
        | (PairPat (VarPat v1, VarPat v2), branch)::[] ->
          let fresh = "s$"^(next ()) in
          let times = translate_tp (dress_up (Times (t1, t2))) in
          let etrans = translate_exp types defns inst_defns gamma fresh (Times (t1, t2)) e in
          let branchtrans = translate_exp types defns inst_defns ((v1, t1)::(v2, t2)::gamma) dest desttp branch in
          S.Cut (fresh, times, etrans, S.Read (fresh, Branches [S.PairPat (v1, v2), branchtrans]))
        | (VarPat v, branch)::[] ->
          let fresh = "s$"^(next ()) in
          let etrans = translate_exp types defns inst_defns gamma fresh (Times (t1, t2)) e in
          let times = translate_tp (dress_up (Times (t1, t2))) in
          let branchtrans = translate_exp types defns inst_defns ((v, Times (t1, t2))::gamma) dest desttp branch in
          S.Cut (fresh, times, etrans,
                 S.Cut(v, times, S.Id (v, fresh), branchtrans))
        | _ -> raise (CompileError "You have tried deconstructing a product type with not a proper branch!"))
     | One -> 
       (match pel with
        | (UnitPat, ep)::[] ->
          let fresh = "s$"^(next ()) in
          S.Cut(fresh, translate_tp synth, translate_exp types defns inst_defns gamma fresh (dress_up synth) e,
                S.Read (fresh, Branches [(S.UnitPat, translate_exp types defns inst_defns gamma dest desttp ep)]))
        | (VarPat v, branch)::[] ->
          let fresh = "s$"^(next ()) in
          let etrans = translate_exp types defns inst_defns gamma fresh (dress_up synth) e in
          let branchtrans = translate_exp types defns inst_defns ((v, (dress_up synth))::gamma) dest desttp branch in
          S.Cut (fresh, translate_tp synth, etrans,
                 S.Cut(v, translate_tp synth, S.Id (v, fresh), branchtrans))
        | _ -> raise (CompileError "You tried having more patterns than just the unit when deconstructing unit type!"))
     | Plus ltl ->
       let sltl = translate_tp (dress_up (Plus ltl)) in
       let fresh = "s$"^(next ()) in
       let etrans = translate_exp types defns inst_defns gamma fresh (Plus ltl) e in
       (match pel with
        | (VarPat v, branch)::[] ->
          let branchtrans = translate_exp types defns inst_defns ((v, Plus ltl)::gamma) dest desttp branch in
          S.Cut (fresh, sltl, etrans,
                 S.Cut(v, sltl, S.Id (v, fresh), branchtrans))
        | _ ->
          let branchtranses =
            List.filter_map
              (fun (patt, branche) ->
                 match (patt, branche) with
                 | (InjPat (l, VarPat v), branche) ->
                   (try
                   let al = contains ltl l in
                   let branchtrans = translate_exp types defns inst_defns ((v, al)::gamma) dest desttp branche in
                   Some (S.InjPat (l, v), branchtrans)
                    with
                    | CompileError x ->
                      if x = ("Can't find " ^ l ^ " in the given context") then None
                      else raise (CompileError x)
                   )
                 | (_, _) ->
                   raise (CompileError "Tried deconstructing a sum type using non labels!")) pel in
          S.Cut (fresh, sltl, etrans, S.Read (fresh, Branches branchtranses)))
     | Arrow (_, _) ->
       (match pel with
        | (VarPat v, branch)::[] ->
          S.Cut (v, translate_tp (dress_up synth), translate_exp types defns inst_defns gamma v synth e,
                 translate_exp types defns inst_defns ((v, synth)::gamma) dest desttp branch)
        | _ -> raise (CompileError "Can't match a func type against anything but a var"))
     | With _ ->
       (match pel with
        | (VarPat v, branch)::[] ->
          S.Cut (v, translate_tp (dress_up synth), translate_exp types defns inst_defns gamma v synth e,
                 translate_exp types defns inst_defns ((v, synth)::gamma) dest desttp branch)
        | _ -> raise (CompileError "Can't match a record type against anything but a var"))
     | Down t ->
       (match pel with
        | (ShiftPat (VarPat v), branch)::[] ->
          let fresh = "s$"^(next ()) in
          let etrans = translate_exp types defns inst_defns gamma fresh (Down t) e in
          let branchtrans = translate_exp types defns inst_defns ((v, t)::gamma) dest desttp branch in
          S.Cut (fresh, translate_tp (dress_up synth), etrans, S.Read (fresh, Branches [S.ShiftPat v, branchtrans]))
        | (VarPat v, branch)::[] ->
          S.Cut (v, translate_tp (dress_up synth), translate_exp types defns inst_defns gamma v synth e,
                 translate_exp types defns inst_defns ((v, synth)::gamma) dest desttp branch)
        | _ -> raise (CompileError "Can't match a downshift against anything but a variable or a shiftpat"))
     | Up _ ->
       (match pel with
        | (VarPat v, branch)::[] ->
          S.Cut (v, translate_tp (dress_up synth), translate_exp types defns inst_defns gamma v synth e,
                 translate_exp types defns inst_defns ((v, synth)::gamma) dest desttp branch)
        | _ -> raise (CompileError "Can't match an upshift against anything but a var"))
     | Int32 ->
       (match pel with
        | (VarPat v, branch)::[] ->
          S.Cut (v, translate_tp (dress_up synth), translate_exp types defns inst_defns gamma v synth e,
                 translate_exp types defns inst_defns ((v, synth)::gamma) dest desttp branch)
        | _ -> raise (CompileError "Can't match an integer against anything but a var"))
     | _ -> raise (CompileError "Typing error 2 dirty type"))
  | Call (vn, spine) ->
    let rec spine_crusher (spine : atom list) (t : tp) (source : varname) =
      let unrolledt = mode_unroller (type_inst_converter types (mode_unroller t)) in
      (match (spine, unrolledt) with
       | ([], _) -> S.Id (dest, source)
       | ((Exp e)::spine, Arrow (t1, t2)) ->
         let fresh1 = "s$"^(next()) in
         let fresh2 = "s$"^(next()) in
         S.Cut (fresh1, translate_tp (dress_up t1), translate_exp types defns inst_defns gamma fresh1 t1 e,
                S.Cut (fresh2, translate_tp (dress_up t2), S.Read (source, Small (PairPat (fresh1, fresh2))), spine_crusher spine t2 fresh2))
       | ((Dot l)::spine, With ltl) ->
         let t = contains ltl l in
         let fresh = "s$"^(next ()) in
         S.Cut (fresh, translate_tp (dress_up t), S.Read (source, Small (InjPat (l, fresh))), spine_crusher spine t fresh)
       | (Force::spine, Up t) ->
         let fresh = "s$"^(next ()) in
         S.Cut (fresh, translate_tp (dress_up t), S.Read (source, Small (ShiftPat fresh)), spine_crusher spine t fresh)
       | _ ->
         raise (CompileError "Typing Error3"))
    in
    (try
       let t = contains gamma vn in
       spine_crusher spine t vn
    with
    | CompileError _ ->
      let rec target_type_gen (t : tp) (spine : atom list) : tp option =
        match spine with
        | [] -> Some t
        | vert::spine ->
          let t = mode_unroller (type_inst_converter types t) in
          (match (vert, t) with
             | (Exp _, Arrow (_, t2)) -> target_type_gen t2 spine
             | (Dot l, With ltl) -> target_type_gen (contains ltl l) spine
             | (Force, Up t) -> target_type_gen t spine
             | _ -> None)
      in
      let rec get_top_n (a : atom list) (n : int) =
        match (a, n) with
        | (_, 0) -> []
        | ((Exp e)::xs, n) -> e::(get_top_n xs (n-1))
        | _ -> raise (CompileError "Couldn't get that many expression elements off of atom list")
      in
      let rec remove_top_n (a : atom list) (n : int) =
        match (a, n) with
        | (xs, 0) -> xs
        | (_::xs, n) -> remove_top_n xs (n-1)
        | _ -> raise (CompileError "Couldn't get that many elements off of atom list") in
      let (_, pl, _, _) = find_defn defns vn in
      let head = get_top_n spine (List.length pl) in
      let spine = remove_top_n spine (List.length pl) in
      let filtered_list = List.filter (fun (v, tl, t) -> v = vn) inst_defns in
      let vn = List.find_mapi
          (fun i -> fun (v, tl, t) ->
             if not (vn = v) then None else
             match target_type_gen t spine with
             | None -> None
             | Some tt ->  if (Ndtypecheck.type_subtype types tt desttp) then Some (vn^"$"^(string_of_int i), tl, t) else None) filtered_list in
      let (pn, tl, rt) = (match vn with | Some x -> x | None -> raise (CompileError "Could not find a good instance")) in
      let fresh = "s$"^(next ()) in
      let suffix = spine_crusher spine rt fresh in
      let rec finisher (used : exp list) (tl : tp list) (acc : string list) =
        match (used, tl) with
        | ([], []) -> S.Cut (fresh, translate_tp (dress_up rt), S.Call (pn, fresh, List.rev acc), suffix)
        | (e::used, t::tl) ->
          let freshn = "s$"^(next ()) in
          S.Cut (freshn, translate_tp (dress_up t), translate_exp types defns inst_defns gamma freshn t e, finisher used tl (freshn::acc))
        | _ -> raise (CompileError "SRSERROR")
      in
      finisher head tl []
   )
  | Fun (vn, e) ->
    let desttp = mode_unroller (type_inst_converter types (mode_unroller desttp)) in
    (match desttp with
    | Arrow (t1, t2) ->
      let fresh =  "s$"^(next ()) in
      S.Write (dest, (S.Branches [S.PairPat (vn, fresh), translate_exp types defns inst_defns ((vn, t1)::gamma) fresh t2 e]))
    | _ -> raise (CompileError "Typing Error4"))
  | Record lel ->
    let desttp = mode_unroller (type_inst_converter types (mode_unroller desttp)) in
    (match desttp with
     | With ltl ->
       let branches =
         List.filter_map
           (fun (lab, e) ->
              let fresh = "s$"^(next ()) in
              try
                let tp = contains ltl lab in
                Some (S.InjPat (lab, fresh), translate_exp types defns inst_defns gamma fresh tp e)
              with
              | _ -> None
           ) lel in
       S.Write (dest, S.Branches branches)
     | _ -> raise (CompileError "Typing Error5"))
  | Shift e ->
    let desttp = type_inst_converter types (mode_unroller desttp) in
    let unrolleddesttp = mode_unroller desttp in
    let desttp = (match unrolleddesttp with | Down t -> t | _ -> raise (CompileError "Typing Error 6")) in
    let fresh = "s$"^(next ()) in
    let trans_cmd = translate_exp types defns inst_defns gamma fresh desttp e in
    S.Cut (fresh, translate_tp (dress_up desttp), trans_cmd, S.Write (dest, Small (ShiftPat fresh)))
  | Susp e ->
    let desttp = type_inst_converter types (mode_unroller desttp) in
    let unrolleddesttp = mode_unroller desttp in
    let desttp = (match unrolleddesttp with | Up t -> t | _ -> raise (CompileError "Typing Error 6")) in
    let fresh = "s$"^(next ()) in
    let trans_cmd = translate_exp types defns inst_defns gamma fresh desttp e in
    S.Write (dest, Branches [(ShiftPat fresh, trans_cmd)])
  | Int i -> S.Set (dest, i)
  | Add (e1, e2) ->
    let fresh1 = "s$"^(next ()) in
    let fresh2 = "s$"^(next ()) in
    translate_arith e1 e2 types defns inst_defns gamma fresh1 fresh2 (S.Add (dest, fresh1, fresh2)) desttp
  | Minus (e1, e2) ->
    let fresh1 = "s$"^(next ()) in
    let fresh2 = "s$"^(next ()) in
    translate_arith e1 e2 types defns inst_defns gamma fresh1 fresh2 (S.Minus (dest, fresh1, fresh2)) desttp
  | Div (e1, e2) ->
    let fresh1 = "s$"^(next ()) in
    let fresh2 = "s$"^(next ()) in
    translate_arith e1 e2 types defns inst_defns gamma fresh1 fresh2 (S.Div (dest, fresh1, fresh2)) desttp
  | Mult (e1, e2) ->
    let fresh1 = "s$"^(next ()) in
    let fresh2 = "s$"^(next ()) in
    translate_arith e1 e2 types defns inst_defns gamma fresh1 fresh2 (S.Mult (dest, fresh1, fresh2)) desttp
  | Eq (e1, e2) ->
    let fresh1 = "s$"^(next ()) in
    let fresh2 = "s$"^(next ()) in
    translate_arith e1 e2 types defns inst_defns gamma fresh1 fresh2 (S.Eq (dest, fresh1, fresh2)) desttp
      
and translate_arith (e1 : exp) (e2 : exp) (types : tpdefn list) (defns : expdefn list) (inst_defns : instdefn list) (gamma : context)
    (fresh1 : string) (fresh2 : string) (final : S.cmd) (desttp : tp) : S.cmd =
    let m = what_mode desttp in
    let dtp = Flat (m, Int32) in
    let trans1 = translate_exp types defns inst_defns gamma fresh1 dtp e1 in
    let trans2 = translate_exp types defns inst_defns gamma fresh2 dtp e2 in
    S.Cut (fresh1, translate_tp dtp, trans1, S.Cut (fresh2, translate_tp dtp, trans2, final))
    
    
    
    
let translate_defn (types : tpdefn list) (inst_defns : instdefn list) (defns : expdefn list) (d : defn) : S.defn list =
  match d with
  | TypeDefn (tn, ml, t) -> [S.TypeDefn (tn, List.map translate_mode ml, translate_tp t)]
  | ExpDefn (en, pl, _, e) ->
    let fresh = "s$"^(next ()) in
    let insts = List.filter (fun (i, _, _) -> if en = i then true else false) inst_defns in
    List.mapi (
      fun i -> fun (_, tl, rt) ->
        
        let npl = List.map (fun ((par, _), t) -> (par, t)) (List.combine pl tl) in
        let procname = en ^ "$" ^ (string_of_int i) in
        S.ProcDefn (procname, (fresh, translate_tp rt), List.map (fun (v, t) -> (v, translate_tp t)) npl, translate_exp types defns inst_defns npl fresh rt e)
    ) insts
  | InstDefn _ -> []


let translate_program (program : env) : S.env =
  let types = tp_defns program in
  let defns = exp_defns program in
  let inst_defns = inst_defns program in
  let mapped = List.map (translate_defn types inst_defns defns) program in
  List.fold_right (fun x -> fun acc -> x@acc) mapped []
