# n=5 model=out iset=I1 prefix14_class=5518
cmp P1, P2
cmovl S0, P1
mov S2, P0
cmovle P1, P2
cmovl P2, S0
cmp S2, P3
cmovge S2, P3
cmovl P0, P3
cmp S2, P2
cmovl S1, P2
cmovge S1, S2
cmovge S2, P2
cmp P1, P0
mov P2, P0
