# n=5 model=out iset=I1 prefix14_class=13705
mov S0, P0
cmp P0, P1
cmovge P0, P1
cmovl S0, P1
cmp P2, P3
cmovge P1, P3
cmovg P3, P2
mov S2, P0
cmovg P2, P1
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
mov P2, S0
cmp P3, P2
