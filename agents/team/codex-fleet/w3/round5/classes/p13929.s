# n=5 model=out iset=I1 prefix14_class=13929
cmp P3, P0
mov S2, P3
cmovle S2, P0
cmovl P0, P3
cmp P2, P1
cmovge P3, P1
cmovge P1, P2
cmovg P2, P3
cmp S2, P1
mov S1, S2
cmovge S2, P1
cmovl S1, P1
mov P1, P2
cmp P0, P2
