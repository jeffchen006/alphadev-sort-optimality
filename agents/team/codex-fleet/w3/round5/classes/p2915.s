# n=5 model=out iset=I1 prefix14_class=2915
cmp P0, P1
cmovl S1, P0
cmovge S1, P1
mov S2, P2
cmovge P1, P0
cmp P3, S2
cmovge S2, P3
cmovge P3, P2
mov P2, P1
cmp S2, P2
cmovle P1, S2
cmovl S2, P2
cmp S1, P3
cmovle S2, S1
