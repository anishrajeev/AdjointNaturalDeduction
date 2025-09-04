(** Top Level Environment *)

module U = Unix
module A = Ast

type serve_exit_state =
  | Serve_success
  | Serve_error

let serve_exit_code = function
  | Serve_success -> 0
  | Serve_error -> 1

type cmd_line_args = string list

let parse_cmd_line_args (): cmd_line_args =
  let argv = Sys.argv in
  if Array.length argv < 2
  then
    ( print_endline "expected at least one argument";
      raise Error_msg.Error )
  else List.tl (Array.to_list argv)

let rec load (raw : Ast.env) (filenames : string list) : Ast.env =
  match filenames with
  | (file::filenames) -> load (raw @ Parse.parse file) filenames
  | [] -> raw

let print_to_file (filename : string) (message : string) =
  let oc = open_out filename in
  Printf.fprintf oc "%s\n" message;
  close_out oc

let main () =
  try
    let file_names = (parse_cmd_line_args ()) in
    let inputname =
      match file_names with
      | n::_ -> n
      | [] -> raise (Error_msg.Error)
    in
    let env = load [] file_names in
    let () = print_endline ("Compiling " ^ inputname ^ " now") in
    
    let elaborated = Elaboration.elaborate_program env in
    let () = print_endline ("Elaborated") in
    
    let () = Statics.static_program_check elaborated in
    let () = print_endline ("Statics Checked") in
    
    let () = Ndtypecheck.type_program elaborated in
    let () = print_endline ("Type Checked") in
    
    let unnested = Unnest.unnest elaborated in
    let () = print_endline ("Unnested") in
    
    let compiled = Compile.translate_program unnested in
    let () = print_endline ("Compiled") in

    let eliminated = Cutidentity.eliminate_in_prog compiled in
      let () = print_endline ("Cut identity eliminated") in
    
    let closureconverted = Closureconverter.convert_program eliminated in
    let () = print_endline ("Closure Converted") in
    
    let () = print_to_file (inputname^".sax") (Saxast.Print.pp_env closureconverted) in
    let () = print_endline ("Wrote to " ^ inputname ^ ".sax") in

    let compiledtoc = Toc.compile_program inputname closureconverted in
    let () = print_endline ("Compiled to C") in

    let () = print_to_file (inputname^".sax.c") (compiledtoc) in
    let () = print_endline ("Wrote to " ^ inputname ^ ".sax.c") in

    let cmd = "gcc -w -O2 -o program " ^ inputname  ^ ".sax.c" in
    let _ = (match Sys.command cmd with
    | 0 -> print_endline "GCC compiled C code"
    | _ -> failwith "GCC Compilation failed.") in
    
    let cmd = "./program" in
    let _ = (match Sys.command cmd with
    | 0 -> print_endline (inputname ^ ".val created")
    | _ -> failwith "Executable failed")
    in
    serve_exit_code Serve_success |> Stdlib.exit
  with
  | Error_msg.Error ->
    print_endline "error";
    serve_exit_code Serve_error |> Stdlib.exit
  | Invalid_argument e ->
    print_endline e;
    print_endline "error";
    serve_exit_code Serve_error |> Stdlib.exit
