# n=5 model=out iset=I1 prefix14_class=1781
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmp P3, P2
mov S1, P3
mov S0, P1
cmovl S1, P2
cmovg P3, P2
cmp S0, S1
cmovg P1, S1
cmovle S0, S1
cmp P3, P0
cmovge P2, P0
