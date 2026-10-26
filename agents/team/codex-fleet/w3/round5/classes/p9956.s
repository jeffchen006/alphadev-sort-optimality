# n=5 model=out iset=I1 prefix14_class=9956
cmp P1, P0
mov S0, P0
cmovge S0, P1
cmovle P0, P1
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov S1, S0
cmovg P3, S2
cmp S0, P3
cmovg S0, P3
cmovg P3, S1
cmovge S1, S0
mov P3, P0
