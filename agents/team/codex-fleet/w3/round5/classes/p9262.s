# n=5 model=out iset=I1 prefix14_class=9262
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmovg P1, S1
mov S0, P3
cmp P2, S0
cmovle P3, P2
cmovg S0, P2
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
cmp S0, P0
cmovg S2, S0
