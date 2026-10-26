# n=5 model=out iset=I1 prefix14_class=9357
cmp P0, P3
mov S2, P3
cmovl S2, P0
cmovle P0, P3
mov S1, P2
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmp S1, S2
cmovge S0, S2
cmovg S2, S1
cmovg S1, S0
cmp P1, P0
cmovl P3, P0
