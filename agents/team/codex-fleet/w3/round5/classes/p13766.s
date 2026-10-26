# n=5 model=out iset=I1 prefix14_class=13766
cmp P2, P0
mov S2, P1
cmovge S1, P0
cmovle S1, P2
cmovl P2, P0
cmp S2, P3
cmovg S2, P3
cmovg P3, P1
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
mov P3, S2
cmp S1, S2
