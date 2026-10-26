# n=5 model=out iset=I1 prefix14_class=2694
cmp P3, P1
cmovl S2, P3
mov S1, P0
cmovge S2, P1
cmovg P1, P3
mov P3, P1
cmp S1, P2
cmovge P0, P2
cmovle S1, P2
cmp P1, S1
cmovle P1, S1
cmovg P3, S1
cmp P0, S2
cmovle P2, S2
