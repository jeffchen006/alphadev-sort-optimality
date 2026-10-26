# n=5 model=out iset=I1 prefix14_class=8460
cmp P1, P0
cmovge S0, P1
mov S2, P2
cmovg P1, P0
cmovl S0, P0
cmp S2, P3
cmovle S2, P3
cmovl P3, P2
cmp S0, S2
cmovl P0, S2
cmovl S2, S0
cmovl S0, P0
mov P2, P3
cmp P1, P3
