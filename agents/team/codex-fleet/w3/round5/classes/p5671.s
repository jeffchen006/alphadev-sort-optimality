# n=5 model=out iset=I1 prefix14_class=5671
cmp P0, P3
cmovge S1, P3
cmovl S1, P0
mov S0, S1
cmovg P3, P0
mov S2, P1
cmp P2, S2
cmovle S2, P2
cmovg P1, P2
cmp S2, S1
cmovle S1, S2
cmovl S2, S0
cmp P3, P1
cmovle S0, P3
