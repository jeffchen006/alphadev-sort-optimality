# n=5 model=out iset=I1 prefix14_class=1600
cmp P2, P0
mov S0, P1
mov S2, P2
cmovge P2, P0
cmovg P0, S2
cmovg S2, P2
cmp P3, S0
cmovge S0, P3
cmovl P1, P3
cmp P2, P1
cmovl P2, P1
cmovl P1, S2
mov S2, P2
mov P3, P0
