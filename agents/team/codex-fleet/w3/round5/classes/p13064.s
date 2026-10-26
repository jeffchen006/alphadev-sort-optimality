# n=5 model=out iset=I1 prefix14_class=13064
mov S1, P1
mov S2, P2
cmp P1, P0
cmovg P1, P0
cmovg P0, S1
cmp S2, P3
cmovle P2, P3
cmovg S2, P3
mov S0, P1
cmp S0, S2
cmovg S0, S2
cmovg S2, P1
cmp P0, P2
cmovge S0, P2
