# n=5 model=out iset=I1 prefix14_class=1583
mov S1, P1
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P2, P1
cmovl S1, P2
cmovg P1, P2
cmp P3, S1
mov S0, P3
cmovg S0, S1
cmovg S1, P3
mov P3, P0
cmp P1, P3
