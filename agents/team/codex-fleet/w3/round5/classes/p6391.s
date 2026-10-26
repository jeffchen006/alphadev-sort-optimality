# n=5 model=out iset=I1 prefix14_class=6391
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
cmp P0, P1
mov S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P0, P3
mov S0, P0
cmovge S0, P3
cmovge P3, P0
mov S1, P1
mov P3, S0
