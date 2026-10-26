# n=5 model=out iset=I1 prefix14_class=4888
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
mov S0, S1
cmovl P1, P2
cmp S1, P3
cmovge S1, P3
cmovl S0, P3
cmp P1, P0
cmovg S2, P1
