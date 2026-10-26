# n=5 model=out iset=I1 prefix14_class=3748
cmp P0, P2
mov S1, P2
cmovl S1, P0
cmovg P2, P0
mov P0, S1
mov S0, P1
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmp P3, P0
cmovl S1, P3
cmovg P0, P3
mov P3, P2
cmp P2, S0
