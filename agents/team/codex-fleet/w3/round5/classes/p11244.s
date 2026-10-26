# n=5 model=out iset=I1 prefix14_class=11244
cmp P3, P1
cmovge S2, P3
cmovl S2, P1
cmovg P3, P1
mov S1, P0
cmp P0, P2
cmovle S1, P2
cmovge P0, P2
cmp S1, S2
cmovge P1, S2
cmovge S2, S1
cmovge S1, P1
cmp P0, P3
mov S2, P0
