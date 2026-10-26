# n=5 model=out iset=I1 prefix14_class=14370
mov S0, P2
cmp P1, P2
cmovl P2, P1
cmovg S0, P1
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P2, P0
mov P1, P2
cmovl P2, P0
cmovge P1, P0
mov P1, S0
cmp P1, P3
