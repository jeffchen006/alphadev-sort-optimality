# n=5 model=out iset=I1 prefix14_class=9633
mov S1, P3
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
cmp P1, S1
mov P3, P2
mov S0, P1
cmovl S0, S1
cmovg P1, S1
cmp P3, P0
