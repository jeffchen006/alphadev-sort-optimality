# n=5 model=out iset=I1 prefix14_class=4589
mov S1, P3
cmp P2, P3
cmovle P3, P2
cmovg S1, P2
mov P2, P1
mov S2, S1
cmp P0, P1
cmovle P1, P0
cmovle P0, P2
cmp P0, S2
cmovl S2, P0
cmovg S1, P0
cmp P1, P3
cmovge S0, P1
