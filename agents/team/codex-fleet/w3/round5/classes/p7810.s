# n=5 model=out iset=I1 prefix14_class=7810
mov S0, P3
cmp S0, P2
cmovg P3, P2
cmovl S0, P2
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P0, P3
mov P2, P3
cmovl P2, P0
cmovg P3, P0
cmp P1, S0
cmovle P0, P1
