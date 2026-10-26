import Lean
import SortProof.Parse
/-
  `program_file% "path"` : reads a program file at elaboration time (path relative to the
  current Lean file), runs `parseProgram`, and returns the result as a LITERAL `ParsedProg`
  term. The kernel only sees the literal (inspect it with `#print`); the parser is trusted
  to read the file correctly.
-/
namespace SortProof
open Lean Elab Term Meta

deriving instance ToExpr for Cond
deriving instance ToExpr for Instr
deriving instance ToExpr for ParsedProg

syntax (name := programFile) "program_file% " str : term

@[term_elab programFile] def elabProgramFile : TermElab := fun stx _ => do
  match stx with
  | `(program_file% $p:str) =>
    let ctx ← readThe Core.Context
    let some dir := (System.FilePath.mk ctx.fileName).parent
      | throwError "no parent directory"
    let src ← IO.FS.readFile (dir / p.getString)
    match parseProgram src with
    | .ok pp => return toExpr pp
    | .error e => throwError "parse error in {p.getString}: {e}"
  | _ => throwUnsupportedSyntax

end SortProof
