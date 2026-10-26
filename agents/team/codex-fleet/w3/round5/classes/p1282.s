# n=5 model=out iset=I1 prefix14_class=1282
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
mov S0, P2
mov S2, P3
cmovg P0, S1
cmp S2, P1
cmovl S2, P1
cmovl P1, P3
cmp P2, S2
cmovle P2, S2
cmovge S0, S2
cmp P0, P1
cmovge P2, P0
