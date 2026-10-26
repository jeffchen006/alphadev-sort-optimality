# n=5 model=out iset=I1 prefix14_class=12485
cmp P3, P1
mov S2, P1
cmovl P1, P3
cmovge S2, P3
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
cmp P1, P2
mov P3, P1
cmovge P3, P2
cmovl P1, P2
mov P3, P1
cmp P0, S2
