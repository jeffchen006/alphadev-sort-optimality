# n=5 model=out iset=I1 prefix14_class=14110
mov S1, P1
cmp P2, P1
cmovle P1, P2
mov S2, P3
cmovg S1, P2
cmp P0, S2
cmovge S2, P0
cmovl P3, P0
cmp S2, S1
cmovle P2, S2
cmovle S2, S1
mov S0, P3
cmovl S1, P2
cmp P1, P3
