# n=5 model=out iset=I1 prefix14_class=12471
mov S0, P3
cmp P2, P0
mov S2, P2
cmovge S2, P0
cmovle P2, P0
cmp P3, P1
cmovg S0, P1
cmovg P1, P3
cmp S0, S2
cmovge P0, S2
cmovge S2, S0
cmovge S0, P0
cmp P2, P1
mov S1, P1
