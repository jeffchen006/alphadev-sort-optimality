# n=5 model=out iset=I1 prefix14_class=1058
mov S0, P0
mov S1, P3
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
cmp S1, P2
cmovg S1, P2
cmovge P2, P3
cmp S0, P2
mov S2, S0
cmovg S0, P2
cmovge P2, S2
mov S2, S1
mov P3, S0
