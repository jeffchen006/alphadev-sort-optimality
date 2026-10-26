# n=5 model=out iset=I1 prefix14_class=3181
cmp P2, P1
cmovg S2, P1
cmovg P1, P2
cmovle S2, P2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovge P0, P2
cmp S2, P3
cmovge S0, P3
cmovle S0, S2
cmovl S2, P3
cmp P1, P0
mov S0, P0
