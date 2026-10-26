# n=5 model=out iset=I1 prefix14_class=13668
mov S2, P3
cmp P2, P3
cmovl S2, P2
cmovg P3, P2
cmovl P2, P3
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, P0
cmovge P2, P0
cmovge P0, P3
cmp S2, P1
cmovle S0, P1
