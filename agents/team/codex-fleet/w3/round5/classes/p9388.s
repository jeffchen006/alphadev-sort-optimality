# n=5 model=out iset=I1 prefix14_class=9388
mov S1, P3
cmp S1, P0
cmovg P3, P0
cmovle S1, P0
cmp P2, P1
mov S2, P1
cmovl S2, P2
cmovl P2, P1
cmp S2, P3
cmovge P0, S2
mov P1, S1
cmovge S2, P3
cmovg P3, P0
cmp S1, P2
