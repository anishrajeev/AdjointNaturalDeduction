val type_program : Ast.env -> unit
val type_subtype : (Ast.tpname * (Ast.mode list) * Ast.tp) list ->
  Ast.tp -> Ast.tp -> bool
