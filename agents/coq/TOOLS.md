# coq agent — tools (installed 2026-10-24, user-local, no sudo)

Setup: `source agents/coq/tools/env.sh` (sets OPAMROOT=agents/coq/tools/opamroot, switch `rocq`).
Install script: `agents/coq/tools/install.sh` (log `agents/coq/logs/install.log`).

| tool | version | note |
|---|---|---|
| opam | 2.6.1 | static binary from github.com/ocaml/opam releases, `tools/bin/opam` |
| OCaml | 4.14.2 (ocaml-base-compiler) | opam switch `rocq` |
| Rocq (rocq-core, rocq-runtime) | 9.3.0 | `rocq compile`, `rocq c`; meta package rocq-prover 9.0.0 pinned, opam took core 9.3.0 |
| Rocq stdlib (rocq-stdlib) | 9.2.0 | `From Stdlib Require ...` |
| ocamlfind 1.9.8, dune 3.24.2, zarith 1.14 | | for extraction builds |

Native compiler: not enabled (`COQ_NATIVE_COMPILER_DEFAULT=no`); `native_compute` falls back to `vm_compute`
unless rocq-native is installed. Extraction to OCaml works with the same switch.
