# n=2 R=6 iset=I0 model=out source=sat2_smt_cegis k=4
mov S0, P1
cmp P0, P1
cmovg S0, P0
cmovg P0, P1
out 0, P0
out 1, S0
