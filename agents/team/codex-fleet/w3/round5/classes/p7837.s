# n=5 model=out iset=I1 prefix14_class=7837
cmp P1, P3
mov S2, P3
cmovg P3, P1
cmovl S2, P1
cmp P0, P2
cmovle S1, P0
cmovge S1, P2
mov S0, S1
cmovg P2, P0
cmp S2, S1
cmovle S0, S2
cmovge S1, S2
cmp P3, P2
cmovl P0, P2
