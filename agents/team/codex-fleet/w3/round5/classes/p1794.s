# n=5 model=out iset=I1 prefix14_class=1794
mov S2, P3
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmp P0, P2
cmovge S1, P0
cmovl S1, P2
cmovg P0, P2
mov S0, S1
cmp S2, S1
cmovle S0, S2
cmovl S2, S1
mov S1, P0
cmp P1, P0
