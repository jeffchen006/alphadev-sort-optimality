# n=5 model=out iset=I1 prefix14_class=7439
cmp P3, P1
mov S1, P3
cmovg P3, P1
cmovl S1, P1
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P3, P0
mov P1, P3
cmovge P1, P0
cmovge P0, P3
mov P3, P2
cmp P2, S1
