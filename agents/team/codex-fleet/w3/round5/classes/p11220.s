# n=5 model=out iset=I1 prefix14_class=11220
mov S2, P0
cmp P1, S2
cmovl S2, P1
cmovge P0, P1
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
mov P1, P3
cmovg P2, S1
cmp P1, P0
cmovl P1, P0
cmovge P3, P0
cmp S2, P2
cmovg P0, S2
