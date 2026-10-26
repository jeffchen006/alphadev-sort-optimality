# n=5 model=out iset=I1 prefix14_class=10392
mov S2, P3
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
cmp P3, P2
mov S0, P0
cmovge P3, P2
cmovl S2, P2
cmp S0, S2
cmovl S0, S2
cmovle S2, P0
cmp P3, P1
cmovge P2, P3
