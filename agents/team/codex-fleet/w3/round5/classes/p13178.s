# n=5 model=out iset=I1 prefix14_class=13178
cmp P2, P0
cmovle S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovl S1, P3
mov S0, P0
cmp S1, S0
cmovle P0, S1
cmovg S0, S1
cmp P1, P2
mov P0, P2
