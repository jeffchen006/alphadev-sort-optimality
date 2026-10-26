# n=5 model=out iset=I1 prefix14_class=99
mov S1, P0
cmp P2, S1
cmovge P0, P2
mov S2, P1
cmovge P2, S1
cmp P3, S2
cmovg S2, P3
cmovl P1, P3
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
cmovl P2, S0
mov S0, P2
cmp S2, P0
