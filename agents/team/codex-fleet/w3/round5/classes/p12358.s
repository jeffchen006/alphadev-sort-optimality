# n=5 model=out iset=I1 prefix14_class=12358
mov S2, P0
cmp S2, P1
mov S1, P2
cmovge S2, P1
cmovle P0, P1
cmp S1, P3
cmovle P2, P3
cmovg S1, P3
cmp S2, S1
mov P3, P0
cmovle S0, S2
cmovl S2, S1
cmovl S1, S0
cmp P3, P2
