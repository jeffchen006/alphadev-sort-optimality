# n=5 model=out iset=I1 prefix14_class=1617
mov S1, P2
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovle S2, P1
cmp P3, S1
cmovl P2, P3
cmovge S1, P3
cmp P0, P2
cmovge P3, P2
cmovl P3, P0
cmovl P0, P2
cmp S1, S2
cmovge P1, S2
