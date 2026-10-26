# n=5 model=out iset=I1 prefix14_class=12297
cmp P1, P2
cmovge S1, P1
cmovle S1, P2
cmovl P2, P1
mov S2, P2
cmp P0, P3
cmovge P1, P3
cmovge P3, P0
mov S0, P3
cmovg P0, P1
cmp S2, P0
cmovl P2, P0
cmovge S2, P0
cmovg P0, P2
