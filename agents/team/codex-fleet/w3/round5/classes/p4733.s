# n=5 model=out iset=I1 prefix14_class=4733
cmp P3, P0
mov S0, P3
mov S2, P1
cmovl S0, P0
cmovg P3, P0
cmovl P0, P3
cmp P2, S2
cmovge S2, P2
cmovge P2, P1
cmp P2, P0
cmovg P0, P2
cmovge P2, P3
cmp S2, S0
cmovg S1, S0
