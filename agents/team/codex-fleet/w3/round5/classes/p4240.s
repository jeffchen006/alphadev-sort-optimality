# n=5 model=out iset=I1 prefix14_class=4240
cmp P3, P1
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
mov S1, P0
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmp P3, P2
mov S2, P3
cmovl S2, P2
cmovle P2, P3
cmp S1, P1
cmovge P3, P1
