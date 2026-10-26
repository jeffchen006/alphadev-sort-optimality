# n=5 model=out iset=I1 prefix14_class=1795
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovge P1, P3
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
cmovg P0, P2
mov S1, S2
cmp S0, S1
cmovle S1, S0
cmovl S0, S2
mov S2, P1
cmp P0, P1
