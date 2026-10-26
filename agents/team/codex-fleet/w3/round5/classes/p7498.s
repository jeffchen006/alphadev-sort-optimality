# n=5 model=out iset=I1 prefix14_class=7498
cmp P0, P2
cmovg S1, P0
cmovg P0, P2
cmovg P2, S1
mov S0, P3
cmp S0, P1
cmovge P3, P1
mov S2, P3
cmovl S0, P1
cmp P0, S2
cmovl S2, P0
mov S2, P2
cmovge P3, P0
cmovl P0, P3
