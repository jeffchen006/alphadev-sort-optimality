# n=5 model=out iset=I1 prefix14_class=3516
cmp P0, P3
mov S2, P2
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
mov S1, P0
cmp P1, P2
cmovge S2, P1
cmovl P2, P1
cmp P2, S1
mov P1, S2
cmovge S1, P2
cmovg P2, P0
cmp P3, P1
