# n=5 model=out iset=I1 prefix14_class=12921
mov S2, P1
cmp P2, P1
cmovl S2, P2
mov S0, S2
mov S1, P0
cmovg P1, P2
cmp P3, P0
cmovl P0, P3
cmovg S1, P3
cmp P0, S2
cmovg S2, P0
cmovge P0, S0
cmp S1, P1
cmovl P2, P1
