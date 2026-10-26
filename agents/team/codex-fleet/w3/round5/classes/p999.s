# n=5 model=out iset=I1 prefix14_class=999
mov S2, P2
cmp P3, S2
cmovl P2, P3
cmovge S2, P3
mov S0, P1
cmp S0, P0
cmovg P1, P0
cmovg P0, S0
cmp S2, P0
mov P3, P2
cmovg S1, P0
cmovge P0, S2
cmovg S2, S1
cmp P1, P2
