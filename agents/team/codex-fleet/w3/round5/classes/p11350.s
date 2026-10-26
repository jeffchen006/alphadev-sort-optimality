# n=5 model=out iset=I1 prefix14_class=11350
mov S0, P3
cmp P1, S0
cmovge P3, P1
cmovg P1, S0
cmp P2, P0
mov S2, P0
cmovle P0, P2
cmovge S2, P2
cmp P3, S2
cmovl S1, P3
cmovl P3, S2
cmovl S2, S1
mov P3, P0
cmp P1, P0
