# n=5 model=out iset=I1 prefix14_class=6318
cmp P2, P1
mov S2, P2
cmovl S2, P1
cmovge P2, P1
mov S1, P0
cmp P0, P3
cmovle P0, P3
cmovg S1, P3
cmp S2, P0
mov P1, S2
cmovl P1, P0
cmovg S2, P0
cmp S1, P2
cmovge S0, P2
