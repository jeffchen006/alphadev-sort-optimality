# n=5 model=out iset=I1 prefix14_class=13945
mov S0, P2
cmp S0, P0
cmovg S0, P0
cmovle P2, P0
cmp P1, P3
cmovge S1, P1
cmovl S1, P3
cmovl P3, P1
cmp P2, S1
cmovle S2, S1
cmovle S1, P2
cmovle P2, S2
mov P2, P3
cmp P2, S0
