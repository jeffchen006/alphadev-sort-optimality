# n=5 model=out iset=I1 prefix14_class=8271
cmp P2, P0
mov S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P1, P3
mov S2, P3
cmovge P3, P1
cmovle S2, P1
cmp S2, P0
cmovg P1, S2
cmovge S2, P0
mov S2, P2
cmovg P0, P1
cmp P3, S2
