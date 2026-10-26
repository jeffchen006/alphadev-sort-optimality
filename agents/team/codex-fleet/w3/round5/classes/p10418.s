# n=5 model=out iset=I1 prefix14_class=10418
mov S0, P3
cmp P3, P0
cmovl S0, P0
cmovg P3, P0
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovle S2, P2
cmp S0, P1
cmovge P0, S0
cmovge S0, P1
cmovg P1, P0
cmp P3, S2
mov S1, S2
