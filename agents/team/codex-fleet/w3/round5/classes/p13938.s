# n=5 model=out iset=I1 prefix14_class=13938
mov S2, P2
cmp P2, P1
cmovl P2, P1
cmovge S2, P1
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovle P0, S0
mov S1, P2
cmp P0, S1
cmovge S1, P0
cmovl P2, P0
cmp S2, P3
cmovg S1, P3
