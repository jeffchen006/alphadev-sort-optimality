# n=5 model=out iset=I1 prefix14_class=4375
mov S2, P2
cmp P0, P2
cmovl S2, P0
cmovl P0, P2
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp S2, P1
cmovge P2, S2
cmovl P2, P1
cmovge S2, P1
cmp P0, P3
mov S2, P2
