# n=5 model=out iset=I1 prefix14_class=5435
mov S2, P0
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
cmovle S0, P3
mov S1, P1
cmp P0, P2
cmovg P0, P2
cmovle S2, P2
cmp P0, S1
cmovg P1, P0
cmovl S1, P0
cmp S2, S0
cmovg P3, S0
