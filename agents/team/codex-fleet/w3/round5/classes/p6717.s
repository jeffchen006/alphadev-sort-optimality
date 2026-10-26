# n=5 model=out iset=I1 prefix14_class=6717
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
mov S1, P0
cmovge P1, S0
cmp S1, P3
cmovg P0, P3
cmovl S1, P3
cmovge P3, S1
cmp P3, P2
cmovl P3, P2
cmovg S1, P2
mov P3, P1
mov P2, S1
