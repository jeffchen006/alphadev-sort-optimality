# n=5 model=out iset=I1 prefix14_class=2442
mov S2, P2
cmp S2, P1
cmovg P2, P1
cmovl S2, P1
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovg P0, S1
cmovge S1, P3
cmp S1, S2
cmovle S1, S2
cmovl S2, P3
cmp P2, P0
cmovle S1, P0
