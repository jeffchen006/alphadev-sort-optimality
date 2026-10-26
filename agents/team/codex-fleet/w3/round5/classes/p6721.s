# n=5 model=out iset=I1 prefix14_class=6721
mov S1, P3
cmp S1, P0
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
mov P0, P2
cmovg P0, P1
cmovge P1, P2
cmovg P2, P0
cmp P0, P3
cmovge P2, P3
cmovl P0, P3
cmp P1, S1
cmovg P0, P1
