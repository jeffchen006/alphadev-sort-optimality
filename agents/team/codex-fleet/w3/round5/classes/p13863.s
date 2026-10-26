# n=5 model=out iset=I1 prefix14_class=13863
cmp P3, P0
mov S0, P3
cmovg P3, P0
mov S2, P1
cmovge P0, S0
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
mov S1, P0
cmp S2, S1
cmovg S1, S2
cmovl P0, S2
cmp P2, P3
cmovl S1, P2
