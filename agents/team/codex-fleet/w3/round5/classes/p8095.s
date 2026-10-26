# n=5 model=out iset=I1 prefix14_class=8095
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovge S2, P1
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P2, S2
cmovle P1, S2
cmovl S2, P2
mov S0, P0
cmovl P2, P1
cmp P3, S0
