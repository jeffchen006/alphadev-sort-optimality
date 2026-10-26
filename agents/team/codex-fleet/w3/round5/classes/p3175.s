# n=5 model=out iset=I1 prefix14_class=3175
cmp P3, P1
mov S2, P1
cmovg P1, P3
cmovle S2, P3
cmp P2, P0
cmovge P3, P2
cmovge P2, P0
cmovg P0, P3
cmp S2, P2
cmovge S0, P2
cmovl S0, S2
cmovle S2, P2
cmp P0, P1
mov S1, P1
