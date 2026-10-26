# n=5 model=out iset=I1 prefix14_class=9781
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
cmovg P1, P3
mov S0, P0
cmp P2, P0
cmovg P0, P2
cmovg P2, S0
mov S1, P0
cmp S1, S2
cmovge P0, S2
cmovl S1, S2
cmp P1, P2
cmovge P3, P2
