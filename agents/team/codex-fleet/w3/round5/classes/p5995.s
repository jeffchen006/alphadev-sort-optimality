# n=5 model=out iset=I1 prefix14_class=5995
cmp P3, P1
cmovge S2, P1
mov S1, P0
cmovle S2, P3
cmovl P3, P1
cmp P2, S1
cmovle S1, P2
cmovge P0, P2
cmp P0, P3
cmovg P1, P3
cmovg P3, P0
cmovg P0, P1
mov P2, S1
cmp S2, P2
