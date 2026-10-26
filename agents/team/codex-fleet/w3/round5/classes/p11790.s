# n=5 model=out iset=I1 prefix14_class=11790
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovge P1, S1
mov S0, P3
cmp P0, P3
cmovl S0, P0
cmovle P0, P3
mov P3, P0
cmp P2, P0
cmovl P3, P2
cmovl P2, P0
cmp S0, P1
cmovg S2, P1
