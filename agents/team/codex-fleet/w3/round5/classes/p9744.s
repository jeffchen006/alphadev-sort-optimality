# n=5 model=out iset=I1 prefix14_class=9744
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovl S0, P3
mov S1, P1
cmp P0, S1
cmovl P1, P0
cmovl P0, S1
cmp P0, P2
mov S2, S0
cmovge S1, P0
cmovg P0, P2
cmovg P2, S1
mov P2, P0
