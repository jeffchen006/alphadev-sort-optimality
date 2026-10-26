# n=5 model=out iset=I1 prefix14_class=2532
mov S2, P3
cmp P2, S2
mov S1, P1
cmovle S2, P2
cmovl P2, P3
cmp S1, P0
cmovl S1, P0
cmovl P0, P1
cmp P2, S1
cmovge S0, P2
cmovg P2, S1
cmovle S0, S1
mov S0, S2
cmovl S1, P2
