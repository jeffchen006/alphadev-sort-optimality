# n=5 model=out iset=I1 prefix14_class=4869
cmp P3, P2
cmovl S0, P3
cmovge S0, P2
cmovg P2, P3
mov S2, P0
cmp P1, S2
cmovle S2, P1
cmovge P0, P1
mov S1, S2
cmp S2, S0
cmovl S1, S0
cmovle S0, S2
cmp P0, P2
cmovge S2, P2
