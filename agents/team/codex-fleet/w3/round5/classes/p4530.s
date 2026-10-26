# n=5 model=out iset=I1 prefix14_class=4530
cmp P0, P2
mov S0, P2
cmovge S0, P0
mov S1, P1
cmovg P0, P2
mov P2, P0
cmp S1, P3
cmovl S1, P3
cmovg P1, P3
cmp S0, S1
cmovge P3, S0
cmovge S0, S1
cmovg S1, P3
cmp P0, P1
