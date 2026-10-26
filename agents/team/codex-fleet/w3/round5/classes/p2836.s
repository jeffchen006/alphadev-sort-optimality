# n=5 model=out iset=I1 prefix14_class=2836
cmp P2, P3
cmovge S2, P2
cmovl S2, P3
cmovg P2, P3
cmp P0, P1
mov P3, P1
cmovg P3, P0
cmovle P1, P0
mov S1, P3
cmp S1, S2
cmovle S1, S2
cmovl S2, P3
cmp P1, P2
cmovge P3, P2
