# n=5 model=out iset=I1 prefix14_class=12907
cmp P3, P1
mov S2, P0
cmovg S1, P1
cmovge P1, P3
cmovg P3, S1
cmp S2, P2
cmovl S2, P2
cmovge P0, P2
cmp P0, P3
mov S0, S2
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
cmp S2, P1
