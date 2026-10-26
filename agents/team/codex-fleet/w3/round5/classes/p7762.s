# n=5 model=out iset=I1 prefix14_class=7762
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovle P0, P1
mov S0, P3
cmp S0, P2
cmovge S0, P2
cmovle P3, P2
cmp S2, S0
cmovg S1, S0
cmovge S0, S2
cmovg S2, S1
mov P1, S0
cmp P3, P0
