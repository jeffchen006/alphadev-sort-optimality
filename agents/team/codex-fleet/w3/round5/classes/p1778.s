# n=5 model=out iset=I1 prefix14_class=1778
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
cmovg P0, S2
mov S0, P1
mov S1, P3
cmp P3, P2
cmovl S1, P2
cmovg P3, P2
cmp S0, S1
cmovg P1, S1
cmovle S0, S1
cmp P3, P0
cmovle S0, P3
