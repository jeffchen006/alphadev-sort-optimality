# n=5 model=out iset=I1 prefix14_class=2036
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
cmovg P1, P0
mov S2, P3
cmp P2, P3
cmovge P3, P2
cmovl S2, P2
mov P0, P3
cmp P0, S0
cmovg P0, S0
cmovg S0, P3
mov P3, P0
mov S1, P1
