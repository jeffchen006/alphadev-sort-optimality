# n=5 model=out iset=I1 prefix14_class=5984
cmp P1, P3
cmovge S0, P1
cmovle S0, P3
mov S1, S0
cmovle P3, P1
mov S2, P0
cmp P2, S2
cmovl P0, P2
cmovge S2, P2
cmp S2, S1
cmovle S1, S2
cmovl S2, S0
cmp P0, P3
cmovle P1, P3
