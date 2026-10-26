# n=5 model=out iset=I1 prefix14_class=1570
mov S1, P2
mov S2, P3
cmp P0, S1
cmovl P2, P0
cmovge S1, P0
cmp P1, P3
cmovl P3, P1
cmovg S2, P1
mov S0, S1
cmp P2, P3
cmovg P1, P2
cmovge P2, P3
cmovg P3, P1
cmp S2, S1
