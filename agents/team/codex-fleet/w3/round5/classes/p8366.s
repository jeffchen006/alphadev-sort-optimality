# n=5 model=out iset=I1 prefix14_class=8366
mov S1, P3
cmp P0, P2
cmovge S2, P2
cmovle S2, P0
mov S0, S2
cmovl P0, P2
cmp P1, P3
cmovle S1, P1
cmovg P3, P1
cmp S2, S1
cmovge S2, S1
cmovl S0, S1
cmp P3, P0
cmovle S1, P3
