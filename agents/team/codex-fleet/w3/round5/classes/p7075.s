# n=5 model=out iset=I1 prefix14_class=7075
mov S1, P3
mov S2, P2
cmp S1, P0
cmovle P3, P0
cmovge S1, P0
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmp S2, S1
cmovl P2, S1
cmovl S1, S2
mov S0, P1
cmovl S2, P2
cmp P1, P3
