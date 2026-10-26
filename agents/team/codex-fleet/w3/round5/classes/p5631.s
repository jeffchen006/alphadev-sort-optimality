# n=5 model=out iset=I1 prefix14_class=5631
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovle S2, P3
mov P3, P2
cmp P2, P0
mov S1, P1
cmovle P3, P0
cmovl P0, P2
cmp S1, P0
cmovg P1, P0
cmovge P0, S1
cmp S2, P3
cmovge P2, S2
