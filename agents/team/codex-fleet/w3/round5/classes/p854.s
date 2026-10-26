# n=5 model=out iset=I1 prefix14_class=854
cmp P0, P3
mov S1, P2
cmovl S2, P3
cmovge S2, P0
cmovge P0, P3
cmp S1, P1
cmovge S1, P1
cmovg P1, P2
mov S0, S1
mov P3, S2
cmp P1, P3
cmovge P3, P1
cmovg P1, S2
cmp P0, S1
