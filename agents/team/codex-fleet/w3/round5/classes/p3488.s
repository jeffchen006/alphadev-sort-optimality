# n=5 model=out iset=I1 prefix14_class=3488
mov S1, P2
cmp P0, P1
cmovl S2, P0
cmovge S2, P1
cmovle P0, P1
cmp S1, P3
cmovg S1, P3
cmovle P2, P3
mov S0, S1
cmp S2, S1
cmovg S0, S2
cmovge S2, S1
mov S1, P0
cmp P0, P2
