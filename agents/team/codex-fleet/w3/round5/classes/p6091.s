# n=5 model=out iset=I1 prefix14_class=6091
cmp P3, P2
mov S0, P3
cmovle P3, P2
cmovle P2, S0
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovl S1, P0
cmp S1, P3
cmovge S2, S1
cmovge S1, P3
cmovge P3, S2
mov P3, P2
cmp P2, P1
