# n=5 model=out iset=I1 prefix14_class=49
mov S0, P2
cmp P0, P2
mov S2, P1
cmovle S0, P0
mov S1, S0
cmovl P0, P2
cmp P3, P1
cmovl P1, P3
cmovge S2, P3
cmp S0, P1
cmovl S0, P1
mov P2, S2
cmovge S1, P1
cmp S2, P0
