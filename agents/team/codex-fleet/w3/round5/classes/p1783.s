# n=5 model=out iset=I1 prefix14_class=1783
cmp P0, P1
mov S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, P3
mov S1, P3
mov S0, P1
cmovge S1, P2
cmovge P2, P3
cmp P1, S1
cmovl S0, S1
cmovg P1, S1
cmp P2, P0
cmovge P3, P0
