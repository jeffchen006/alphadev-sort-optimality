# n=5 model=out iset=I1 prefix14_class=8227
cmp P0, P1
cmovl S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
mov S1, P1
cmovge P3, S0
cmp S1, P3
cmovle P1, P3
mov S0, P2
cmovge S1, P3
mov P3, P1
