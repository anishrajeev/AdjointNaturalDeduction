# 15-x17 Lab 2 - OCaml

## Files

The lexer is in `lib/parse/nd_lexer.mll`
The parser is in `lib/parse/nd_parser.mly`
The abstract syntax is in `lib/parse/ast.mli` and `lib/parse/ast.ml`

## Caveats

If you have a single variable occurrence `f`, it could either
be a variable or a metavariable (= top-level function) without
parameters.  The parser cannot distinguish those, so you need to
account for that in your static analysis / typechecker.

## Other information

See the README.md file for the Lab 1 OCaml starter code
