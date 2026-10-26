# n=5 model=out iset=I1 prefix14_class=6921
cmp P2, P1
mov S0, P2
mov S2, P3
cmovl S0, P1
cmovg P2, P1
cmp P3, P0
cmovge P3, P0
cmovle S2, P0
cmp S2, S0
cmovl S1, S2
cmovle S2, S0
cmovge S1, S0
cmp P2, P3
cmovle S2, P3
