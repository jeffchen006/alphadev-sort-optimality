# n=5 model=out iset=I1 prefix14_class=3008
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
cmovl P0, S2
cmp P1, P2
cmovge S0, P1
mov S1, P3
cmovge P1, P2
cmovg P2, S0
cmp S1, P2
cmovge S1, P2
cmovge P2, P3
cmp P1, P0
mov P3, P1
