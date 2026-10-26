# n=3 R=5 model=out iset=I1 source=w10_partial_sat
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovge S0, P0
cmp S0, P2
mov S1, P2
cmovge S1, S0
out 2, S1
cmovg S0, P2
cmp P1, P2
cmovg S0, P1
out 1, S0
cmovle P2, P1
out 0, P2
