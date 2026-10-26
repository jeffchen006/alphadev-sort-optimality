# n=5 model=out iset=I1 prefix14_class=14331
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmovg P2, S2
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovle P3, S0
mov S1, P3
cmp S1, P0
cmovge S1, P0
cmovge P0, P3
cmp P2, P1
cmovg S0, P2
