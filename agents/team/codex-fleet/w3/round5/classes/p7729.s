# n=5 model=out iset=I1 prefix14_class=7729
mov S0, P2
cmp P2, P0
cmovle S0, P0
cmovge P2, P0
cmp P1, P3
mov S2, P1
cmovg P1, P3
cmovl S2, P3
cmp P2, P1
cmovl P0, P2
cmovl P2, P1
cmovl P1, P0
cmp S2, S0
cmovle S1, S2
