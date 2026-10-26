# n=5 model=out iset=I1 prefix14_class=1777
cmp P1, P0
cmovge S2, P0
cmovg P0, P1
cmovg P1, S2
mov S0, P0
mov S1, P3
cmp P3, P2
cmovl S1, P2
cmovg P3, P2
cmp S0, S1
cmovg P0, S1
cmovle S0, S1
cmp P3, P1
cmovle S0, P3
