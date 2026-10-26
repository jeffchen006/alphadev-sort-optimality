# n=5 model=out iset=I1 prefix14_class=1417
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
mov S2, P2
cmovg P0, S0
cmp P1, P2
cmovge P2, P1
mov S1, P2
cmovg P1, S2
cmp P2, P0
cmovge S1, P0
mov S2, P1
cmovl P2, P0
cmp P1, P3
