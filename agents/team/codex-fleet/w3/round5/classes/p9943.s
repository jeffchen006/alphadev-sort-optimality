# n=5 model=out iset=I1 prefix14_class=9943
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
cmovl P0, P1
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmovge P2, S1
mov S2, S0
cmp S0, P2
cmovg S0, P2
cmovl S2, P2
cmp P0, P3
mov P1, S0
