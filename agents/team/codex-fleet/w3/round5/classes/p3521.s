# n=5 model=out iset=I1 prefix14_class=3521
cmp P1, P3
mov S1, P1
cmovg P1, P3
cmovge P3, S1
mov S1, P1
mov S2, P2
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmp P0, S1
cmovl P1, P0
cmovge S1, P0
cmp S2, P3
cmovg P2, P3
