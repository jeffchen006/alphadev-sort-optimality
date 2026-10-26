# n=5 model=out iset=I1 prefix14_class=7557
mov S2, P2
cmp P3, P2
cmovg P2, P3
cmovl S2, P3
mov P3, S2
mov S0, P1
cmp P0, S0
cmovg S0, P0
cmovge P0, P1
cmp P3, P0
cmovl P3, P0
cmovl P0, S2
cmp P2, S0
cmovge S2, P2
