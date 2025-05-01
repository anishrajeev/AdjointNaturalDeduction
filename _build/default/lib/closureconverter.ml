type label = [%import: Saxast.label]
type tpname = [%import: Saxast.tpname]
type modename = [%import: Saxast.modename]
type mode = [%import: Saxast.mode]
type tp = [%import: Saxast.tp]
type varname = [%import: Saxast.varname]
type procname = [%import: Saxast.procname]
type pat = [%import: Saxast.pat]
type cmd = [%import: Saxast.cmd]
and storable = [%import: Saxast.storable]
type parm = [%import: Saxast.parm]
type defn = [%import: Saxast.defn]
type env =  [%import: Saxast.env]

type context = parm list
type tpdefn = tpname * (mode list) * tp
exception ClosureConversionError of string

let counter = ref 0
let increment () = counter := !counter + 1
let get_count () = !counter
let set_count (i : int) = counter := i
let next () : string = increment (); (string_of_int (get_count ()))

let rec types (program : env) : tpdefn list =
  match program with
  | [] -> []
  | (TypeDefn (tn, ml, t))::program -> (tn, ml, t)::(types program)
  | _::program -> types program

let rec contains_type (types : tpdefn list) (tn : tpname) : tpdefn =
  match types with
  | [] -> raise (ClosureConversionError ("Could not find type called " ^ tn))
  | (tn', ml, t)::types -> if tn = tn' then (tn, ml, t) else contains_type types tn

let rec mode_equality (m1 : mode) (m2 : mode) : bool =
  match (m1, m2) with
  | (ModeConst m1, ModeConst m2) -> m1 = m2
  | (ModeVar m1, ModeVar m2) -> m1 = m2
  | _ -> false

let rec get_mode (mm : (mode*mode) list) (m : mode) =
  match mm with
  | [] -> raise (ClosureConversionError ("Could not find mode"))
  | (m', m'')::mm -> if mode_equality m m' then m'' else get_mode mm m

let rec tp_converter (mm : (mode*mode) list) (t : tp) =
  match t with
  | Times (t1, t2) -> Times (tp_converter mm t1, tp_converter mm t2)
  | One -> One
  | Plus ltl -> Plus (List.map (fun (l, t) -> (l, tp_converter mm t)) ltl)
  | Arrow (t1, t2) -> Arrow (tp_converter mm t1, tp_converter mm t2)
  | With ltl -> With (List.map (fun (l, t) -> (l, tp_converter mm t)) ltl)
  | Down t -> Down (tp_converter mm t)
  | Up t -> Up (tp_converter mm t)
  | Flat (m, t) -> Flat (get_mode mm m, tp_converter mm t)
  | TpInst (tn, ml) -> TpInst (tn, List.map (get_mode mm) ml)
  | Int32 -> Int32

let rec type_inst_converter (types : tpdefn list) (t : tp) : tp =
  match t with
  | TpInst (tn, ml) ->
    let (_, tml, t) = contains_type types tn in
    let mode_map = List.combine tml ml in
    type_inst_converter types (tp_converter mode_map t)
  | Flat (_, t) -> type_inst_converter types t
  | _ -> t

let lattice (m1 : string) (m2 : string) : bool =
  match (m1, m2) with
  | ("U", "U") -> true
  | ("U", _) -> false
  | ("L", "L") -> true
  | (_, "L") -> false
  | ("A", "S") -> false
  | ("S", "A") -> false
  | _ -> true

let rec pp_mode (m : mode) =
  match m with
  | ModeConst m -> m
  | ModeVar m -> m
    
let rec what_mode (t : tp) : mode =
  match t with
  | Times (t1, _) -> what_mode t1
  | One -> ModeConst "U"
  | Plus ltl ->
    (match ltl with
     | (_, t)::_ -> what_mode t
     | _ -> raise (ClosureConversionError "Can't figure out the mode for a type"))
  | Arrow (t1, _) -> what_mode t1
  | With ltl -> 
    (match ltl with
     | (_, t)::_ -> what_mode t
     | _ -> raise (ClosureConversionError "Can't figure out the mode for a type"))
  | Down t -> 
    let x = pp_mode (what_mode t) in
    if lattice "U" x then  ModeConst "U" else (raise (ClosureConversionError (x ^ " not :> U")))
  | Up _ -> ModeConst "U"
  | Flat (mode, _) -> mode
  | TpInst (_, ml) -> List.nth ml 0
  | Int32 -> ModeConst "U"

let rec unroll_type (t : tp) : tp =
  match t with
  | Flat (_, t) -> unroll_type t
  | _ -> t

let rec contains (gamma : context) (x : varname) : tp =
  match gamma with
  | [] -> raise (ClosureConversionError ("Can't find " ^ x ^ " in context"))
  | (x', t)::gamma -> if x = x' then t else contains gamma x

let rec remove (c : context) (v : varname) : context =
  let rec inner (c : context) (v : varname) (acc : context) : context =
    match c with
    | [] -> acc
    | (v', t)::c -> if v' = v then List.append acc c else inner c v ((v', t)::acc)
  in
  inner c v []

let rec join (c1 : context) (c2 : context) : context =
  let rec inner (c1 : context) (c2 : context) (acc : context) : context = 
    match (c1, c2) with
    | ([], []) -> acc
    | ([], c2) -> List.append c2 acc
    | (c1, []) -> List.append c1 acc
    | ((v, t)::c1, c2) ->
      inner c1 (remove c2 v) ((v, t)::acc)
  in
  inner c1 c2 []

let rec print_context (c : context) : string =
  match c with
  | [] -> "DONE"
  | ((x, t)::c) ->
    (x ^ " : " ^ (Saxast.Print.pp_tp t) ^ "\n" ^ (print_context c))

let rec convert_cmd (types : tpdefn list) (gamma : context) (pname : procname) (desttp : tp) (c : cmd) : cmd * context * env =
  let find = contains gamma in
  match c with
  | Read (vn, s) ->
    (match s with
     | Small (PairPat (x, _)) ->  (c, [(x, find x); (vn, find vn)], [])
     | Small _ -> (c, [(vn, find vn)], [])
     | Branches pcl ->
       let tp = unroll_type (type_inst_converter types (find vn)) in
       let ((sigma, e), npcl) = 
       List.fold_left_map
         (fun (sigma, e) -> fun (p, c) ->
            match p with
            | PairPat (v1, v2) ->
              let (t1, t2) = (match tp with | Times (t1, t2) -> (t1, t2) | _ -> raise (ClosureConversionError "Reading error1")) in
              let (c', sigma', e') = convert_cmd types ((v1, t1)::(v2, t2)::gamma) pname desttp c in
              ((join sigma (remove (remove sigma' v1) v2), e @ e'), (p, c'))
            | UnitPat ->
              let (c', sigma', e') = convert_cmd types gamma pname desttp c in
              ((join sigma sigma', e @ e'), (p, c'))
            | InjPat (l, v) ->
              let ltl = (match tp with | Plus ltl -> ltl | _ -> raise (ClosureConversionError "Reading error2")) in
              let t = contains ltl l in
              let (c', sigma', e') = convert_cmd types ((v, t)::gamma) pname desttp c in
              ((join sigma (remove sigma' v), e @ e'), (p, c'))
              
            | ShiftPat v ->
              let t = (match tp with | Down t -> t | _ -> raise (ClosureConversionError "Reading error2")) in
              let (c', sigma', e') = convert_cmd types ((v, t)::gamma) pname desttp c in
              ((join sigma (remove sigma' v), e @ e'), (p, c'))
              
            | VarPat v ->
              let (c', sigma', e') = convert_cmd types ((v, tp)::gamma) pname desttp c in
              ((join sigma (remove sigma' v), e @ e'), (p, c'))) ([], []) pcl
       in
       (Read (vn, Branches npcl), join [(vn, find vn)] sigma, e))
  | Write (vn, s) ->
    (match s with
    | Small (PairPat (v1, v2)) -> (c, [(v1, find v1); (v2, find v2)], [])
    | Small UnitPat -> (c, [], [])
    | Small (InjPat (_, v)) -> (c, [(v, find v)], [])
    | Small (ShiftPat v) -> (c, [(v, find v)], [])
    | Small (VarPat v) -> (c, [(v, find v)], [])
    | Branches ([PairPat (p, d), c]) ->
      let fresh_name = pname ^ "_" ^ (next ()) in
      let unrolled_tp = type_inst_converter types (unroll_type desttp) in
      let (pt, dt) = (match unrolled_tp with | Arrow (t1, t2) -> (t1, t2) | _ -> raise (ClosureConversionError "Type error1")) in
      let num = get_count () in
      let () = set_count 0 in
      let (c', sigma, e) = convert_cmd types ((p, pt)::gamma) fresh_name dt c in
      let sigma' = remove sigma p in
      let () = set_count num in
      let procd = ProcDefn (fresh_name, ("d$0", desttp), sigma', Write ("d$0", Branches [(PairPat (p, d), c')])) in
      (Call (fresh_name, vn, List.map (fun (v, _) -> v) sigma'), sigma', procd::e)
    | Branches [(ShiftPat v, c)] ->
      let unrolled_tp = type_inst_converter types (unroll_type desttp) in
      let innertp = (match unrolled_tp with | Up t -> t | _ -> raise (ClosureConversionError "Type error1.5")) in
      let fresh_name = pname ^ "_" ^ (next ()) in
      let num = get_count () in
      let () = set_count 0 in
      let (c', sigma, e) = convert_cmd types gamma fresh_name innertp c in
      let sigma' = remove sigma v in
      let procd = ProcDefn (fresh_name, ("d$0", desttp), sigma', Write ("d$0", Branches [(ShiftPat v, c')])) in
      let () = set_count num in
      (Call (fresh_name, vn, List.map (fun (v, _) -> v) sigma'), sigma', procd::e)
      
    | Branches pcl ->
      let unrolled_tp = type_inst_converter types (unroll_type desttp) in
      let ltl = (match unrolled_tp with | With ltl -> ltl | _ -> raise (ClosureConversionError "Type error2")) in
      let fresh_name = pname ^ "_" ^ (next ()) in
      let ((sigma, e), npcl) = List.fold_left_map
          (fun (sigma, e) -> fun (p, c) ->
             match p with
            | InjPat (l, d) ->
               let t = contains ltl l in
               let (c', sigma', e') = convert_cmd types ((d, t)::gamma) fresh_name t c in
               ((join sigma (remove sigma' d), List.append e e'), (InjPat (l, d), c'))
             | _ -> raise (ClosureConversionError "Type error3")) ([], []) pcl
      in
      let procd = ProcDefn (fresh_name, ("d$0", desttp), sigma, Write ("d$0", Branches npcl)) in
      (Call (fresh_name, vn, List.map (fun (v, _) -> v) sigma), sigma, procd::e))      
  | Cut (vn, t, p, q) ->
    let (p', sigma1, e1) = convert_cmd types gamma pname t p in
    let (q', sigma2, e2) = convert_cmd types ((vn, t)::gamma) pname desttp q in
    (Cut (vn, t, p', q'), join sigma1 (remove sigma2 vn), List.append e1 e2)
  | Id (_, v2) -> (c, [(v2, find v2)], [])
  | Call (_, _, pl) -> (c, List.map (fun v -> (v, find v)) pl, [])
  | Add (_, x, y) -> (c, [(x, find x); (y, find y)], [])
  | Minus (_, x, y) -> (c, [(x, find x); (y, find y)], [])
  | Div (_, x, y) -> (c, [(x, find x); (y, find y)], [])
  | Mult (_, x, y) -> (c, [(x, find x); (y, find y)], [])
  | Eq (_, x, y) -> (c, [(x, find x); (y, find y)], [])
  | Set (_, _) -> (c, [], [])

let convert_program (program : env) : env =
  let types = types program in
  let rec inner (program : env) (acc : env) : env =
    match program with
    | [] -> acc
    | (ProcDefn (pn, (dest, desttp), pl, c))::program ->
      let () = set_count 0 in
      (match c with
       | Write (_, s) ->
         (match s with
          | Small _ ->
            let (c', _, e) = convert_cmd types pl pn desttp c in
            let pd = ProcDefn (pn, (dest, desttp), pl, c') in
            inner program (acc @ (pd::e))
          | Branches [(PairPat (p, d), c)] ->
            let dt = type_inst_converter types (unroll_type desttp) in
            let (pt, dt) = (match dt with | Arrow (t1, t2) -> (t1, t2) | _ -> raise (ClosureConversionError "Type Error4")) in
            let (c', _, e) = convert_cmd types ((p, pt)::pl) pn dt c in
            let pd = ProcDefn (pn, (dest, desttp), pl, Write (dest, Branches [(PairPat (p, d), c')])) in
            inner program (acc @ (pd::e))
              
          | Branches [(ShiftPat v, c)] ->
            let innertp = type_inst_converter types (unroll_type desttp) in
            let innertp = (match innertp with | Up t -> t | _ -> raise (ClosureConversionError "Type Error4.5")) in
            let (c', _, e) = convert_cmd types ((v, innertp)::pl) pn innertp c in
            let pd = ProcDefn (pn, (dest, desttp), pl, Write (dest, Branches [(ShiftPat v, c')])) in
            inner program (acc @ (pd::e))
          | Branches pcl ->
            let ltl = (match (type_inst_converter types (unroll_type desttp)) with | With ltl -> ltl | _ -> raise (ClosureConversionError "Type Error5")) in
            let (e, npcl) =
              List.fold_left_map
                (fun acc -> fun (p, c) ->
                   match p with
                   | InjPat (l, x) ->
                     let dt = contains ltl l in
                     let (c', _, e) = convert_cmd types pl pn dt c in
                     (acc @ e, (InjPat (l, x), c'))
                   | _ -> raise (ClosureConversionError "Type Error6")) [] pcl
            in
            let pd = ProcDefn (pn, (dest, desttp), pl, Write (dest, Branches npcl)) in
            inner program (acc @ (pd::e)))
       | _ ->
         let (c', _, e) = convert_cmd types pl pn desttp c in
         let pd = ProcDefn (pn, (dest, desttp), pl, c') in
         inner program ((pd::e) @ acc))
    | d::program -> inner program (acc @ [d])
  in
  inner program []
  
