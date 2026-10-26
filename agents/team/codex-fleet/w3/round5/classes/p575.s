# n=5 model=out iset=I1 prefix14_class=575
cmp P3, P2
cmovge S2, P3
cmovle S2, P2
cmovle P2, P3
cmp P1, P0
mov S1, P0
cmovle S1, P1
cmovge P0, P1
mov S0, P2
cmp P0, S2
mov P3, S2
cmovl S2, P0
cmovg P3, P0
cmp S1, S0
