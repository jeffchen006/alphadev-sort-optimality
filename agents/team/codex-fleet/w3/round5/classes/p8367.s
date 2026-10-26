# n=5 model=out iset=I1 prefix14_class=8367
mov S1, P0
cmp P1, P2
cmovge S0, P2
cmovl S0, P1
cmovle P1, P2
mov P2, S0
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P0, S0
cmovge P2, P0
cmovge P0, S0
cmp S1, P1
cmovl S2, S1
