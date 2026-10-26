# n=5 model=out iset=I1 prefix14_class=2734
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
mov S1, P0
cmovg P3, S2
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
mov P0, P1
cmp P2, P1
cmovge P1, P2
cmovl P0, P2
cmp S1, P3
cmovge S2, S1
