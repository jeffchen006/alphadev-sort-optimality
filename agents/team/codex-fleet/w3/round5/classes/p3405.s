# n=5 model=out iset=I1 prefix14_class=3405
mov S2, P3
mov S0, P1
cmp P2, P3
cmovl P3, P2
cmovg S2, P2
cmp P0, S0
cmovge P1, P0
cmovl S0, P0
cmp S0, P3
cmovge P0, S0
cmovg S0, P3
cmovl P0, P3
mov P3, P1
cmp P3, S2
