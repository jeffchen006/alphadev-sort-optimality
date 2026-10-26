# n=5 model=out iset=I1 prefix14_class=5406
mov S2, P2
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmp P0, P1
cmovge S1, P0
cmovl S1, P1
cmovg P0, P1
cmp P0, P3
mov P1, P0
cmovg P1, P3
cmovg P3, P0
cmp S2, S1
cmovle S0, S1
