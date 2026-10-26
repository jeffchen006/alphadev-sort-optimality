# n=5 model=out iset=I1 prefix14_class=11938
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovl P1, S0
cmp S2, P3
cmovg S0, S2
cmovge S2, P3
cmovg P3, S0
cmp P1, P2
cmovle S1, P1
