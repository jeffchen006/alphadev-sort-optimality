# n=5 model=out iset=I1 prefix14_class=2691
mov S2, P0
cmp P3, P1
cmovge S1, P1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovge P0, P2
cmovl S2, P2
cmp P1, S2
mov P3, P1
cmovg P3, S2
cmovle P1, S2
cmp S1, P0
cmovle P2, P0
