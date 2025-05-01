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

exception CError of string

let header : string = "#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <sys/mman.h>\n#include <locale.h>\n\n"
let setup : string = "typedef union value* addr;\n\ntypedef union value {\n  tag  tag;\n  addr ptr;\n  addr env;\n  void(*fun)(addr arg, addr env);\n int32_t i;\n } value;\n\nstatic void* heap;\nstatic unsigned long alloc_count;\nstatic unsigned long alloc_size;\n\nvoid init_heap(size_t total_size) {\n  heap = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);\n  if (heap == MAP_FAILED) {\n    printf(\"mmap failed\");\n    exit(EXIT_FAILURE);\n  }\n}\n\naddr alloc(int n) {\n  void* prev = heap;\n  heap = heap + n * sizeof(value);\n  alloc_count++;\n  alloc_size += n;\n  return (addr)prev;\n}\n\nvoid invoke_closure_fun (addr a, addr b, addr c) {\n  addr arg = alloca(2 * sizeof(value));\n  arg->ptr = b;\n  (arg+1)->ptr = c;\n  (a->fun)(arg, (a+1)->env);\n}\n\nvoid invoke_closure_susp (addr a, addr b) {\n  addr arg = alloca(1 * sizeof(value));\n  arg->ptr = b;\n  (a->fun)(arg, (a+1)->env);\n}\n\nvoid invoke_closure_record (addr a, tag k, addr b) {\n  addr arg = alloca(2 * sizeof(value));\n  arg->tag = k;\n  (arg+1)->ptr = b;\n  (a->fun)(arg, (a+1)->env);\n}\n\n\n"

let rec types (program : env) : tpdefn list =
  match program with
  | [] -> []
  | (TypeDefn (tn, ml, t))::program -> (tn, ml, t)::(types program)
  | _::program -> types program

let rec get_val_types (program : env) : (procname * tp) list =
  let rec inner (program : env) (acc : (procname * tp) list) : (procname * tp) list =
    match program with
    | [] -> acc
    | ProcDefn (pn, (_, dt), pl, _)::program ->
      if List.length pl = 0 then inner program ((pn, dt)::acc) else inner program acc
    | _::program -> inner program acc
  in
  inner program []

let rec get_tags (program : env) : label list =
  let rec get_labels_tp (t : tp) : label list =
    match t with
    | Times (t1, t2) -> get_labels_tp t1 @ get_labels_tp t2
    | One -> []
    | Plus ltl -> List.fold_left (fun acc -> fun (l, t) -> (l::(get_labels_tp t)) @ acc) [] ltl
    | Arrow (t1, t2) -> get_labels_tp t1 @ get_labels_tp t2
    | With ltl -> List.fold_left (fun acc -> fun (l, t) -> (l::(get_labels_tp t)) @ acc) [] ltl
    | Down t -> get_labels_tp t
    | Up t -> get_labels_tp t
    | Flat (_, t) -> get_labels_tp t
    | _ -> []
  in
  let rec get_labels_cmd (c : cmd) : label list =
    match c with
    | Read (_, Branches pcl) -> List.fold_left (fun acc -> fun (_, c) -> acc @ get_labels_cmd c) [] pcl
    | Write (_, Branches pcl) -> List.fold_left (fun acc -> fun (_, c) -> acc @ get_labels_cmd c) [] pcl
    | Cut (_, t, c1, c2) -> get_labels_tp t @ get_labels_cmd c1 @ get_labels_cmd c2
    | _ -> []
  in
  let rec inner (program : env) (acc : label list) =
    match program with
    | [] ->
      acc
    | TypeDefn (_, _, t)::program ->
      inner program (get_labels_tp t @ acc)
    | ProcDefn (_, (_, dt), pl, c)::program ->
      let dls = get_labels_tp dt in
      let pls = List.fold_left (fun acc -> fun (_, t) -> get_labels_tp t @ acc) [] pl in
      let cls = get_labels_cmd c in
      inner program (dls @ pls @ cls @ acc)
    | ClosDefn (_, (_, dt), pl, c)::program ->
      let dls = get_labels_tp dt in
      let pls = List.fold_left (fun acc -> fun (_, t) -> get_labels_tp t @ acc) [] pl in
      let cls = get_labels_cmd c in
      inner program (dls @ pls @ cls @ acc)
    | _ -> inner program acc
  in
  List.sort_uniq String.compare (inner program ["'true" ; "'false"])

