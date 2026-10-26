# n=5 model=out iset=I1 prefix14_class=2455
mov S2, P0
mov S1, P3
cmp P0, P2
cmovle P0, P2
cmovge S2, P2
cmp P1, P3
cmovg P3, P1
cmovg P1, S1
cmovge S1, P3
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmp S2, P1
cmovl S0, P1
