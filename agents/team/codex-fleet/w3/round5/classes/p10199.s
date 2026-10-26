# n=5 model=out iset=I1 prefix14_class=10199
cmp P2, P0
cmovge S1, P2
cmovg P2, P0
mov S0, P1
cmovg P0, S1
cmp P3, S0
cmovge S0, P3
cmovle P1, P3
cmp P0, S0
mov S2, P0
cmovle P0, S0
mov P0, P1
cmovl S0, S2
cmp P2, P1
