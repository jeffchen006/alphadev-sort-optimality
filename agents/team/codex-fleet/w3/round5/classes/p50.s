# n=5 model=out iset=I1 prefix14_class=50
mov S2, P2
mov S0, P1
cmp P3, P2
cmovle S2, P3
mov S1, S2
cmovl P3, P2
cmp P0, P1
cmovl P1, P0
cmovge S0, P0
cmp S2, P1
mov P2, S0
cmovl S2, P1
cmovge S1, P1
cmp P2, P3
