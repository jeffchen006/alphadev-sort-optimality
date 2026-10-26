# n=5 model=out iset=I1 prefix14_class=5514
mov S0, P1
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmovl S2, P0
cmp P1, P3
cmovl P1, P3
cmovle P3, S0
cmp P3, P2
mov S0, P3
cmovl S0, P2
cmovge P3, P2
mov P3, S0
mov S1, S2
