# n=5 model=out iset=I1 prefix14_class=10327
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
mov S1, P1
mov S0, P2
cmovl S2, P3
cmp P0, S1
cmovg P1, P0
cmovle S1, P0
cmp P1, S0
cmovg S0, P1
cmovge P1, P2
cmp S1, S2
cmovl S0, S1
