# n=5 model=out iset=I1 prefix14_class=12692
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovg P3, P0
cmp P1, P2
mov S0, P3
cmovl P0, P2
cmovl P2, P1
cmovl P1, P0
mov S2, P1
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
mov P3, S0
