# n=5 model=out iset=I1 prefix14_class=8985
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
mov S2, P0
cmovg P3, S0
cmp S2, P1
cmovl P0, P1
cmovge S2, P1
cmovg P1, P0
cmp P2, P1
cmovl P0, P2
cmovge P1, P2
mov S1, P0
mov P2, S2