let rec contains_type (types : tpdefn list) (tn : tpname) : tpdefn =
  match types with
  | [] -> raise (CError ("Could not find type called " ^ tn))
  | (tn', ml, t)::types -> if tn = tn' then (tn, ml, t) else contains_type types tn

let rec type_inst_converter (types : tpdefn list) (t : tp) : tp =
  match t with
  | TpInst (tn, ml) ->
    let (_, _, t) = contains_type types tn in
    type_inst_converter types t
  | Flat (_, t) -> type_inst_converter types t
  | _ -> t

let type_size (t : tp) : int =
  match t with
  | One -> 0
  | Times _ -> 2
  | Plus _ -> 2
  | Arrow _ -> 2
  | With _ -> 2
  | _ -> 1

let rec contains (gamma : context) (x : varname) : tp =
  match gamma with
  | [] -> raise (CError ("Can't find " ^ x ^ " in context"))
  | (x', t)::gamma -> if x = x' then t else contains gamma x

let compile_label (l : label) : string =
  "TAG_" ^ (List.nth (String.split_on_char '\'' l) 1)

let compile_parm ((v, _) : parm) : string = "addr " ^ v

let rec compile_cmd (types : tpdefn list) (desttp : tp) (c : cmd) (prefix : string) : string =
  match c with
  | Read (v, s) ->
    (match s with
     | Small (PairPat (x, d)) -> prefix ^ "invoke_closure_fun (" ^ v ^ ", " ^ x ^ ", " ^ d ^ ");\n"
     | Small (InjPat (l, d)) -> prefix ^ "invoke_closure_record (" ^ v ^ ", " ^ compile_label l ^ ", " ^ d ^ ");"
     | Small (ShiftPat d) -> prefix ^ "invoke_closure_susp (" ^ v ^ ", " ^ d ^ ");\n"
     | Small _ -> raise (CError "Pat Error2")
     | Branches [(PairPat (x, y), c)] ->
       prefix ^ "addr " ^ x ^ " = " ^ v ^ "->ptr;\n" ^
       prefix ^ "addr " ^ y ^ " = (" ^ v ^ "+1)->ptr;\n" ^
       compile_cmd types desttp c prefix
     | Branches [(UnitPat, c)] -> compile_cmd types desttp c prefix
     | Branches [(ShiftPat x, c)] ->
       prefix ^ "addr " ^ x ^ " = " ^ v ^ "->ptr;\n" ^
       compile_cmd types desttp c prefix
     | Branches [(VarPat x, c)] ->
       prefix ^ "addr " ^ x ^ " = " ^ v ^ ";" ^
       compile_cmd types desttp c prefix
     | Branches pcl ->
       (List.fold_left
          (fun acc -> fun (p, c) ->
             match p with
             | InjPat (l, x) ->
               acc ^ "\n" ^
               prefix ^ "case " ^ (compile_label l) ^ ":{\n" ^
               prefix ^ "\taddr " ^ x ^ " = (" ^ v ^ "+1)->ptr;\n"^
               compile_cmd types desttp c ("\t" ^ prefix) ^
               prefix ^ "\tbreak;\n" ^ prefix ^ "}\n"
             | _ -> raise (CError "Pat Error1")
          ) (prefix ^ "switch (" ^ v ^ "->tag){") pcl) ^ prefix ^ "}\n")
  | Write (d, s) ->
    (match s with
     | Small (PairPat (x, y)) ->
       prefix ^ d ^ "->ptr = " ^ x ^ ";\n" ^
       prefix ^ "(" ^ d ^ "+1)->ptr = " ^ y ^ ";\n"
     | Small UnitPat -> prefix ^ d ^ " = NULL;\n"
     | Small (InjPat (l, v)) ->
       prefix ^ d ^ "->tag = " ^ compile_label l ^ ";\n" ^
       prefix ^ "(" ^ d ^ "+1)" ^ "->ptr = " ^ v ^ ";\n"
     | Small (ShiftPat v) -> prefix ^ d ^ "->ptr = " ^ v ^ ";\n"
     | Small (VarPat v) -> prefix ^ d ^ " = " ^ v ^ ";\n"
     | Branches _ -> raise (CError "Closure conversion wasn't complete or smth?"))
  | Cut (v, t, c1, c2) ->
    let t = type_inst_converter types t in
    let size = type_size t in
    prefix ^ "addr " ^ v ^ " = alloc(" ^ string_of_int size ^ ");\n" ^
    compile_cmd types t c1 prefix ^
    compile_cmd types desttp c2 prefix
  | Id (v1, v2) ->
    let desttp = type_inst_converter types desttp in
    (match desttp with
    | Times (_, _) ->
      v1 ^ "->ptr = " ^ v2 ^ "->ptr;\n" ^
      "(" ^ v1 ^ "+1)->ptr = (" ^ v2 ^ "+1)->ptr;\n"
    | One -> v1 ^ " = NULL;\n"
    | Plus _ ->
      v1 ^ "->tag = " ^ v2 ^ "->tag;\n" ^
      "(" ^ v1 ^ "+1)->ptr = (" ^ v2 ^ "+1)->ptr;\n"
    | Arrow _ ->
      v1 ^ "->fun = " ^ v2 ^ "->fun;\n" ^
      "(" ^ v1 ^ "+1)->env = (" ^ v2 ^ "+1)->env;\n"
    | With _ ->
      v1 ^ "->fun = " ^ v2 ^ "->fun;\n" ^
      "(" ^ v1 ^ "+1)->env = (" ^ v2 ^ "+1)->env;\n"      
    | Down _ ->
      v1 ^ "->ptr = " ^ v2 ^ "->ptr;\n"
    | Up _ ->
      v1 ^ "->fun = " ^ v2 ^ "->fun;\n" ^
      "(" ^ v1 ^ "+1)->env = (" ^ v2 ^ "+1)->env;\n"
    | Int32 ->
      v1 ^ "->int = " ^ v2 ^ "->int;\n"
    | _ -> raise (CError "Issue w unrolling")) ^
    prefix ^ v1 ^ " = " ^ v2 ^ ";\n"
  | Call (pn, d, pl) ->
    prefix ^ pn ^ "(" ^ String.concat ", " (d::pl) ^ ");\n"
  | Add (d, x, y) ->
    prefix ^ d ^ "->int = (" ^ x ^ "->int) + (" ^ y ^ "->int);\n"
  | Minus (d, x, y) ->
    prefix ^ d ^ "->int = (" ^ x ^ "->int) - (" ^ y ^ "->int);\n"
  | Div (d, x, y) ->
    prefix ^ d ^ "->int = (" ^ x ^ "->int) / (" ^ y ^ "->int);\n"
  | Mult (d, x, y) ->
    prefix ^ d ^ "->int = (" ^ x ^ "->int) * (" ^ y ^ "->int);\n"
  | Eq (d, x, y) ->
    prefix ^ d ^ "->tag = ((" ^ x ^ "->int) = (" ^ y ^ "->int)) ? TAG_true : TAG_false;\n" ^
    prefix ^ "addr _" ^ d ^ " = NULL;\n" ^
    prefix ^ d ^ "->ptr = _" ^ d ^ ";\n"
  | Set (d, i) ->
    prefix ^ d ^ "->int = " ^ string_of_int i ^ ";\n"
  | Close (cn, vn, vl) ->
    prefix ^ cn ^ "(" ^ String.concat ", " (vn::vl) ^ ");\n"
let compile_proc (types : tpdefn list) (pn : procname) ((d, dt) : parm) (pl : parm list) (c : cmd) =
  let header = "void " ^ pn ^ "(" ^ (String.concat ", " (List.map compile_parm ((d, dt)::pl))) ^ ") {\n" in
  let body = compile_cmd types dt c "\t" in
  header ^ body ^ "}\n"

let compile_clos (types : tpdefn list) (pn : procname) ((d, dt) : parm) (pl : parm list) (c : cmd) =
  let header1 = "void " ^ pn ^ "(" ^ (String.concat ", " (List.map compile_parm ((d, dt)::pl))) ^ ") {\n" in
  let prefix = "\t" in
  let etaname = d ^ "_eta" in
  let body1 =
    prefix ^ d ^ "->fun = &(" ^ pn ^ "$);\n" ^
    prefix ^ "addr " ^ etaname ^ " = alloc(" ^ string_of_int (List.length pl) ^ ");\n" ^
    List.fold_left (fun acc -> fun s -> acc ^ s) "" (List.mapi (fun i -> fun (v, _) -> prefix ^ "(" ^ etaname ^ " + " ^ string_of_int i ^ ")->ptr = " ^ v ^ ";\n") pl) ^
    prefix ^ "(" ^ d ^ "+1)->env = " ^ etaname ^ ";\n" ^
    "}\n"
  in
  let header2 = "void " ^ pn ^ "$(addr $params, addr $eta) {\n" in
  let unwrapetaandparams =
    (List.fold_left
       (fun acc -> fun s -> acc ^ s) ""
       (List.mapi (fun i -> fun (v, _) -> prefix ^ "addr " ^ v ^ " = ($eta+" ^ string_of_int i ^ ")->ptr;\n") pl))
  in
  let body2 =
    (match c with
     | Write (d, s) ->
       (match s with
        | Branches [(PairPat (v1, v2), c)] ->
          let dt = type_inst_converter types dt in
          prefix ^ "addr " ^ v1 ^ " = $params->ptr;\n" ^
          prefix ^ "addr " ^ v2 ^ " = ($params+1)->ptr;\n" ^
          compile_cmd types (match dt with | Arrow (_, t2) -> t2 | _ -> raise (CError "hm")) c prefix
        | Branches [(ShiftPat (v), c)] ->
          let dt = type_inst_converter types dt in
          prefix ^ "addr " ^ v ^ " = $params->ptr;\n" ^
          compile_cmd types (match dt with | Up t -> t | _ -> raise (CError "hm")) c prefix
        | Branches pcl ->
          let dt = type_inst_converter types dt in
          let ltl = (match dt with | With ltl -> ltl | _ -> raise (CError "hm")) in
          prefix ^ "tag label$ = $params->tag;\n" ^
          prefix ^ "addr dest$ = ($params+1)->ptr;\n" ^
          prefix ^ "switch (label$) {\n" ^
          (List.fold_left
             (fun acc -> fun (p, c) ->
                acc ^ 
                (match p with
                 | InjPat (l, d) ->
                   prefix ^ "case " ^ compile_label l ^ ":{\n" ^
                   prefix ^ "\t" ^ "addr " ^ d ^ " = dest$;\n" ^
                   compile_cmd types (contains ltl l) c (prefix ^ "\t") ^
                   prefix ^ "\tbreak;\n" ^
                   prefix ^ "}\n"
                 | _ -> raise (CError "Why are you getting non injective patterns in clos first write"))
             ) "" pcl) ^ prefix ^ "}\n"
        | _ -> raise (CError "Another error"))
     | _ -> raise (CError "Why is clos first write not a negative?"))
  in
  header2 ^ unwrapetaandparams ^ body2 ^ "}\n" ^ header1 ^ body1

let rec funcdecl (program : env) : string =
  let rec inner (program : env) (acc : string) : string =
    match program with
    | [] -> acc
    | ProcDefn (pn, d, pl, c)::program -> inner program (acc ^ ("void " ^ pn ^ "(" ^ (String.concat ", " (List.map compile_parm (d::pl))) ^ ");\n"))
    | ClosDefn (pn, d, pl, c)::program -> inner program (acc ^ ("void " ^ pn ^ "(" ^ (String.concat ", " (List.map compile_parm (d::pl))) ^ ");\n"))
    | TypeDefn (tn, ml, t)::program -> inner program (acc ^ ("void print$" ^ tn ^ "(addr val$);\n"))
    | _::program -> inner program acc
  in
  inner program ""

let rec generate_print_defined_types (program : env) : string =
  let rec inner (t : tp) (v : string) : string =
    match t with
    | Times (t1, t2) ->
      "addr " ^ v ^ "_pi1 = " ^ v ^ "->ptr;\n"^
      "addr " ^ v ^ "_pi2 = (" ^ v ^ "+1)->ptr;\n"^
      "printf(\"(\");\n" ^
      inner t1 (v ^ "_pi1") ^
      "printf(\", \");\n" ^
      inner t2 (v ^ "_pi2") ^
      "printf(\")\");\n"
    | One -> "printf(\"()\");\n"
    | Plus ltl ->
      "switch (" ^ v ^ "->tag){\n" ^
      List.fold_left
        (fun acc -> fun (l, t) ->
           let case =
             "case " ^ compile_label l ^ ":{\n" ^
             "addr " ^ v ^ "_" ^ compile_label l ^ " = (" ^ v ^ "+1)->ptr;\n" ^
             "printf(\"" ^ l  ^ " \");\n" ^
             inner t (v ^ "_" ^ compile_label l) ^
             "break;\n" ^
             "}\n"
           in
           acc ^ case) "" ltl ^
      "}\n"
    | Arrow _ -> "printf(\"clos\");\n"
    | With _ -> "printf(\"clos\");\n"
    | Down t ->
      "addr " ^ v ^ "_inshift = " ^ v ^ "->ptr;\n" ^
      "printf(\"<\");\n" ^
      inner t (v ^ "_inshift")
    | Up _ -> "printf(\"clos\");\n"
    | Flat (_, t) -> inner t v
    | TpInst (name, _) ->
      "print$" ^ name ^ "(" ^ v ^ ");\n"
    | Int32 ->
      "printf(\"%d\", " ^ v ^ "->int);\n"
  in
  match program with
    | [] -> ""
    | TypeDefn (tn, ml, t)::program ->
      (let defn =
         "void print$" ^ tn ^ "(addr val$) {\n" ^
         inner t "val$" ^
         "}\n"
       in
       defn ^ (generate_print_defined_types program))
    | ProcDefn (pn, (_, desttp), [], _)::program ->
      (let defn =
         "void print$" ^ pn ^ "(addr val$) {\n" ^
         inner desttp "val$" ^
         "}\n"
       in
       defn ^ (generate_print_defined_types program))
    | _::program -> generate_print_defined_types program

let generate_main (types : tpdefn list) (file_name : string) (program : env) : string =
  let prefix = "\t" in
  let header = "int main (){\n" in
  let rec inner (program : env) (acc : string) : string =
    match program with
    | [] -> acc
    | ProcDefn (pn, (_, desttp), pl, _)::program ->
      if (List.length pl) = 0
      then
        let called = 
          prefix ^ "addr " ^ pn ^ "$value = alloc(" ^ string_of_int (type_size (type_inst_converter types desttp)) ^ ");\n" ^
          prefix ^ pn ^ "(" ^ pn ^ "$value);\n" ^
          prefix ^ "printf(\"value %s = \", " ^ "\"" ^ pn ^ "\"" ^ ");\n" ^
          prefix ^ "print$" ^ pn ^ "(" ^ pn ^ "$value" ^ ");\n" ^
          prefix ^ "printf(\"\\n\");\n"
        in
        inner program (acc ^ called)
      else inner program acc
    | _::program -> inner program acc
  in
  (inner program (header ^ prefix ^ "init_heap(1024 * 1024);\n" ^ prefix ^ "freopen(\"" ^ file_name  ^".val\", \"w\", stdout);\n")) ^ "}\n"

let compile_program (file_name : string) (program : env) : string =
  let types = types program in 
  let tags = get_tags program in
  let tagsunion = "typedef enum tag {\n" ^ (String.concat ",\n" (List.map (fun x -> "\t" ^ (compile_label x)) tags)) ^ "\n} tag;" in
  let funcdecls = funcdecl program in
  let printfuncs = generate_print_defined_types program in
  let top = header ^ "\n" ^ tagsunion ^ "\n" ^ setup ^ funcdecls ^ printfuncs in
  let main = generate_main types file_name program in
  let rec inner (program : env) (acc : string) : string =
    match program with
    | [] -> acc
    | ProcDefn (pn, d, pl, c)::program -> inner program (acc ^ "\n" ^ compile_proc types pn d pl c)
    | ClosDefn (pn, d, pl, c)::program -> inner program (acc ^ "\n" ^ compile_clos types pn d pl c)
    | _::program -> inner program acc
  in
  (inner program top) ^ main

