# n=5 model=out iset=I1 prefix14_class=2693
cmp P3, P1
cmovl S2, P3
cmovge S2, P1
cmovg P1, P3
mov S1, P0
cmp S1, P2
cmovge P0, P2
cmovle S1, P2
cmp P1, S1
mov P3, P1
cmovg P3, S1
cmovl P1, S1
cmp P0, S2
cmovg P2, P0
