# n=5 model=out iset=I1 prefix14_class=9157
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovg S0, P2
cmp P1, P0
cmovl P2, P0
cmovl P0, P1
cmovl P1, P2
mov S1, P3
cmp S1, P0
cmovge P3, P0
cmovge P0, S1
cmp P1, S0
cmovl S2, S0
